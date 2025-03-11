import 'dart:async';

import 'package:fllama/fllama.dart';
import 'package:genai_mobile/models/Inference_response.dart';

class ToolFunction {
  final String name;
  final String description;
  final String parametersAsString;
  const ToolFunction({
    required this.description,
    required this.name,
    required this.parametersAsString,
  });
}

class FllamaRepository {
  final String _modelPath;
  // This is only required for multimodal models.
  // Multimodal models are rare.
  String? _mmprojPath;
  final _temperature = 0.5;
  final _topP = 1.0;
  final int _maxTokens = 2000;

  ToolFunction? _tool;

  factory FllamaRepository.getInstance(String modelPath, String? mmprojPath, ToolFunction? tool) {
    return FllamaRepository._(
      modelPath,
      mmprojPath,
      tool,
    );
  }

  FllamaRepository._(
    this._modelPath,
    this._mmprojPath,
    this._tool,
  );

  Future<InferenceResponse> runInference(String prompt, List<String> allResponses) async {
    final request = OpenAiRequest(
      tools: [
        if (_tool != null)
          Tool(
            name: _tool!.name,
            jsonSchema: _tool!.parametersAsString,
          ),
      ],
      maxTokens: _maxTokens.round(),
      messages: [
        Message(Role.user, prompt),
      ],
      numGpuLayers: 99,
      /* this seems to have no adverse effects in environments w/o GPU support, ex. Android and web */
      modelPath: _modelPath,
      mmprojPath: _mmprojPath,
      frequencyPenalty: 0.0,
      // Don't use below 1.1, LLMs without a repeat penalty
      // will repeat the same token.
      presencePenalty: 1.1,
      topP: _topP,
      contextSize: 4096,
      // Don't use 0.0, some models will repeat
      // the same token.
      temperature: _temperature,
      logger: (log) {
        // ignore: avoid_print
        print('[llama.cpp] $log');
      },
    );

    List<String> allResponses = [];
    String latestResultJson = '';
    String latestResultString = '';

    final completer = Completer<void>();

    int requestId = await fllamaChat(request, (response, responseJson, done) {
      allResponses.add(responseJson);
      latestResultString = response;
      latestResultJson = responseJson;
      if (done) {
        completer.complete();
      }
    });

    await completer.future;

    return InferenceResponse(
      requestId: requestId,
      latestResultString: latestResultString,
      latestResultJson: latestResultJson,
      allResponses: allResponses,
    );
  }
}
