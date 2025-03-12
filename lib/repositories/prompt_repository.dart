import 'package:genai_mobile/models/prompt.dart';
import 'package:hive_ce/hive.dart';

class PromptRepository {
  static const String _boxName = 'prompts';
  static PromptRepository? _instance;
  late Box<Prompt> _box;

  PromptRepository._();

  static Future<PromptRepository> getInstance() async {
    if (_instance == null) {
      _instance = PromptRepository._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _box = await Hive.openBox<Prompt>(_boxName);
  }

  List<Prompt> promptsHistory() {
    return _box.values.toList();
  }

  Future<void> addPrompt(Prompt prompt) async {
    await _box.add(prompt);
  }

  Future<void> deletePrompt(Prompt prompt) async {
    await _box.delete(prompt.key);
  }

  Future<void> cleanAllDB() async {
    await _box.clear();
  }
}
