import 'package:genai_mobile/models/document_type.dart';
import 'package:hive/hive.dart';

class Document extends HiveObject {
  String id; // UUID.v4
  String? content; // content can be null if the document is a file
  String? contentPath; // contentPath can be null if the document is a text
  String title;
  DocumentType type;
  String createdAt;

  Document({required this.id, required this.content, required this.contentPath, required this.title, required this.type, required this.createdAt});
}