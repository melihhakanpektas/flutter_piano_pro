# Flutter Piano Pro

[![pub package](https://img.shields.io/pub/v/flutter_piano_pro.svg)](https://pub.dev/packages/flutter_piano_pro)
[![GitHub stars](https://img.shields.io/github/stars/MelihHakanPektas/flutter_piano_pro.svg?style=social)](https://github.com/MelihHakanPektas/flutter_piano_pro)
[![GitHub issues](https://img.shields.io/github/issues/MelihHakanPektas/flutter_piano_pro.svg)](https://github.com/MelihHakanPektas/flutter_piano_pro/issues)

A Flutter widget package to generate a piano with customizable options.

![Flutter Piano Pro Example](https://github.com/MelihHakanPektas/flutter_piano_pro/raw/master/assets/flutter_piano_pro.gif)

## Installation

Add `flutter_piano_pro` as a dependency in your pubspec.yaml file:

```yaml
dependencies:
  flutter_piano_pro: ^0.1.4
```

## Usage

Import `flutter_piano_pro.dart` and `note_names.dart` files:

```dart
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_names.dart';
```

In your widget tree, use the `pianoWidget` method to add the piano:

```dart
PianoPro.pianoWidget(
    buttonCount: 25,
    totalWidth: 500,
    buttonHeight: 100,
    showNames: true,
    firstNote: 0,
    noteType: NoteType.romance,
),
```

This method takes in several parameters:

- `buttonCount` (required): The number of keys/buttons in the piano.
- `totalWidth` (optional): The width of the piano. If not provided, the piano will take up the full width of its parent.
- `expandHorizontal` (optional, default: `true`): Whether or not to expand horizontally to fill available space.
- `buttonHeight` (optional, default: `250`): The height of the piano keys/buttons.
- `showNames` (optional, default: `true`): Whether or not to show the note names on the keys.
- `firstNote` (optional, default: `0`): The index of the first note to show.
- `noteType` (optional, default: `NoteType.romance`): The type of notes to show. Four types are available: `NoteType.english`, `NoteType.german`, `NoteType.romance`, and `NoteType.romance2`.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_names.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Piano Pro Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Piano Pro'),
        ),
        body: Center(
          child: PianoPro.pianoWidget(
            buttonCount: 25,
            totalWidth: 500,
            buttonHeight: 100,
            showNames: true,
            firstNote: 0,
            noteType: NoteType.romance,
          ),
        ),
      ),
    );
  }
}
```

## Contributions

Contributions are welcome! Please feel free to submit a PR or open an issue.

### Contact

If you have any questions or suggestions, feel free to contact the package maintainer, Melih Hakan Pektas, via email or through GitHub.

![Melih Hakan Pektas](https://avatars.githubusercontent.com/u/79354366)

Thank you for contributing to flutter_piano_pro!

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/MelihHakanPektas/flutter_piano_pro/blob/main/LICENSE) file for details.
