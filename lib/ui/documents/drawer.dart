import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/document_type.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ZipImportService {
  /// Imports a ZIP file from a URL and extracts all PDF files from it
  static Future<List<Document>> importZipFromUrl(String url) async {
    try {
      // Download the ZIP file like wget
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception('Failed to download ZIP file: ${response.statusCode}');
      }

      final bytes = await response.stream.toBytes();

      // Decode the ZIP archive from the response bytes
      final archive = ZipDecoder().decodeBytes(bytes);

      // Get the application documents directory to save extracted files
      final appDocDir = await getApplicationDocumentsDirectory();
      final extractionDir = Directory('${appDocDir.path}/extracted_zip_${DateTime.now().millisecondsSinceEpoch}');
      await extractionDir.create(recursive: true);

      Set<Document> extractedDocuments = {};

      // Extract only PDF files
      for (var file in archive) {
        if (file.isFile && path.extension(file.name).toLowerCase() == '.pdf') {
          try {
            final fileName = path.basename(file.name);
            final filePath = '${extractionDir.path}/$fileName';

            // Extract and save the file
            final outputFile = File(filePath);
            await outputFile.writeAsBytes(file.content as List<int>);

            // Create a Document object for each extracted PDF
            final document = await documentFromPdf(filePath, DocumentType.book);
            extractedDocuments.add(document);
            print('Successfully processed file: $fileName');
          } catch (e) {
            print('Error processing file ${file.name}: $e');
            // Continue processing other documents
          }
        }
      }

      return extractedDocuments.toList();
    } catch (e) {
      print('Error importing ZIP from URL: $e');
      rethrow;
    }
  }
}

// Updated DocumentsDrawer with ZIP import functionality
class DocumentsDrawer extends StatelessWidget {
  final List<Document> documents;
  final Future<void> Function() onPickFile;
  final Future<void> Function() onTakePicture;
  final Future<void> Function() onPickImage;
  final Future<void> Function(String) onImportZipFromUrl;
  final Function(Document) onDocumentSelected;
  final Function(Document) onDocumentDelete;

  const DocumentsDrawer({
    super.key,
    required this.documents,
    required this.onPickFile,
    required this.onTakePicture,
    required this.onPickImage,
    required this.onImportZipFromUrl,
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
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Center(
              child: Text(
                'Documents',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                      leading: Icon(
                        Icons.file_present,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(document.title),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'upload_file',
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  onPressed: onPickFile,
                  label: const Text('Upload file'),
                  icon: const Icon(Icons.file_upload),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'import_zip',
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  onPressed: () => _showZipUrlInputDialog(context),
                  label: const Text('Import ZIP from URL'),
                  icon: const Icon(Icons.archive),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showZipUrlInputDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import ZIP from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the URL of the ZIP file containing PDFs:'),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'ZIP URL',
                hintText: 'https://example.com/documents.zip',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                Navigator.pop(context);
                onImportZipFromUrl(url);
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}
