import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double noteCount = 7;
  double width = 250;
  double height = 250;
  bool expand = true;
  int firstNote = 0;
  int firstNoteOctave = 0;
  NoteType noteType = NoteType.english;
  bool showNames = true;

  onPressed(NoteModel note) {
    print(note.toString());
    print(note.midiNoteNumber);
  }

  @override
  Widget build(BuildContext context) {
    List<String> noteNames = NoteNames.generate(noteType);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown),
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Piano Pro')),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Note Names'),
              trailing: SizedBox(
                width: 250,
                child: DropdownButton(
                    value: noteType,
                    items: List.generate(NoteType.values.length, (index) {
                      return DropdownMenuItem(
                          value: NoteType.values[index],
                          child: Text(NoteNames.generate(NoteType.values[index])
                              .toString()));
                    }),
                    onChanged: (value) => setState(() => noteType = value!)),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              title: const Text('First Note'),
              trailing: SizedBox(
                width: 250,
                child: DropdownButton(
                    value: firstNote,
                    items: List.generate(noteNames.length, (index) {
                      return DropdownMenuItem(
                          value: index,
                          child: Text(noteNames[index].toString()));
                    }),
                    onChanged: (value) => setState(() => firstNote = value!)),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              title: const Text('First Note Octave'),
              trailing: SizedBox(
                width: 250,
                child: DropdownButton(
                    value: firstNoteOctave,
                    items: List.generate(noteNames.length, (index) {
                      return DropdownMenuItem(
                          value: index, child: Text(index.toString()));
                    }),
                    onChanged: (value) =>
                        setState(() => firstNoteOctave = value!)),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Note Count',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(noteCount.round().toInt().toString()),
                ],
              ),
              trailing: SizedBox(
                width: 250,
                child: Slider(
                  divisions: 51,
                  max: 52,
                  min: 1,
                  value: noteCount,
                  onChanged: (value) => setState(() => noteCount = value),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Height',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(height.round().toInt().toString()),
                ],
              ),
              trailing: SizedBox(
                width: 250,
                child: Slider(
                  divisions: 27,
                  max: 300,
                  min: 150,
                  value: height,
                  onChanged: (value) => setState(() => height = value),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              enabled: !expand,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Width',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(width.round().toInt().toString()),
                ],
              ),
              trailing: SizedBox(
                width: 250,
                child: Slider(
                  divisions: 50,
                  max: 5000,
                  min: 100,
                  value: width,
                  onChanged: (value) => setState(() => width = value),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            CheckboxListTile(
                title: const Text('Expand horizontal to parent'),
                value: expand,
                onChanged: (value) => setState(() => expand = value!)),
            const Divider(
              height: 0,
            ),
            CheckboxListTile(
                title: const Text('Show Names'),
                value: showNames,
                onChanged: (value) => setState(() => showNames = value!)),
            const SizedBox(
              height: 20,
            ),
            PianoPro.pianoWidget(
                onPressed: onPressed,
                noteType: noteType,
                showNames: showNames,
                expandHorizontal: expand,
                totalWidth: width,
                firstNote: firstNote,
                firstNoteOctave: firstNoteOctave,
                buttonHeight: height,
                buttonCount: noteCount.round().toInt()),
          ],
        ),
      ),
    );
  }
}
