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
    this.count = 7,
    this.width = 300,
    this.expand = true,
    this.height = 250,
    this.showNames = true,
    this.showOctave = true,
    this.first = 0,
    this.firstOctave = 3,
    this.noteType = NoteType.english,
    this.onTapDown,
    this.onTapUpdate,
    this.onTapUp,
    this.ratio = 2,
    this.scrollHeight = 50,
  });

  final int count;
  final double width;
  final bool expand;
  final double height;
  final bool showNames;
  final bool showOctave;
  final int first;
  final int firstOctave;
  final NoteType noteType;
  final double ratio;
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
      if (widget.expand || widget.width <= constraits.maxWidth) {
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
        widget.expand || forScrollBar ? constraints.width : (widget.width);
    final wButtonW = pianoWidth / widget.count;
    final bButtonW = wButtonW / widget.ratio;
    var wButtonH = (forScrollBar ? widget.scrollHeight : widget.height) -
        (isScrollable ? widget.scrollHeight : 0);
    if (constraints.width < widget.height) {
      wButtonH = constraints.width;
    }
    final bButtonH = wButtonH / 1.85;

    NoteModel? offsetToNoteModel(Offset offset) {
      if (offset.dx < 0 || offset.dx >= pianoWidth) return null;
      var buttonIndex = offset.dx ~/ wButtonW;
      var noteIndex = (buttonIndex + widget.first) % 7;
      var octave =
          ((buttonIndex + widget.first) / 7 + widget.firstOctave).toInt();
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
            buttonIndex != widget.count - 1) {
          ++buttonIndex;
          noteIndex = (buttonIndex + widget.first) % 7;
          if (noFlatIndexes.contains(noteIndex)) {
            --buttonIndex;
            noteIndex = (buttonIndex + widget.first) % 7;
            isFlat = false;
          } else {
            octave =
                ((buttonIndex + widget.first) / 7 + widget.firstOctave).toInt();
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
      var scrollButtonW = widget.width / widget.count;
      var noteCountOnScreen = constraints.width / scrollButtonW;
      var pianoButtonW = (constraints.width / widget.count);
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
            firstNote: widget.first,
            noteCount: widget.count,
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
              firstNote: widget.first,
              noteCount: widget.count,
            )),
      );
    }
  }
}
