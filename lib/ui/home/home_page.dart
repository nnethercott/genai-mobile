import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/providers/theme_provider.dart';
import 'package:genai_mobile/ui/documents/bloc/cubit.dart';
import 'package:genai_mobile/ui/documents/drawer.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
      _isLoading = true;
    });

    // Simulate response (replace with actual API call)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _messages.insert(0, ChatMessage(text: "This is a simulated response to: $text", isUserMessage: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        if (state is DocumentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DocumentsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is DocumentsLoaded) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 1,
              actions: [
                IconButton(
                  icon: Icon(context.watch<ThemeProvider>().isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                  tooltip: 'Toggle theme',
                ),
              ],
            ),
            drawer: DocumentsDrawer(
              documents: state.documents,
              onDocumentSelected: (document) {
                setState(() {
                  _messages.insert(0, ChatMessage(text: "Selected: ${document.title}", isUserMessage: true, file: File(document.contentPath ?? '')));
                });
                Navigator.pop(context);
              },
              onDocumentDelete: (document) {
                context.read<DocumentsCubit>().deleteDocument(document);
              },
              onPickFile: () async {
                try {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    final path = result.files.single.path!;
                    if (path.toLowerCase().endsWith('.pdf')) {
                      context.read<DocumentsCubit>().addDocument(path);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a PDF file')),
                      );
                    }
                  }
                } catch (e) {
                  print('Error picking file: $e');
                }
              },
              onTakePicture: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    File file = File(photo.path);
                    print('Photo picked: ${file.path}');
                  }
                } catch (e) {
                  print('Error taking picture: $e');
                }
              },
              onPickImage: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    File file = File(image.path);
                    // TODO use cubit
                  }
                } catch (e) {
                  print('Error picking image: $e');
                }
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(child: Text('Send a message or upload a document to begin', style: TextStyle(color: Colors.grey, fontSize: 16)))
                      : ListView.builder(reverse: true, itemCount: _messages.length, itemBuilder: (context, index) => _messages[index]),
                ),
                const Divider(height: 1),
                if (_isLoading) const LinearProgressIndicator(),
                Container(decoration: BoxDecoration(color: Theme.of(context).cardColor), child: _buildTextComposer()),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(Icons.attach_file),
            ),
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Send a message',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(icon: const Icon(Icons.send), onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final File? file;

  const ChatMessage({super.key, required this.text, required this.isUserMessage, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUserMessage) CircleAvatar(backgroundColor: Colors.blue[300], child: const Text('AI')),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(color: isUserMessage ? Colors.blue[100] : Colors.grey[200], borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text),
                  if (file != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_file, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            file!.path.split('/').last,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUserMessage) CircleAvatar(backgroundColor: Colors.blue, child: const Text('You')),
        ],
      ),
    );
  }
}

/*


  Future<void> _pickFileFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        onDocumentSelected(file);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        File file = File(photo.path);
        onDocumentSelected(file);
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File file = File(image.path);
        onDocumentSelected(file);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }



*/
