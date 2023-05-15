import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
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
  double width = 300;
  double height = 250;
  bool expand = true;
  int firstNote = 0;
  int firstNoteOctave = 3;
  NoteType noteType = NoteType.english;
  bool showNames = true;
  bool showOctaveNumbers = true;
  Map<int, NoteModel> pointerAndNote = {};
  String sf2Path = 'assets/tight_piano.sf2';
  final _midi = MidiPro();
  bool isTouchingToPiano = false;

  void play(int midi, {int velocity = 127}) {
    _midi.playMidiNote(midi: midi, velocity: velocity);
  }

  void stop(int midi) {
    _midi.stopMidiNote(midi: midi);
  }

  @override
  void initState() {
    _midi.loadSoundfont(sf2Path: sf2Path);
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
          physics:
              isTouchingToPiano ? const NeverScrollableScrollPhysics() : null,
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
                onTapDown: (NoteModel? note, int tapId) {
                  if (note == null) return;
                  isTouchingToPiano = true;
                  play(note.midiNoteNumber);
                  setState(() => pointerAndNote[tapId] = note);
                  debugPrint(
                      'DOWN: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                },
                onTapUpdate: (NoteModel? note, int tapId) {
                  if (note == null) return;
                  if (pointerAndNote[tapId] == note) return;
                  stop(pointerAndNote[tapId]!.midiNoteNumber);
                  play(note.midiNoteNumber);
                  setState(() => pointerAndNote[tapId] = note);
                  debugPrint(
                      'UPDATE: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                },
                onTapUp: (int tapId) {
                  stop(pointerAndNote[tapId]!.midiNoteNumber);
                  setState(() => pointerAndNote.remove(tapId));
                  debugPrint('UP: tapId= $tapId');
                  if (pointerAndNote.isEmpty) isTouchingToPiano = false;
                },
                noteType: noteType,
                showNames: showNames,
                showOctaveNumber: showOctaveNumbers,
                expandHorizontal: expand,
                totalWidth: width,
                firstNote: firstNote,
                firstNoteOctave: firstNoteOctave,
                buttonHeight: height,
                extraBlackButtonWidth: 15,
                noteCount: noteCount.round().toInt()),
          ],
        ),
      ),
    );
  }
}
