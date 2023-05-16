import 'package:flutter/material.dart';

class PianoScrollbar extends StatefulWidget {
  const PianoScrollbar({
    Key? key,
    required this.scrollController,
    required this.scrollWidth,
    required this.constraints,
    required this.scale,
    required this.wButtonH,
  }) : super(key: key);

  final ScrollController scrollController;
  final double scrollWidth;
  final Size constraints;
  final double scale;
  final double wButtonH;

  @override
  State<PianoScrollbar> createState() => _PianoScrollbarState();
}

class _PianoScrollbarState extends State<PianoScrollbar> {
  double scrollPosition = 0.0;

  void jumpToScrollPosition(double position) {
    scrollPosition = position;
    widget.scrollController.jumpTo(scrollPosition * widget.scale);
  }

  @override
  Widget build(BuildContext context) {
    final maxScrollWidth = widget.constraints.width - widget.scrollWidth;

    return GestureDetector(
      onHorizontalDragDown: (details) {
        final position = details.localPosition.dx - (widget.scrollWidth / 2);
        if (position <= 0) {
          jumpToScrollPosition(0);
        } else if (position + widget.scrollWidth >= widget.constraints.width) {
          jumpToScrollPosition(maxScrollWidth);
        } else {
          scrollPosition = position;
          jumpToScrollPosition(position);
        }
        setState(() {});
      },
      onHorizontalDragUpdate: (details) {
        final dx = details.delta.dx;

        if (scrollPosition <= 0 && dx <= 0) return;

        if (scrollPosition + widget.scrollWidth >= widget.constraints.width &&
            dx >= 0) {
          jumpToScrollPosition(scrollPosition);
          return;
        }

        if (scrollPosition + dx < 0) {
          jumpToScrollPosition(0);
          return;
        }

        if (scrollPosition + dx + widget.scrollWidth >
            widget.constraints.width) {
          jumpToScrollPosition(widget.constraints.width - widget.scrollWidth);
          return;
        }

        setState(() {
          scrollPosition += dx;
        });
        jumpToScrollPosition(scrollPosition);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
            width: scrollPosition,
            height: widget.wButtonH,
          ),
          Container(
            height: widget.wButtonH,
            width: widget.scrollWidth,
            color: Colors.transparent,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            width: widget.constraints.width -
                (scrollPosition + widget.scrollWidth),
            height: widget.wButtonH,
          ),
        ],
      ),
    );
  }
}
