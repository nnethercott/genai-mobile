import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:image_picker/image_picker.dart';

class DocumentsDrawer extends StatelessWidget {
  final List<Document> documents;
  final Future<void> Function() onPickFile;
  final Future<void> Function() onTakePicture;
  final Future<void> Function() onPickImage;
  final Function(File) onDocumentSelected;

  const DocumentsDrawer({
    super.key,
    required this.documents,
    required this.onPickFile,
    required this.onTakePicture,
    required this.onPickImage,
    required this.onDocumentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: const Center(
              child: Text(
                'Upload Document',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.file_present),
                  title: const Text('Upload file'),
                  onTap: onPickFile,
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: onPickImage,
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a picture'),
                  onTap: onTakePicture,
                ),
                ...documents.map((document) => ListTile(
                      leading: const Icon(Icons.file_present),
                      title: Text(document.title),
                      onTap: () => onDocumentSelected(File(document.contentPath ?? '')),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
