import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
import 'package:genai_mobile/rag/engine.dart';
import 'package:genai_mobile/repositories/documents_repository.dart';

// States
abstract class DocumentsState {}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<Document> documents;
  DocumentsLoaded(this.documents);
}

class DocumentsError extends DocumentsState {
  final String message;
  DocumentsError(this.message);
}

// Cubit
class DocumentsCubit extends Cubit<DocumentsState> {
  final DocumentsRepository _repository;

  DocumentsCubit(this._repository) : super(DocumentsInitial());

  Future<List<Document>> loadDocuments() async {
    try {
      emit(DocumentsLoading());
      final documents = await _repository.getAllDocuments();
      emit(DocumentsLoaded(documents));
      return documents;
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
    return [];
  }

  Future<void> loadDocumentsByType(DocumentType type) async {
    try {
      emit(DocumentsLoading());
      final documents = await _repository.getDocumentsByType(type);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<Document?> addDocument(String path) async {
    try {
      emit(DocumentsLoading());
      Document document = await documentFromPdf(path, DocumentType.documentation);
      await _repository.addDocument(document);
      final documents = await _repository.getAllDocuments();
      emit(DocumentsLoaded(documents));
      return document;
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
    return null;
  }

  Future<void> updateDocument(Document document) async {
    try {
      emit(DocumentsLoading());
      await _repository.updateDocument(document);
      final documents = await _repository.getAllDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> deleteDocument(Document document) async {
    try {
      emit(DocumentsLoading());
      await _repository.deleteDocument(document);
      final documents = await _repository.getAllDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> clearDocuments() async {
    await _repository.cleanAllDB();
    final documents = await _repository.getAllDocuments();
    emit(DocumentsLoaded(documents));
  }

  // FIXME: configure n relevant docs in settings or something,
  // right now just 1
  Future<List<Document>> loadRelevantDocuments(String prompt, VectorService vectorStore) async {
    try {
      emit(DocumentsLoading());
      final documents = await _repository.getRelevantDocuments(
        prompt: prompt,
        vectorStore: vectorStore,
        n: 1,
      );
      emit(DocumentsLoaded(documents));
      return documents;
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
    return [];
  }
}
