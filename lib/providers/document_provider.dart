import 'package:flutter/material.dart';
import 'package:genai_mobile/models/document.dart';

class DocumentProvider extends ChangeNotifier {
  Document? _selectedDocument;

  Document? get selectedDocument => _selectedDocument;

  void setSelectedDocument(Document? document) {
    _selectedDocument = document;
    notifyListeners();
  }

  void clearSelectedDocument() {
    _selectedDocument = null;
    notifyListeners();
  }
}
