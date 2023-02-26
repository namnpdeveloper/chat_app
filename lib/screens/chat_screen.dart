import 'package:chat_app/widgets/chat/message_input_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../widgets/chat/list_messages_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.getInitialMessage().then((value) {
      debugPrint('getInitialMessage $value');
    });
    FirebaseMessaging.onMessage.listen(_showFlutterNotification); // onMessage (When App In Foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { // onLaunch (when CLINK Notifications - BG/terminated)
      debugPrint('onMessageOpenedApp $message');
      return;
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // onResume (When App In BG/terminated)
    fbm.subscribeToTopic('chat');
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await _setupFlutterNotifications();
    _showFlutterNotification(message);
    debugPrint('a background message ${message.messageId}');
  }

  Future<void> _setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    // Android
    channel = const AndroidNotificationChannel(
      'channel_id',
      'Notification Title',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void _showFlutterNotification(RemoteMessage message) async {
    if(!isFlutterLocalNotificationsInitialized) {
      await _setupFlutterNotifications();
    }
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(
              child: MessagesWidget(),
            ),
            MessageInputWidget(),
          ],
        ),
      ),
    );
  }
}
