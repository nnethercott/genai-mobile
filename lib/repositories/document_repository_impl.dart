import 'dart:async';

import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
import 'package:genai_mobile/rag/engine.dart';
import 'package:hive_ce/hive.dart';

import 'documents_repository.dart';

class DocumentRepositoryImpl implements DocumentsRepository {
  static const String _boxName = 'documents';
  final Completer _isReady = Completer.sync();
  bool isReadyIndicator = false;

  DocumentRepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    await Hive.openBox<Document>(_boxName);

    if (!isReadyIndicator) {
      _isReady.complete();
      isReadyIndicator = true;
    }
  }

  @override
  Future<void> addDocument(Document document) async {
    await _isReady.future;
    await Hive.box<Document>(_boxName).add(document);
  }

  @override
  Future<void> deleteDocument(Document document) async {
    await _isReady.future;
    final box = Hive.box<Document>(_boxName);
    final key = box.values.toList().indexWhere((d) => d.id == document.id);
    if (key != -1) {
      await box.deleteAt(key);
    }
  }

  @override
  Future<Document?> getDocument(String id) async {
    await _isReady.future;
    return Hive.box<Document>(_boxName).get(id);
  }

  @override
  Future<List<Document>> getAllDocuments() async {
    await _init();
    return Hive.box<Document>(_boxName).values.toList();
  }

  @override
  Future<List<Document>> getDocumentsByType(DocumentType type) async {
    await _isReady.future;
    return Hive.box<Document>(
      _boxName,
    ).values.where((document) => document.type == type).toList();
  }

  @override
  Future<void> updateDocument(Document document) async {
    await _init();
    return Hive.box<Document>(_boxName).put(document.id, document);
  }

  @override
  Future<List<Document>> getRelevantDocuments({
    required String prompt,
    required VectorService vectorStore,
    int n = 5,
  }) async {
    final docIds = await vectorStore.query(prompt, n);
    return await getAllDocuments().then(
      (docs) => docs.where((d) => docIds.contains(d.id)).toList(),
    );
  }

  @override
  Future<void> cleanAllDB() async {
    await _isReady.future;
    // await Hive.box<Document>(_boxName).clear();
  }
}
