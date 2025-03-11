import 'package:genai_mobile/models/document_type.dart';
import 'package:genai_mobile/utils.dart/pdf_utils.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class Document extends HiveObject {
  String id; // UUID.v4
  String? content; // content can be null if the document is a file
  String? contentPath; // contentPath can be null if the document is a text
  String title;
  DocumentType type;
  String createdAt;

  Document({required this.id, required this.content, required this.contentPath, required this.title, required this.type, required this.createdAt});
}

Future<Document> documentFromPdf(String path, DocumentType type) async {
  final content = await extractTextFromPdf(path);
  final title = path.split('/').last;
  final createdAt = DateTime.now().toIso8601String();

  return Document(id: Uuid().v4(), content: content, contentPath: path, title: title, type: type, createdAt: createdAt);
}
