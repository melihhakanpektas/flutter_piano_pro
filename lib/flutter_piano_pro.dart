library flutter_piano_pro;

import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';

class PianoPro extends StatefulWidget {
  const PianoPro({
    super.key,
    this.noteCount = 7,
    this.totalWidth = 300,
    this.expandHorizontal = true,
    this.buttonHeight = 250,
    this.showNames = true,
    this.showOctaveNumber = true,
    this.firstNote = 0,
    this.firstNoteOctave = 3,
    this.noteType = NoteType.english,
    this.onTapDown,
    this.onTapUpdate,
    this.onTapUp,
  });

  final int noteCount;
  final double? totalWidth;
  final bool expandHorizontal;
  final double buttonHeight;
  final bool showNames;
  final bool showOctaveNumber;
  final int firstNote;
  final int firstNoteOctave;
  final NoteType noteType;
  final Function(NoteModel? note, int pointer)? onTapDown;
  final Function(NoteModel? note, int pointer)? onTapUpdate;
  final Function(int pointer)? onTapUp;

  @override
  State<PianoPro> createState() => _PianoProState();
}

class _PianoProState extends State<PianoPro> {
  List<int> noBlackOnTheLeftIndexes = [0, 3];
  bool isPressed = false;

  late List<String> noteNames;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    noteNames = NoteNames.generate(widget.noteType);
    return LayoutBuilder(builder: (context, constraits) {
      final maxWidth = widget.expandHorizontal
          ? constraits.maxWidth
          : widget.totalWidth ?? constraits.maxWidth;
      final whiteButtonWidth = maxWidth / widget.noteCount;
      final blackButtonWidth = whiteButtonWidth / 2;
      var whiteButtonHeight = widget.buttonHeight;
      if (constraits.maxHeight < widget.buttonHeight) {
        whiteButtonHeight = constraits.maxHeight;
      }
      final blackButtonHeight = whiteButtonHeight / 1.85;
      var octaveCounter = 0;

      NoteModel? offsetToNoteModel(Offset offset) {
        if (offset.dx < 0 || offset.dx >= maxWidth) return null;
        var buttonIndex = (offset.dx / whiteButtonWidth).floor().toInt();
        var noteIndex = (buttonIndex + widget.firstNote) % 7;
        var octave =
            ((buttonIndex + widget.firstNote) / 7 + widget.firstNoteOctave)
                .toInt();
        bool isFlat = false;
        if (offset.dy >= blackButtonHeight) {
          return NoteModel(
              name: NoteNames.generate(widget.noteType)[noteIndex],
              octave: octave,
              noteIndex: noteIndex,
              isFlat: false);
        } else {
          if (offset.dx % whiteButtonWidth < blackButtonWidth / 2) {
            if (noBlackOnTheLeftIndexes.contains(noteIndex)) {
              isFlat = false;
            } else {
              isFlat = true;
            }
          } else if (offset.dx % whiteButtonWidth >
                  whiteButtonWidth - blackButtonWidth / 2 &&
              buttonIndex != widget.noteCount - 1) {
            ++buttonIndex;
            noteIndex = (buttonIndex + widget.firstNote) % 7;
            if (noBlackOnTheLeftIndexes.contains(noteIndex)) {
              --buttonIndex;
              noteIndex = (buttonIndex + widget.firstNote) % 7;
              isFlat = false;
            } else {
              octave = ((buttonIndex + widget.firstNote) / 7 +
                      widget.firstNoteOctave)
                  .toInt();
              isFlat = true;
            }
          } else {
            isFlat = false;
          }

          return NoteModel(
              name: NoteNames.generate(widget.noteType)[noteIndex],
              octave: octave,
              noteIndex: noteIndex,
              isFlat: isFlat);
        }
      }

      return Listener(
        onPointerDown: widget.onTapDown == null
            ? null
            : (details) {
                widget.onTapDown!(
                    offsetToNoteModel(details.localPosition), details.pointer);
              },
        onPointerMove: widget.onTapUpdate == null
            ? null
            : (details) {
                widget.onTapUpdate!(
                    offsetToNoteModel(details.localPosition), details.pointer);
              },
        onPointerUp: widget.onTapUp == null
            ? null
            : (details) => widget.onTapUp!(details.pointer),
        onPointerCancel: widget.onTapUp == null
            ? null
            : (details) => widget.onTapUp!(details.pointer),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Row(children: [
              ...List.generate(
                widget.noteCount,
                (i) {
                  if (i == 0) octaveCounter = 0;
                  var index = i + widget.firstNote;
                  if (index % 7 == 0 && i != 0) ++octaveCounter;
                  var currentNote = NoteModel(
                      name: noteNames[index % 7],
                      octave: widget.firstNoteOctave + octaveCounter,
                      noteIndex: index % 7,
                      isFlat: false);
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: whiteButtonWidth / 100),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                    width: whiteButtonWidth - ((whiteButtonWidth / 100) * 2),
                    height: whiteButtonHeight,
                    color: Colors.grey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.showOctaveNumber
                              ? Text(
                                  currentNote.octave.toString(),
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: whiteButtonWidth / 3 > 50
                                          ? 50 / 2
                                          : (whiteButtonWidth / 3) / 2),
                                )
                              : const SizedBox(),
                          widget.showNames
                              ? Text(
                                  currentNote.name,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: whiteButtonWidth / 3 > 45
                                          ? 45
                                          : whiteButtonWidth / 3),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              )
            ]),
            Row(
              children: [
                ...List.generate(
                  widget.noteCount,
                  (i) {
                    if (i == 0) octaveCounter = 0;
                    final index = i + widget.firstNote;
                    if (index % 7 == 0 && i != 0) ++octaveCounter;
                    if (!noBlackOnTheLeftIndexes.contains((index % 7)) &&
                        i != 0) {
                      var currentNote = NoteModel(
                        name:
                            "${noteNames[(index % 7) - 1]}♯\n${noteNames[(index % 7)]}♭",
                        octave: widget.firstNoteOctave + octaveCounter,
                        noteIndex: index % 7,
                        isFlat: true,
                      );
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(whiteButtonWidth / 100),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            width:
                                blackButtonWidth - (whiteButtonWidth / 100) * 2,
                            height: blackButtonHeight,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                    blackButtonWidth / 20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.showOctaveNumber
                                    ? Text(
                                        currentNote.octave.toString(),
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: blackButtonWidth / 4 > 16
                                                ? 16
                                                : blackButtonWidth / 4),
                                      )
                                    : const SizedBox(),
                                widget.showNames
                                    ? Text(
                                        currentNote.name,
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: blackButtonWidth / 4 > 16
                                                ? 16
                                                : blackButtonWidth / 4),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          !(i == widget.noteCount - 1)
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
