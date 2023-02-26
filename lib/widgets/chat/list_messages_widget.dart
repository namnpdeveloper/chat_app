import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';

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
        if(chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chats = chatSnapshot.data?.docs ?? [];
        if(chats.isEmpty) return const Center(child: Text('No data'),);
        return ListView.builder(
          reverse: true,
          itemBuilder: (_, index) {
            return Text(chats[index][ChatConstants.text]);
          },
          itemCount: chats.length,
        );
      },
    );
  }
}
