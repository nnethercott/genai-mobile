import 'package:hive_ce/hive.dart';

class Prompt extends HiveObject {
  String prompt;
  DateTime timestamp;

  Prompt(this.prompt, this.timestamp);
}
