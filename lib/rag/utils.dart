import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

// NOTE: obsolete once we handle downloads in app
Future<String> getModelPath(String modelFilenameWithExtension) async {
if (kIsWeb) {
  return 'assets/models/$modelFilenameWithExtension';
}
final assetCacheDirectory =
    await path_provider.getApplicationSupportDirectory();
final modelPath =
    path.join(assetCacheDirectory.path, modelFilenameWithExtension);

File file = File(modelPath);
bool fileExists = await file.exists();
final fileLength = fileExists ? await file.length() : 0;

// Do not use path package / path.join for paths.
// After testing on Windows, it appears that asset paths are _always_ Unix style, i.e.
// use /, but path.join uses \ on Windows.
final assetPath =
    'assets/models/${path.basename(modelFilenameWithExtension)}';
final assetByteData = await rootBundle.load(assetPath);
final assetLength = assetByteData.lengthInBytes;
final fileSameSize = fileExists && fileLength == assetLength;
if (!fileExists || !fileSameSize) {
  debugPrint(
      'Copying model to $modelPath. Why? Either the file does not exist (${!fileExists}), '
      'or it does exist but is not the same size as the one in the assets '
      'directory. (${!fileSameSize})');

  List<int> bytes = assetByteData.buffer.asUint8List(
    assetByteData.offsetInBytes,
    assetByteData.lengthInBytes,
  );
  await file.writeAsBytes(bytes, flush: true);
}

return modelPath;
}

