// ignore_for_file: public_member_api_docs, sort_constructors_first
library flutter_piano_pro;

import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';
import 'package:flutter_piano_pro/piano_scrollbar.dart';
import 'package:flutter_piano_pro/piano_view.dart';

class PianoPro extends StatelessWidget {
  PianoPro({
    super.key,
    this.scrollController,
    this.noteCount = 7,
    this.whiteWidth = 300,
    this.expand = true,
    this.whiteHeight = 250,
    this.showNames = true,
    this.showOctave = true,
    this.firstNoteIndex = 0,
    this.firstOctave = 3,
    this.noteType = NoteType.english,
    this.onTapDown,
    this.onTapUpdate,
    this.onTapUp,
    this.blackWidthRatio = 2,
    this.scrollHeight = 50,
    this.buttonColors,
  });

  final int noteCount;
  final double whiteWidth;
  final bool expand;
  final double whiteHeight;
  final bool showNames;
  final bool showOctave;
  final int firstNoteIndex;
  final int firstOctave;
  final NoteType noteType;
  final double blackWidthRatio;
  final double scrollHeight;
  final ScrollController? scrollController;
  final Function(NoteModel? note, int pointer)? onTapDown;
  final Function(NoteModel? note, int pointer)? onTapUpdate;
  final Function(int pointer)? onTapUp;
  final Map<int, Color>? buttonColors;

  final List<int> noFlatIndexes = [0, 3];
  final bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scroll = scrollController ?? ScrollController();
    return LayoutBuilder(builder: (context, constraits) {
      if (expand || whiteWidth <= constraits.maxWidth) {
        return pianoWidget(constraits.biggest, false, false, scroll);
      } else {
        return Column(
          children: [
            pianoWidget(constraits.biggest, false, true, scroll),
            pianoWidget(constraits.biggest, true, false, scroll)
          ],
        );
      }
    });
  }

  Widget pianoWidget(Size constraints, bool isScrollable, bool forScrollBar,
      ScrollController scroll) {
    final pianoWidth =
        expand || forScrollBar ? constraints.width : (whiteWidth);
    final wButtonW = pianoWidth / noteCount;
    final bButtonW = wButtonW / blackWidthRatio;
    var wButtonH = (forScrollBar ? scrollHeight : whiteHeight) -
        (isScrollable ? scrollHeight : 0);
    if (constraints.width < whiteHeight) {
      wButtonH = constraints.width;
    }
    final bButtonH = wButtonH / 1.85;

    NoteModel? offsetToNoteModel(Offset offset) {
      if (offset.dx < 0 || offset.dx >= pianoWidth) return null;
      var buttonIndex = offset.dx ~/ wButtonW;
      var noteIndex = (buttonIndex + firstNoteIndex) % 7;
      var octave = ((buttonIndex + firstNoteIndex) / 7 + firstOctave).toInt();
      bool isFlat = false;
      if (offset.dy >= bButtonH) {
        return NoteModel(
            name: noteType.notes[noteIndex],
            octave: octave,
            noteIndex: noteIndex,
            isFlat: false);
      } else {
        if (offset.dx % wButtonW < bButtonW / 2) {
          if (noFlatIndexes.contains(noteIndex)) {
            isFlat = false;
          } else {
            isFlat = true;
          }
        } else if (offset.dx % wButtonW > wButtonW - bButtonW / 2 &&
            buttonIndex != noteCount - 1) {
          ++buttonIndex;
          noteIndex = (buttonIndex + firstNoteIndex) % 7;
          if (noFlatIndexes.contains(noteIndex)) {
            --buttonIndex;
            noteIndex = (buttonIndex + firstNoteIndex) % 7;
            isFlat = false;
          } else {
            octave = ((buttonIndex + firstNoteIndex) / 7 + firstOctave).toInt();
            isFlat = true;
          }
        } else {
          isFlat = false;
        }

        return NoteModel(
            name: noteType.notes[noteIndex],
            octave: octave,
            noteIndex: noteIndex,
            isFlat: isFlat);
      }
    }

    if (forScrollBar) {
      var scrollButtonW = whiteWidth / noteCount;
      var noteCountOnScreen = constraints.width / scrollButtonW;
      var pianoButtonW = (constraints.width / noteCount);
      var scale = scrollButtonW / pianoButtonW;

      var scrollWidth = noteCountOnScreen * pianoButtonW;
      return Stack(
        children: [
          PianoView(
            buttonColors: buttonColors,
            showOctaveNumber: false,
            showNames: false,
            firstNoteOctave: firstOctave,
            noteType: noteType,
            whiteButtonWidth: wButtonW,
            whiteButtonHeight: wButtonH,
            noFlatIndexes: noFlatIndexes,
            blackButtonWidth: bButtonW,
            blackButtonHeight: bButtonH,
            firstNote: firstNoteIndex,
            noteCount: noteCount,
          ),
          PianoScrollbar(
              scrollController: scroll,
              scrollWidth: scrollWidth,
              constraints: constraints,
              scale: scale,
              wButtonH: wButtonH)
        ],
      );
    } else {
      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Listener(
            onPointerDown: onTapDown == null
                ? null
                : (details) {
                    onTapDown!(offsetToNoteModel(details.localPosition),
                        details.pointer);
                  },
            onPointerMove: onTapUpdate == null
                ? null
                : (details) {
                    onTapUpdate!(offsetToNoteModel(details.localPosition),
                        details.pointer);
                  },
            onPointerUp:
                onTapUp == null ? null : (details) => onTapUp!(details.pointer),
            onPointerCancel:
                onTapUp == null ? null : (details) => onTapUp!(details.pointer),
            behavior: HitTestBehavior.translucent,
            child: PianoView(
              buttonColors: buttonColors,
              showOctaveNumber: showOctave,
              showNames: showNames,
              firstNoteOctave: firstOctave,
              noteType: noteType,
              whiteButtonWidth: wButtonW,
              whiteButtonHeight: wButtonH,
              noFlatIndexes: noFlatIndexes,
              blackButtonWidth: bButtonW,
              blackButtonHeight: bButtonH,
              firstNote: firstNoteIndex,
              noteCount: noteCount,
            )),
      );
    }
  }
}
