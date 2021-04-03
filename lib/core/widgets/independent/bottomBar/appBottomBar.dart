import 'package:flutter/material.dart';

import 'bottomBarItem.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const AppBottomBar(
      {@required this.currentIndex, @required this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomBarItem(
                index: 0,
                iconData: Icons.chat,
                onChangeIndex: (index) {
                  onTap(index);
                },
                isSelected: currentIndex == 0),
            BottomBarItem(
              index: 1,
              isSelected: currentIndex == 1,
              iconData: Icons.face,
              onChangeIndex: (index) {
                onTap(index);
              },
            ),
            SizedBox(
              width: 40,
            ),
            BottomBarItem(
              index: 2,
              isSelected: currentIndex == 2,
              iconData: Icons.call,
              onChangeIndex: (index) {
                onTap(index);
              },
            ),
            BottomBarItem(
              index: 3,
              isSelected: currentIndex == 3,
              iconData: Icons.person,
              onChangeIndex: (index) {
                onTap(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final bool isActive;
  final Function onTap;

  const AddButton({Key key, this.isActive = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: ClipOval(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isActive
                  ? null
                  : LinearGradient(colors: <Color>[
                      Theme.of(context).indicatorColor,
                      Color(0xff5A0E99)
                    ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
              color: isActive ? Colors.white : null,
            ),
            width: 60,
            height: 60,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
          ),
        ));
  }
}
