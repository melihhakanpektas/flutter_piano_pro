library flutter_piano_pro;

import 'package:flutter/material.dart';

enum NoteNames { noteDo, noteRe, noteMi, noteFa, noteSol, noteLa, noteSi }

class PianoPro {
  static Widget pianoWidget(
      {required int buttonCount,
      double? totalWidth,
      bool expandHorizontal = true,
      double buttonHeight = 250,
      bool showNames = true,
      NoteNames firstNote = NoteNames.noteDo}) {
    List<String> noteNames = [
      for (var note in NoteNames.values) note.toString().split('.note')[1]
    ];
    List<NoteNames> noBlackOnTheLeft = [NoteNames.noteDo, NoteNames.noteFa];
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
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Row(children: [
              ...List.generate(
                buttonCount,
                (i) {
                  var index = i + NoteNames.values.indexOf(firstNote);
                  String noteName = noteNames[index % 7];
                  return Container(
                    margin: EdgeInsets.all(whiteButtonWidth / 100),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                    width: whiteButtonWidth - ((whiteButtonWidth / 100) * 2),
                    height: whiteButtonHeight,
                    color: Colors.grey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        showNames ? noteName : '',
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: whiteButtonWidth / 3),
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
                    final index = i + NoteNames.values.indexOf(firstNote);
                    return !noBlackOnTheLeft
                                .contains(NoteNames.values[(index % 7)]) &&
                            i != 0
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                width: blackButtonWidth,
                                height: blackButtonHeight,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(
                                        blackButtonWidth / 20)),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    showNames
                                        ? "${noteNames[(index % 7) - 1]}♯\n${noteNames[(index % 7)]}♭"
                                        : '',
                                    textAlign: TextAlign.center,
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: blackButtonWidth / 4),
                                  ),
                                ),
                              ),
                              !(i == buttonCount - 1)
                                  ? SizedBox(
                                      width:
                                          whiteButtonWidth - (blackButtonWidth),
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : i == 0
                            ? SizedBox(
                                width:
                                    whiteButtonWidth - (blackButtonWidth / 2),
                              )
                            : SizedBox(
                                width: whiteButtonWidth,
                              );
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
