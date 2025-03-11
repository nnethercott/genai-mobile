import 'package:genai_mobile/models/document.dart';

import 'package:genai_mobile/models/document_type.dart';
import 'package:hive_ce/hive.dart';

import 'documents_repository.dart';

class DocumentRepositoryImpl implements DocumentsRepository {

  static const String _boxName = 'documents';

  DocumentRepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    await Hive.openBox<Document>(_boxName);
  }

  @override
  Future<void> addDocument(Document document) async {
    await _init();
    await Hive.box<Document>(_boxName).add(document);
  }

  @override
  Future<void> deleteDocument(Document document) async {
    await _init();
    await Hive.box<Document>(_boxName).delete(document.id);
  }

  @override
  Future<Document?> getDocument(String id) async {
    await _init();
    return  Hive.box<Document>(_boxName).get(id);
  }

  @override
  Future<List<Document>> getDocuments() async {
    await _init();
    return Hive.box<Document>(_boxName).values.toList() ;
  }

  @override
  Future<List<Document>> getDocumentsByType(DocumentType type) async {
    await _init();
    return Hive.box<Document>(_boxName).values.where((document) => document.type == type).toList();
  }

  @override
  Future<void> updateDocument(Document document) async {
    return Hive.box<Document>(_boxName).put(document.id, document);
  }

}
