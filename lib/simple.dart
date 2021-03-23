

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Slide()));
}

class Indicator extends StatelessWidget {
  Indicator({ Key key, this.link, this.offset }) : super(key: key);

  final LayerLink link;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      offset: offset,
      link: link,
      child: Container(
        color: Colors.green,
      ),
    );
  }
}

class Slide extends StatefulWidget {
  Slide({ Key key }) : super(key: key);

  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  final double indicatorWidth = 24.0;
  final double indicatorHeight = 300.0;
  final double slideHeight = 200.0;
  final double slideWidth = 400.0;

  final LayerLink layerLink = LayerLink();
  OverlayEntry overlayEntry;
  OverlayEntry pause;
  Offset indicatorOffset;
  Offset pauseOffset;


  Offset getIndicatorOffset(Offset dragOffset) {
    final double x = (dragOffset.dx).clamp(slideWidth/2, slideWidth);
    final double y = (dragOffset.dy).clamp(slideHeight/2, slideHeight*2);
    return Offset(x, y);
  }
  Offset getPauseOffset(Offset dragOffset) {
    final double x = slideWidth - 50;
    final double y = (dragOffset.dy+40).clamp(slideHeight/2, slideHeight*2);
    return Offset(x, y);
  }

  void showIndicator(DragStartDetails details) {
    indicatorOffset = getIndicatorOffset(details.localPosition);
    pauseOffset = getPauseOffset(details.localPosition);
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0.0,
          left: 0.0,
          child: SizedBox(
            width: indicatorWidth,
            height: 20,
            child: Indicator(
                offset: indicatorOffset,
                link: layerLink
            ),
          ),
        );
      },
    );
    pause = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0.0,
          left: 0.0,
          child:  CompositedTransformFollower(
            offset: pauseOffset,
            link: layerLink,
            child: Container(
              width: 10,
              height: 10,
              color: Colors.black,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insertAll([pause, overlayEntry]);

  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = getIndicatorOffset(details.localPosition);
    pauseOffset = getPauseOffset(details.localPosition);
    pause.markNeedsBuild();
    overlayEntry.markNeedsBuild();
  }

  void hideIndicator(DragEndDetails details) {
    overlayEntry.remove();
    pause.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Indicator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CompositedTransformTarget(
            link: layerLink,
            child: Container(
              width: slideWidth,
              height: slideHeight,
              color: Colors.blue.withOpacity(0.2),
              child: GestureDetector(
                onPanStart: showIndicator,
                onPanUpdate: updateIndicator,
                onPanEnd: hideIndicator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}