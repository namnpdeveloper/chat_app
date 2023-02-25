

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return Text('OK');
            },
          itemCount: 10,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('/chats/6Cae2rI6R2j9FWSsXmM5/messages')
          .snapshots().listen((event) {
            event.docs.forEach((element) {
              print(element['text']);
            });
          });
        },
      ),
    );
  }

}