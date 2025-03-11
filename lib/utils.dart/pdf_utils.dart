import 'dart:io';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> extractTextFromPdf(String path) async {
  Uint8List bytes = File(path).readAsBytesSync();
  final PdfDocument document = PdfDocument(inputBytes: bytes);
  String content = PdfTextExtractor(document).extractText();
  document.dispose();
  return content;
}
