// ignore_for_file: public_member_api_docs, sort_constructors_first
library flutter_piano_pro;

import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';
import 'package:flutter_piano_pro/piano_scrollbar.dart';
import 'package:flutter_piano_pro/piano_view.dart';

class PianoPro extends StatefulWidget {
  const PianoPro({
    super.key,
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
  final Function(NoteModel? note, int pointer)? onTapDown;
  final Function(NoteModel? note, int pointer)? onTapUpdate;
  final Function(int pointer)? onTapUp;

  @override
  State<PianoPro> createState() => _PianoProState();
}

class _PianoProState extends State<PianoPro> {
  List<int> noFlatIndexes = [0, 3];
  bool isPressed = false;
  var scrollPosition = 0.0;

  late List<String> noteNames;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    noteNames = NoteNames.generate(widget.noteType);
    return LayoutBuilder(builder: (context, constraits) {
      if (widget.expand || widget.whiteWidth <= constraits.maxWidth) {
        return pianoWidget(constraits.biggest, false, false);
      } else {
        return Column(
          children: [
            pianoWidget(constraits.biggest, false, true),
            pianoWidget(constraits.biggest, true, false)
          ],
        );
      }
    });
  }

  Widget pianoWidget(Size constraints, bool isScrollable, bool forScrollBar) {
    final pianoWidth =
        widget.expand || forScrollBar ? constraints.width : (widget.whiteWidth);
    final wButtonW = pianoWidth / widget.noteCount;
    final bButtonW = wButtonW / widget.blackWidthRatio;
    var wButtonH = (forScrollBar ? widget.scrollHeight : widget.whiteHeight) -
        (isScrollable ? widget.scrollHeight : 0);
    if (constraints.width < widget.whiteHeight) {
      wButtonH = constraints.width;
    }
    final bButtonH = wButtonH / 1.85;

    NoteModel? offsetToNoteModel(Offset offset) {
      if (offset.dx < 0 || offset.dx >= pianoWidth) return null;
      var buttonIndex = offset.dx ~/ wButtonW;
      var noteIndex = (buttonIndex + widget.firstNoteIndex) % 7;
      var octave =
          ((buttonIndex + widget.firstNoteIndex) / 7 + widget.firstOctave)
              .toInt();
      bool isFlat = false;
      if (offset.dy >= bButtonH) {
        return NoteModel(
            name: NoteNames.generate(widget.noteType)[noteIndex],
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
            buttonIndex != widget.noteCount - 1) {
          ++buttonIndex;
          noteIndex = (buttonIndex + widget.firstNoteIndex) % 7;
          if (noFlatIndexes.contains(noteIndex)) {
            --buttonIndex;
            noteIndex = (buttonIndex + widget.firstNoteIndex) % 7;
            isFlat = false;
          } else {
            octave =
                ((buttonIndex + widget.firstNoteIndex) / 7 + widget.firstOctave)
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

    if (forScrollBar) {
      var scrollButtonW = widget.whiteWidth / widget.noteCount;
      var noteCountOnScreen = constraints.width / scrollButtonW;
      var pianoButtonW = (constraints.width / widget.noteCount);
      var scale = scrollButtonW / pianoButtonW;

      var scrollWidth = noteCountOnScreen * pianoButtonW;
      return Stack(
        children: [
          PianoView(
            showOctaveNumber: false,
            showNames: false,
            firstNoteOctave: widget.firstOctave,
            noteType: widget.noteType,
            whiteButtonWidth: wButtonW,
            whiteButtonHeight: wButtonH,
            noFlatIndexes: noFlatIndexes,
            blackButtonWidth: bButtonW,
            blackButtonHeight: bButtonH,
            firstNote: widget.firstNoteIndex,
            noteCount: widget.noteCount,
          ),
          PianoScrollbar(
              scrollController: scrollController,
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
            onPointerDown: widget.onTapDown == null
                ? null
                : (details) {
                    widget.onTapDown!(offsetToNoteModel(details.localPosition),
                        details.pointer);
                  },
            onPointerMove: widget.onTapUpdate == null
                ? null
                : (details) {
                    widget.onTapUpdate!(
                        offsetToNoteModel(details.localPosition),
                        details.pointer);
                  },
            onPointerUp: widget.onTapUp == null
                ? null
                : (details) => widget.onTapUp!(details.pointer),
            onPointerCancel: widget.onTapUp == null
                ? null
                : (details) => widget.onTapUp!(details.pointer),
            behavior: HitTestBehavior.translucent,
            child: PianoView(
              showOctaveNumber: widget.showOctave,
              showNames: widget.showNames,
              firstNoteOctave: widget.firstOctave,
              noteType: widget.noteType,
              whiteButtonWidth: wButtonW,
              whiteButtonHeight: wButtonH,
              noFlatIndexes: noFlatIndexes,
              blackButtonWidth: bButtonW,
              blackButtonHeight: bButtonH,
              firstNote: widget.firstNoteIndex,
              noteCount: widget.noteCount,
            )),
      );
    }
  }
}
