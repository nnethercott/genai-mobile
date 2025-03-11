import 'package:genai_mobile/models/chat_message.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
import 'package:genai_mobile/models/prompt.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Prompt>(),
  AdapterSpec<Document>(),
  AdapterSpec<DocumentType>(),
  AdapterSpec<ChatMessage>(),
])
// Annotations must be on some element
// ignore: unused_element
void _() {}
