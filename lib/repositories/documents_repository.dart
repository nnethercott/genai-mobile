
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';

abstract class DocumentsRepository {
  Future<void> addDocument(Document document) ;
  Future<void> updateDocument(Document document) ;
  Future<void> deleteDocument(Document document) ;
  Future<Document> getDocument(String id) ;
  Future<List<Document>> getDocuments() ;
  Future<List<Document>> getDocumentsByType(DocumentType type) ;
}