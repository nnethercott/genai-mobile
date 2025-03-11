import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/prompt.dart';
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

      // Save the prompt to history
      final prompt = Prompt(
        message,
        DateTime.now(),
      );
      await _promptRepository.addPrompt(prompt);

      // Get response from LLM
      final response = await _fllamaRepository.runInference(message);

      emit(ChatSuccess(response.latestResultString));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  List<Prompt> getPromptHistory() {
    return _promptRepository.promptsHistory();
  }
}
