import 'package:genai_mobile/model/prompt.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Prompt>(),
])
// Annotations must be on some element
// ignore: unused_element
void _() {}