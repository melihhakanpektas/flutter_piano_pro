import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';

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
  NoteNames firstNote = NoteNames.noteDo;

  bool showNames = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown),
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Piano Pro')),
        body: ListView(
          children: [
            ListTile(
              title: const Text('First Note'),
              trailing: SizedBox(
                width: 250,
                child: DropdownButton(
                    value: firstNote,
                    items: List.generate(NoteNames.values.length, (index) {
                      return DropdownMenuItem(
                          value: NoteNames.values[index],
                          child: Text(NoteNames.values[index]
                              .toString()
                              .split('.note')[1]));
                    }),
                    onChanged: (value) => setState(() => firstNote = value!)),
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
                showNames: showNames,
                expandHorizontal: expand,
                totalWidth: width,
                firstNote: firstNote,
                buttonHeight: height,
                buttonCount: noteCount.round().toInt()),
          ],
        ),
      ),
    );
  }
}
