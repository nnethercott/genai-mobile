import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/models/ai_model.dart';
import 'package:genai_mobile/providers/document_provider.dart';
import 'package:genai_mobile/providers/theme_provider.dart';
import 'package:genai_mobile/ui/documents/bloc/cubit.dart';
import 'package:genai_mobile/ui/documents/drawer.dart';
import 'package:genai_mobile/ui/home/bloc/cubit.dart';
import 'package:genai_mobile/ui/home/bloc/model_selection_cubit.dart';
import 'package:genai_mobile/ui/home/bloc/state.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    final selectedDoc = context.read<DocumentProvider>().selectedDocument;
    context.read<ChatCubit>().sendMessage(text, selectedDoc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
      if (state.status == ChatStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      }
    }, builder: (context, chatState) {
      return BlocBuilder<DocumentsCubit, DocumentsState>(
        builder: (context, documentsState) {
          if (documentsState is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (documentsState is DocumentsError) {
            return Center(child: Text('Error: ${documentsState.message}'));
          }

          if (documentsState is DocumentsLoaded) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 1,
                actions: [
                  BlocBuilder<ModelSelectionCubit, ModelSelectionState>(
                    builder: (context, state) {
                      final currentModel = AIModels.getModelById((state as ModelSelectionInitial).selectedModel);
                      return PopupMenuButton<String>(
                        icon: const Icon(Icons.settings),
                        tooltip: 'Select AI Model',
                        onSelected: (String modelId) {
                          context.read<ModelSelectionCubit>().selectModel(modelId);
                        },
                        itemBuilder: (BuildContext context) {
                          return AIModels.allModels.map((model) {
                            return PopupMenuItem<String>(
                              value: model.id,
                              child: ListTile(
                                title: Text(model.name),
                                subtitle: Text(
                                  model.description,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                selected: model.id == currentModel.id,
                              ),
                            );
                          }).toList();
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(context.watch<ThemeProvider>().isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                    tooltip: 'Toggle theme',
                  ),
                  IconButton(
                    icon: Icon(Icons.cleaning_services),
                    onPressed: () {
                      context.read<DocumentsCubit>().clearDocuments();
                      context.read<ChatCubit>().clearChatHistory();
                    },
                    tooltip: 'Settings',
                  ),
                ],
              ),
              drawer: DocumentsDrawer(
                documents: documentsState.documents,
                onDocumentSelected: (document) {
                  // setState(() {
                  //   _messages.insert(
                  //       0, ChatMessage(text: "Selected: ${document.title}", isUserMessage: true, file: File(document.contentPath ?? '')));
                  // });
                  //  Navigator.pop(context);
                },
                onImportZipFromUrl: (url) async {
                  try {
                    final documents = await ZipImportService.importZipFromUrl(url);
                    if (!mounted) return;

                    for (var document in documents) {
                      if (document.contentPath != null) {
                        context.read<DocumentsCubit>().addDocument(document.contentPath!);
                      }
                    }
                  } catch (e) {
                    print('Error picking file: $e');
                  }
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
                    child: chatState.messages.isEmpty
                        ? const Center(
                            child: Text('Send a message or upload a document to begin', style: TextStyle(color: Colors.grey, fontSize: 16)))
                        : ListView.builder(
                            reverse: true,
                            itemCount: chatState.messages.length,
                            itemBuilder: (context, index) =>
                                ChatMessage(text: chatState.messages[index].text, isUserMessage: chatState.messages[index].isUser)),
                  ),
                  const Divider(height: 1),
                  if (chatState.status == ChatStatus.loading)
                    LinearProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    ),
                  Container(decoration: BoxDecoration(color: Theme.of(context).cardColor), child: _buildTextComposer()),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      );
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (text) => _handleSubmitted(text),
                    decoration: const InputDecoration(
                      hintText: 'Send a message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
          if (!isUserMessage)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                'AI',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: isUserMessage ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUserMessage ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  if (file != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            file!.path.split('/').last,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
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
          if (isUserMessage)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                'You',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
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
