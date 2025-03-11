import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/prompt.dart';
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
        super(ChatInitial());

  Future<void> sendMessage(String message) async {
    try {
      emit(ChatLoading());
      // get documents from content
      List<Document> documents = await DocumentsRepository.instance.getDocuments();

      String content = documents.map((e) => e.content).join('\n');
      // Save the prompt to history
      final prompt = Prompt(
        '$message\n here some context: $content',
        DateTime.now(),
      );
      await _promptRepository.addPrompt(prompt);
      var allPrompts = _promptRepository.promptsHistory();
      print('allPrompts: $allPrompts');

      // Get response from LLM
      final response = await _fllamaRepository.runInference('$message\n here some context: $content', []);

      emit(ChatSuccess(response.latestResultString));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  List<Prompt> getPromptHistory() {
    return _promptRepository.promptsHistory();
  }
}
