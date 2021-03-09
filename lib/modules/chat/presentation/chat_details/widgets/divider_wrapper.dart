import 'package:flutter/material.dart';

class DividerWrapper extends StatelessWidget {
  
  final List<Widget> children;

  const DividerWrapper({
    @required this.children, 
    Key key
  }) : super(key: key);
  
  List<Widget> buildItems () {
    List<Widget> widgets = [];

    for (Widget widget in children) {
      widgets.add(
        widget
      );

      if (widget != children.last) {
        widgets.add(Divider());
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: buildItems()
    );
  }
}