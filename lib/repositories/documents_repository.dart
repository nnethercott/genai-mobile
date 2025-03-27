import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
import 'package:genai_mobile/rag/engine.dart';
import 'package:genai_mobile/repositories/document_repository_impl.dart';

abstract class DocumentsRepository {
  DocumentsRepository._();
    static DocumentsRepository? _instance;

  static DocumentsRepository get instance {
    _instance ??= DocumentRepositoryImpl();
    return _instance!;
  }

  Future<void> addDocument(Document document);
  Future<void> updateDocument(Document document);
  Future<void> deleteDocument(Document document);
  Future<Document?> getDocument(String id);
  Future<List<Document>> getAllDocuments();
  Future<List<Document>> getRelevantDocuments({ required String prompt, required VectorService vectorStore, int n = 5 });
  Future<List<Document>> getDocumentsByType(DocumentType type);
  Future<void> cleanAllDB();
}
