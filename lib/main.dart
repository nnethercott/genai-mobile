import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genai_mobile/dao/hive_registrar.g.dart';
import 'package:genai_mobile/ui/home/home_page.dart';
import 'package:genai_mobile/providers/theme_provider.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapters();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
        return MaterialApp(
          title: 'GenAI Mobile',
          theme: themeProvider.currentTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
