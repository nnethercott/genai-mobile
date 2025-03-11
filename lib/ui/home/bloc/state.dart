import 'package:equatable/equatable.dart';

import '../../../models/chat_message.dart';

enum ChatStatus {
  initial,
  loading,
  error,
  success,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatMessage> messages;
  final String error;
  const ChatState({this.status = ChatStatus.initial, this.messages = const [], this.error = ''});

  @override
  List<Object?> get props => [status, messages];

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }
}
