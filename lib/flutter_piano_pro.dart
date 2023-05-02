library flutter_piano_pro;

import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';

class PianoPro {
  static Widget pianoWidget({
    required int buttonCount,
    double? totalWidth,
    bool expandHorizontal = true,
    double buttonHeight = 250,
    bool showNames = true,
    int firstNote = 0,
    int firstNoteOctave = 3,
    NoteType noteType = NoteType.romance,
    Function(NoteModel buttonName)? onPressed,
  }) {
    List<String> noteNames = NoteNames.generate(noteType);
    List<int> noBlackOnTheLeftIndexes = [0, 3];
    return LayoutBuilder(builder: (context, constraits) {
      final maxWidth = expandHorizontal
          ? constraits.maxWidth
          : totalWidth ?? constraits.maxWidth;
      final whiteButtonWidth = maxWidth / buttonCount;
      final blackButtonWidth = whiteButtonWidth / 2;
      var whiteButtonHeight = buttonHeight;
      if (constraits.maxHeight < buttonHeight) {
        whiteButtonHeight = constraits.maxHeight;
      }
      final blackButtonHeight = whiteButtonHeight / 1.85;
      var octaveCounter = 0;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Row(children: [
              ...List.generate(
                buttonCount,
                (i) {
                  if (i == 0) octaveCounter = 0;
                  var index = i + firstNote;
                  if (index % 7 == 0 && i != 0) ++octaveCounter;
                  var currentNote = NoteModel(
                      name: noteNames[index % 7],
                      octave: firstNoteOctave + octaveCounter,
                      noteIndex: index % 7,
                      isFlat: false);
                  return InkWell(
                    onTap:
                        onPressed == null ? null : () => onPressed(currentNote),
                    child: Container(
                      margin: EdgeInsets.all(whiteButtonWidth / 100),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 8),
                      width: whiteButtonWidth - ((whiteButtonWidth / 100) * 2),
                      height: whiteButtonHeight,
                      color: Colors.grey,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              showNames ? currentNote.name : '',
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: whiteButtonWidth / 3),
                            ),
                            Text(
                              showNames ? currentNote.octave.toString() : '',
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: whiteButtonWidth / 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ]),
            Row(
              children: [
                ...List.generate(
                  buttonCount,
                  (i) {
                    if (i == 0) octaveCounter = 0;
                    final index = i + firstNote;
                    if (index % 7 == 0 && i != 0) ++octaveCounter;
                    if (!noBlackOnTheLeftIndexes.contains((index % 7)) &&
                        i != 0) {
                      var currentNote = NoteModel(
                        name:
                            "${noteNames[(index % 7) - 1]}♯\n${noteNames[(index % 7)]}♭",
                        octave: firstNoteOctave + octaveCounter,
                        noteIndex: index % 7,
                        isFlat: true,
                      );
                      return Row(
                        children: [
                          InkWell(
                            onTap: onPressed == null
                                ? null
                                : () => onPressed(currentNote),
                            child: Container(
                              margin: const EdgeInsets.only(top: 1),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: blackButtonWidth,
                              height: blackButtonHeight,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(
                                      blackButtonWidth / 20)),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      showNames ? currentNote.name : '',
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: blackButtonWidth / 4),
                                    ),
                                    Text(
                                      showNames
                                          ? currentNote.octave.toString()
                                          : '',
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: blackButtonWidth / 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          !(i == buttonCount - 1)
                              ? SizedBox(
                                  width: whiteButtonWidth - (blackButtonWidth),
                                )
                              : const SizedBox(),
                        ],
                      );
                    } else {
                      return i == 0
                          ? SizedBox(
                              width: whiteButtonWidth - (blackButtonWidth / 2),
                            )
                          : SizedBox(
                              width: whiteButtonWidth,
                            );
                    }
                  },
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
