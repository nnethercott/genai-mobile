# genai_mobile

https://github.com/user-attachments/assets/3f67f101-9f99-4bf4-9858-dcba5528609e



## Add model to hive

create a model file in lib/models/

```dart
import 'package:hive-ce/hive.dart';

class Document extends HiveObject {
  String id;
}
```

Add new model to hive

```dart
import 'package:genai_mobile/models/document.dart';
import 'package:genai_mobile/models/prompt.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Prompt>(),
  AdapterSpec<Document>(),
])
// Annotations must be on some element
// ignore: unused_element
void _() {}
```

Run this command to generate the necessary files:

```dart
dart pub run build_runner build
```
