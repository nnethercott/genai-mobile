import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai_mobile/dao/hive_registrar.g.dart';
import 'package:genai_mobile/providers/document_provider.dart';
import 'package:genai_mobile/providers/llm_provider.dart';
import 'package:genai_mobile/providers/theme_provider.dart';
import 'package:genai_mobile/repositories/documents_repository.dart';
import 'package:genai_mobile/repositories/fllama_repository.dart';
import 'package:genai_mobile/repositories/prompt_repository.dart';
import 'package:genai_mobile/ui/documents/bloc/cubit.dart';
import 'package:genai_mobile/ui/home/bloc/cubit.dart';
import 'package:genai_mobile/ui/home/home_page.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapters();

  final promptRepository = await PromptRepository.getInstance();
  final modelPath = await getLLMPath();

  final fllamaRepository = FllamaRepository.getInstance(
    modelPath,
    null, // mmprojPath
    null, // tool
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatCubit(
            fllamaRepository: fllamaRepository,
            promptRepository: promptRepository,
          )..loadMessages(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return BlocProvider(
          create: (context) => DocumentsCubit(DocumentsRepository.instance)..loadDocuments(),
          child: MaterialApp(
            title: 'GenAI Mobile',
            theme: themeProvider.currentTheme,
            home: const HomePage(),
          ),
        );
      },
    );
  }
}
