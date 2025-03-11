abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatSuccess extends ChatState {
  final String response;
  ChatSuccess(this.response);
}
