# Flutter Piano Pro

[![pub package](https://img.shields.io/pub/v/flutter_piano_pro.svg)](https://pub.dev/packages/flutter_piano_pro)
[![GitHub stars](https://img.shields.io/github/stars/MelihHakanPektas/flutter_piano_pro.svg?style=social)](https://github.com/MelihHakanPektas/flutter_piano_pro)
[![GitHub issues](https://img.shields.io/github/issues/MelihHakanPektas/flutter_piano_pro.svg)](https://github.com/MelihHakanPektas/flutter_piano_pro/issues)

A Flutter widget package to generate a piano with customizable options.

![Example image of Flutter Piano Pro](https://github.com/MelihHakanPektas/flutter_piano_pro/raw/main/screenshots/example.png)

## Installation

Add `flutter_piano_pro` as a dependency in your pubspec.yaml file:

```yaml
dependencies:
  flutter_piano_pro: ^0.1.0
```

## Usage

To use the piano widget, import `flutter_piano_pro` and use the `pianoWidget` method:

```dart
import 'package:flutter_piano_pro/flutter_piano_pro.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Piano Pro Example'),
      ),
      body: Center(
        child: PianoPro.pianoWidget(
          buttonCount: 14,
          expandHorizontal: true,
          buttonHeight: 250,
          showNames: true,
          firstNote: NoteNames.noteDo,
        ),
      ),
    );
  }
}
```

## Customization Options

The `pianoWidget` method accepts the following parameters:

| Parameter        | Type        | Default            | Description                                                                                                                                                              |
| ---------------- | ----------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| buttonCount      | `int`       | Required           | Number of white keys to display                                                                                                                                          |
| totalWidth       | `double?`   | null               | Total width of the piano. Defaults to maximum width available                                                                                                            |
| expandHorizontal | `bool`      | true               | Determines whether the piano should expand horizontally to fill available space                                                                                          |
| buttonHeight     | `double`    | 250                | Height of the white keys                                                                                                                                                 |
| showNames        | `bool`      | true               | Determines whether the note names should be displayed                                                                                                                    |
| firstNote        | `NoteNames` | `NoteNames.noteDo` | The first note to display. Other options are `NoteNames.noteRe`, `NoteNames.noteMi`, `NoteNames.noteFa`, `NoteNames.noteSol`, `NoteNames.noteLa`, and `NoteNames.noteSi` |

## Contributions

Contributions are welcome! Please feel free to submit a PR or open an issue.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/MelihHakanPektas/flutter_piano_pro/blob/main/LICENSE) file for details.
