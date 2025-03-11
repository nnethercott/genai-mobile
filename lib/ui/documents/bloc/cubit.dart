import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
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

  Future<void> loadDocuments() async {
    try {
      emit(DocumentsLoading());
      final documents = await _repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
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

  Future<void> addDocument(File file) async {
    try {
      emit(DocumentsLoading());
      Document document = await documentFromPdf(file.path , DocumentType.documentation);
      await _repository.addDocument(document);
      final documents = await _repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> updateDocument(Document document) async {
    try {
      emit(DocumentsLoading());
      await _repository.updateDocument(document);
      final documents = await _repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> deleteDocument(Document document) async {
    try {
      emit(DocumentsLoading());
      await _repository.deleteDocument(document);
      final documents = await _repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
}
