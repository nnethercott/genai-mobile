import 'package:genai_mobile/models/chat_message.dart';
import 'package:genai_mobile/repositories/chat_messages_repository_impl.dart';

abstract class ChatMessagesRepository {
  ChatMessagesRepository._();
  static ChatMessagesRepository? _instance;

  static ChatMessagesRepository get instance {
    _instance ??= ChatMessagesRepositoryImpl();
    return _instance!;
  }

  Future<ChatMessage> addMessage({required String text, bool isUserMessage = false});
  Future<List<ChatMessage>> getMessages();
}
