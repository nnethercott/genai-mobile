import 'package:hive_ce/hive.dart';

@HiveType(typeId: 1)
enum DocumentType {
  @HiveField(0)
  documentation,
  @HiveField(1)
  meetingNotes,
  @HiveField(2)
  research,
  @HiveField(3)
  email,
  @HiveField(4)
  chat,
  @HiveField(5)
  report,
  @HiveField(6)
  proposal,
  @HiveField(7)
  contract,
  @HiveField(8)
  invoice,
  @HiveField(9)
  book,
  @HiveField(10)
  article,
  @HiveField(11)
  other
}
