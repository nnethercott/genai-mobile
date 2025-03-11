import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class HuggingFaceService {
  static const String _baseUrl = 'https://huggingface.co/api';
  static const String _downloadBaseUrl = 'https://huggingface.co';
  final String _apiToken;

  HuggingFaceService({required String apiToken}) : _apiToken = apiToken;

  Future<String> downloadModel(String modelId) async {
    try {
      // Get the model info first
      final modelInfo = await _getModelInfo(modelId);

      // Create model directory
      final appDir = await getApplicationDocumentsDirectory();
      final modelDir = Directory(path.join(appDir.path, 'models', modelId));
      if (!await modelDir.exists()) {
        await modelDir.create(recursive: true);
      }

      // Download model files
      for (final file in modelInfo['siblings']) {
        final fileName = file['rfilename'];
        final fileUrl = '$_downloadBaseUrl/$modelId/resolve/main/$fileName';
        final filePath = path.join(modelDir.path, fileName);

        // Create parent directories if they don't exist
        final fileDir = Directory(path.dirname(filePath));
        if (!await fileDir.exists()) {
          await fileDir.create(recursive: true);
        }

        // Download file
        final response = await http.get(
          Uri.parse(fileUrl),
          headers: {'Authorization': 'Bearer $_apiToken'},
        );

        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
        }
      }

      return modelDir.path;
    } catch (e) {
      throw Exception('Failed to download model: $e');
    }
  }

  Future<Map<String, dynamic>> _getModelInfo(String modelId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/models/$modelId'),
      headers: {'Authorization': 'Bearer $_apiToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get model info: ${response.statusCode}');
    }
  }

  Future<bool> isModelDownloaded(String modelId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory(path.join(appDir.path, 'models', modelId));
    return await modelDir.exists();
  }
}
