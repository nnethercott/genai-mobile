import 'package:hive_ce/hive.dart';

class ChatMessage extends HiveObject {
  String id;
  String text;
  String createdAt;
  bool isUser;

  ChatMessage({required this.id, required this.text, required this.createdAt, required this.isUser});
}
