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
    setState(() {
      scrollPosition = position;
    });
    widget.scrollController.jumpTo(position * widget.scale);
  }

  void animateToScrollPosition(double position) {
    setState(() {
      scrollPosition = position;
    });
    widget.scrollController.animateTo(position * widget.scale,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final newPosition = scrollPosition + dx;

    if (newPosition <= 0 && dx <= 0) return;

    if (newPosition + widget.scrollWidth >= widget.constraints.width &&
        dx >= 0) {
      jumpToScrollPosition(scrollPosition);
      return;
    }

    if (newPosition < 0) {
      jumpToScrollPosition(0);
      return;
    }

    if (newPosition + widget.scrollWidth > widget.constraints.width) {
      jumpToScrollPosition(widget.constraints.width - widget.scrollWidth);
      return;
    }

    jumpToScrollPosition(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        final position = details.localPosition.dx - (widget.scrollWidth / 2);
        if (position <= 0) {
          animateToScrollPosition(0);
        } else if (position + widget.scrollWidth >= widget.constraints.width) {
          animateToScrollPosition(
              widget.constraints.width - widget.scrollWidth);
        } else {
          animateToScrollPosition(position);
        }
      },
      onHorizontalDragUpdate: handleDragUpdate,
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
