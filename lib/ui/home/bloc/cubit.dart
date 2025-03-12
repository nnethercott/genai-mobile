import 'dart:math';

import 'package:fllama/fllama.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/prompt.dart';
import 'package:genai_mobile/repositories/chat_messages_repository.dart';
import 'package:genai_mobile/repositories/documents_repository.dart';
import 'package:genai_mobile/repositories/fllama_repository.dart';
import 'package:genai_mobile/repositories/prompt_repository.dart';
import 'package:genai_mobile/ui/home/bloc/state.dart';

class ChatCubit extends Cubit<ChatState> {
  final FllamaRepository _fllamaRepository;
  final PromptRepository _promptRepository;
  ChatCubit({
    required FllamaRepository fllamaRepository,
    required PromptRepository promptRepository,
  })  : _fllamaRepository = fllamaRepository,
        _promptRepository = promptRepository,
        super(const ChatState());

  Future<void> loadMessages() async {
    final chatMessagesRepository = ChatMessagesRepository.instance;
    final messages = await chatMessagesRepository.getMessages();
    emit(state.copyWith(status: ChatStatus.success, messages: messages));
  }

  Future<void> sendMessage(String message) async {
    try {
      emit(state.copyWith(status: ChatStatus.loading));
      // get documents from content
      List<Document> documents = await DocumentsRepository.instance.getAllDocuments();
      final ChatMessagesRepository chatMessagesRepository = ChatMessagesRepository.instance;

      String content = "";
      if (documents.isNotEmpty) {
        final docContent = documents.map((e) => e.content).join('\n');
        content += docContent.substring(0, min(4096, docContent.length));
      }

      // Save the prompt to history
      final prompt = Prompt(
        content.isEmpty ? message : '$message\nsome optional context to help with your answer: $content',
        DateTime.now(),
      );
      await _promptRepository.addPrompt(prompt);
      var allPrompts = _promptRepository.promptsHistory();
      print('allPrompts: $allPrompts');

      final pastMessages = await chatMessagesRepository.getMessages().then((messages) {
        return messages.reversed.map((m) {
          final role = m.isUser ? Role.user : Role.assistant;
          return Message(role, m.text);
        }).toList();
      });

      print("###################");
      for (final m in pastMessages) {
        print('Role: ${m.role}, text: ${m.text}');
      }

      // Get response from LLM
      final userMessage = await chatMessagesRepository.addMessage(text: message, isUserMessage: true);
      emit(state.copyWith(messages: [userMessage, ...state.messages]));

      final response = await _fllamaRepository.runInference(
        prompt.prompt,
        pastMessages,
      );
      final aiMessage = await chatMessagesRepository.addMessage(text: response.latestResultString, isUserMessage: false);
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: [aiMessage, ...state.messages],
      ));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  List<Prompt> getPromptHistory() {
    return _promptRepository.promptsHistory();
  }

  Future<void> clearChatHistory() async {
    await _promptRepository.cleanAllDB();
    await ChatMessagesRepository.instance.cleanAllDB();
    emit(state.copyWith(messages: []));
  }
}
