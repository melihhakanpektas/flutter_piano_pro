# Flutter Piano Pro

[![pub package](https://img.shields.io/pub/v/flutter_piano_pro.svg)](https://pub.dev/packages/flutter_piano_pro)
[![GitHub stars](https://img.shields.io/github/stars/MelihHakanPektas/flutter_piano_pro.svg?style=social)](https://github.com/MelihHakanPektas/flutter_piano_pro)
[![GitHub issues](https://img.shields.io/github/issues/MelihHakanPektas/flutter_piano_pro.svg)](https://github.com/MelihHakanPektas/flutter_piano_pro/issues)

Flutter Piano Pro is a piano widget for flutter applications. It provides a configurable keyboard interface, allowing users to interact with piano notes and receive event callbacks for their interactions.

![Flutter Piano Pro Example](https://github.com/MelihHakanPektas/flutter_piano_pro/raw/master/assets/flutter_piano_pro.gif)

## Installation

Add `flutter_piano_pro` as a dependency in your pubspec.yaml file:

```yaml
dependencies:
  flutter_piano_pro: ^0.2.0
```

## Usage

Import `flutter_piano_pro.dart` and `note_names.dart` files:

```dart
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_names.dart';
```

In your widget tree, use the `PianoPro` widget to add the piano:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Piano Pro Demo"),
      ),
      body: Center(
        child: PianoPro(
        ),
      ),
    );
  }
}
```

## Configuration

- `noteCount` - The number of notes to display on the piano.
- `totalWidth` - The total width of the piano. If `expandHorizontal` is set to `false`, this will be the fixed width of the piano. If `expandHorizontal` is set to `true`, this is ignored.
- `expandHorizontal` - If `true`, the piano will expand horizontally to fill the available space. If `false`, the piano will have a fixed width defined by `totalWidth`.
- `buttonHeight` - The height of the piano keys.
- `showNames` - If `true`, note names will be displayed on the keys.
- `showOctaveNumber` - If `true`, octave numbers will be displayed on the keys.
- `firstNote` - The index of the first note to display. `0`= C(Do).
- `firstNoteOctave` - The octave of the first note to display.
- `noteType` - The type of notes to display (`NoteType.english`, `NoteType.romanian` etc.).
- `onTapDown` - A function that is called when a note is tapped. The `NoteModel` of the tapped note is passed as the first argument, and the pointer ID is passed as the second argument.
- `onTapUpdate` - A function that is called when a pointer that is already down moves. The `NoteModel` of the updated note is passed as the first argument, and the pointer ID is passed as the second argument.
- `onTapUp` - A function that is called when a note is released. The pointer ID is passed as the argument.

## Example Usage

Here's an example of how you might use `PianoPro` in your Flutter app:

```Dart
import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';

main() {runApp(const MyHomePage());}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}
class MyHomePageState extends State<MyHomePage> {
  Map<int, NoteModel> pointerAndNote = {};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Piano Pro Demo"),
        ),
        body: Column(
          children: [
              child: PianoPro(
                noteCount: 7, // Without black keys
                totalWidth: 500,
                expandHorizontal:
                    true, // if it's true, totalWidth = constraits.maxWidth
                buttonHeight: 250,
                showNames: true,
                showOctaveNumber: true,
                firstNote: 0, // C
                firstNoteOctave: 3,
                noteType: NoteType.english, // A, B, C, D, E, F, G
                onTapDown: (note, tapId) {
                  if (note == null) return;
                  setState(() => pointerAndNote[tapId] = note);
                  debugPrint(
                      'DOWN: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                },
                onTapUpdate: (note, tapId) {
                  if (note == null) return;
                  if (pointerAndNote[tapId] == note) return;
                  setState(() => pointerAndNote[tapId] = note);
                  debugPrint(
                      'UPDATE: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                },
                onTapUp: (tapId) {
                  setState(() => pointerAndNote.remove(tapId));
                  debugPrint('UP: tapId= $tapId');
                },
              ),
            Expanded(
              child: ListView.builder(
                itemCount: pointerAndNote.length,
                itemBuilder: (BuildContext context, int index) {
                  final keys = pointerAndNote.keys.toList();
                  return ListTile(
                    title: Text(
                      "${pointerAndNote[keys[index]]!.name}${pointerAndNote[keys[index]]!.octave}${pointerAndNote[keys[index]]!.isFlat ? "♭" : ''}",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

In this example, we've created a simple app that displays a piano keyboard using `PianoPro`. We've also added a `ListView` below the keyboard to display the notes that are currently being pressed.

## Contributions

Contributions are welcome! Please feel free to submit a PR or open an issue.

### Contact

If you have any questions or suggestions, feel free to contact the package maintainer, Melih Hakan Pektas, via email or through GitHub.

![Melih Hakan Pektas](https://avatars.githubusercontent.com/u/79354366)

Thank you for contributing to flutter_piano_pro!

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/MelihHakanPektas/flutter_piano_pro/blob/main/LICENSE) file for details.
