import 'package:genai_mobile/models/chat_message.dart';
import 'package:genai_mobile/repositories/chat_messages_repository.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class ChatMessagesRepositoryImpl implements ChatMessagesRepository {
  static const String _boxName = 'chat_messages';

  ChatMessagesRepositoryImpl();

  @override
  Future<ChatMessage> addMessage({required String text, bool isUserMessage = false}) async {
    final box = await Hive.openBox<ChatMessage>(_boxName);
    final message = ChatMessage(id: Uuid().v4(), text: text, createdAt: DateTime.now().toIso8601String(), isUser: isUserMessage);
    await box.add(message);
    return message;
  }

  @override
  Future<List<ChatMessage>> getMessages() async {
    final box = await Hive.openBox<ChatMessage>(_boxName);
    return box.values.toList().reversed.toList();
  }

  @override
  Future<void> cleanAllDB() async {
    final box = await Hive.openBox<ChatMessage>(_boxName);
    await box.clear();
  }
}
