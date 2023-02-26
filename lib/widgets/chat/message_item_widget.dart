import 'package:flutter/material.dart';
import '../../models/message.dart';

class MessageItemWidget extends StatelessWidget {
  MessageItemWidget(
      this.message, {
        required this.key,
      });

  final Key key;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
          message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: message.isMine ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: message.isMine ? const Radius.circular(12) : const Radius.circular(0),
                  bottomRight: message.isMine ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message.sender.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: message.isMine
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMine
                          ? Colors.black
                          : Colors.white,
                    ),
                    textAlign: message.isMine ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: message.isMine ? null : 120,
          right: message.isMine ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              message.sender.avatarUrl ?? '',
            ),
          ),
        ),
      ],
    );
  }
}
