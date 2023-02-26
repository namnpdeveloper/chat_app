import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../models/user.dart' as app;
import 'message_item_widget.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageStream = FirebaseFirestore.instance
        .collection(ChatConstants.chatCollection)
        .orderBy(ChatConstants.createdAt, descending: true)
        .snapshots();
    return StreamBuilder(
      stream: messageStream,
      builder: (_, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chats = chatSnapshot.data?.docs ?? [];
        final currentUser = FirebaseAuth.instance.currentUser;
        if (chats.isEmpty) {
          return const Center(
            child: Text('No data'),
          );
        }
        return ListView.builder(
          reverse: true,
          itemBuilder: (_, index) {
            final messageSnapshot = chats[index];
            final message = Message(
                messageSnapshot[ChatConstants.text],
                app.User(
                  messageSnapshot[ChatConstants.userId],
                  messageSnapshot[ChatConstants.userName],
                  messageSnapshot[ChatConstants.userAvatar],
                ),
                messageSnapshot[ChatConstants.createdAt].toString(),
                messageSnapshot[ChatConstants.userId] == currentUser?.uid);
            return MessageItemWidget(
                key: ValueKey(messageSnapshot.id,),
                message
            );
          },
          itemCount: chats.length,
        );
      },
    );
  }
}
