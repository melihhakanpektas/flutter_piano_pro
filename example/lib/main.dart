import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
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
  double width = 300;
  double height = 250;
  bool expand = true;
  int firstNote = 0;
  int firstNoteOctave = 3;
  NoteType noteType = NoteType.english;
  bool showNames = true;
  bool showOctaveNumbers = true;
  Map<int, int> pointerNoteNumber = {};

  @override
  void initState() {
    super.initState();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('First Note'),
                    SizedBox(
                      child: DropdownButton(
                          value: firstNote,
                          items: List.generate(noteNames.length, (index) {
                            return DropdownMenuItem(
                                value: index,
                                child: Text(noteNames[index].toString()));
                          }),
                          onChanged: (value) =>
                              setState(() => firstNote = value!)),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('First Octave'),
                    SizedBox(
                      child: DropdownButton(
                          value: firstNoteOctave,
                          items: List.generate(noteNames.length, (index) {
                            return DropdownMenuItem(
                                value: index, child: Text(index.toString()));
                          }),
                          onChanged: (value) =>
                              setState(() => firstNoteOctave = value!)),
                    ),
                  ],
                ),
              ],
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
                  divisions: 44,
                  max: 45,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Width',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(width.round().toInt().toString()),
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: Slider(
                    divisions: 50,
                    max: 5000,
                    min: 100,
                    value: width,
                    onChanged: expand
                        ? null
                        : (value) => setState(() => width = value),
                  ),
                ),
                Column(
                  children: [
                    const Text('Expand Vertical'),
                    Checkbox(
                        value: expand,
                        onChanged: (value) => setState(() => expand = value!)),
                  ],
                )
              ],
            ),
            const Divider(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Names'),
                    Checkbox(
                        value: showNames,
                        onChanged: (value) =>
                            setState(() => showNames = value!)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Octave'),
                    Checkbox(
                        value: showOctaveNumbers,
                        onChanged: (value) =>
                            setState(() => showOctaveNumbers = value!)),
                  ],
                ),
              ],
            ),
            PianoPro(
                onTapDown: (note, pointer) {
                  if (note == null) return;
                },
                onTapUpdate: (note, pointer) {
                  if (note == null) return;

                  if (pointerNoteNumber.containsKey(pointer) &&
                      pointerNoteNumber[pointer] == note.midiNoteNumber) return;
                  pointerNoteNumber[pointer] = note.midiNoteNumber;
                  //stop note midinumber
                  //play midi
                },
                noteType: noteType,
                showNames: showNames,
                showOctaveNumber: showOctaveNumbers,
                expandHorizontal: expand,
                totalWidth: width,
                firstNote: firstNote,
                firstNoteOctave: firstNoteOctave,
                buttonHeight: height,
                noteCount: noteCount.round().toInt()),
          ],
        ),
      ),
    );
  }
}
