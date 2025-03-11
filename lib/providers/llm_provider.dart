import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLLMPath() async {
  // Define the asset path
  const assetPath = 'assets/models/qwen_small.gguf';

  try {
    // Get the application documents directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final modelFileName = assetPath.split('/').last;
    final modelFile = File('${appDocDir.path}/$modelFileName');

    // Check if the file already exists in the documents directory
    if (!await modelFile.exists()) {
      // If not, copy it from assets
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      await modelFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }

    // Return the real file path
    return modelFile.path;
  } catch (e) {
    print('Error extracting model file: $e');
    throw Exception('Failed to load model file');
  }
}
