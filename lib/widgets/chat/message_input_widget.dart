import 'package:chat_app/common/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageInputWidget extends StatefulWidget {
  const MessageInputWidget({Key? key}) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  var _inputMessage = '';
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    _messageController.clear();
    final userData = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
    FirebaseFirestore.instance.collection(ChatConstants.chatCollection).add({
      ChatConstants.text: _inputMessage,
      ChatConstants.createdAt: Timestamp.now(),
      ChatConstants.userId: _user?.uid,
      ChatConstants.userName: userData[ChatConstants.userName],
      ChatConstants.userAvatar: userData[ChatConstants.userAvatar],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _messageController,
            decoration: const InputDecoration(labelText: 'Send a message...'),
            onChanged: (value) {
              setState(() {
                _inputMessage = value;
              });
            },
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _inputMessage.trim().isNotEmpty ? _sendMessage : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
