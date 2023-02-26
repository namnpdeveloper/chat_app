import 'user.dart';

class Message {
  final String text;
  final User sender;
  final String createdAt;
  final bool isMine;
  
  Message(this.text, this.sender, this.createdAt, this.isMine);
}