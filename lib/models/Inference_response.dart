class InferenceResponse {
  final int requestId;
  final String latestResultString;
  final String latestResultJson;
  final List<String> allResponses;
  InferenceResponse({
    required this.requestId,
    required this.latestResultString,
    required this.latestResultJson,
    required this.allResponses,
  });
}
