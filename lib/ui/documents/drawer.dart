import 'package:flutter/material.dart';
import 'package:genai_mobile/models/document.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class DocumentsDrawer extends StatelessWidget {
  final List<Document> documents;
  final Future<void> Function() onPickFile;
  final Future<void> Function() onTakePicture;
  final Future<void> Function() onPickImage;
  final Function(Document) onDocumentSelected;
  final Function(Document) onDocumentDelete;

  const DocumentsDrawer({
    super.key,
    required this.documents,
    required this.onPickFile,
    required this.onTakePicture,
    required this.onPickImage,
    required this.onDocumentSelected,
    required this.onDocumentDelete,
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
                'Documents',
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
                ...documents.map((document) => ListTile(
                      leading: const Icon(Icons.file_present),
                      title: Text(document.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Document'),
                              content: Text('Are you sure you want to delete "${document.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onDocumentDelete(document);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () => onDocumentSelected(document),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: onPickFile,
              label: const Text('Upload file'),
              icon: const Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
    );
  }
}
