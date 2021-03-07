import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../helpers/creation_actions.dart';

class ActionsContainer extends StatelessWidget {
  
  final Function(CreationActions) onTap;
  
  ActionsContainer({
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CreationActions.values.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem (CreationActions action) {
    return GestureDetector(
      onTap: () {
        onTap(action);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200])
          )
        ),
        child: ListTile(
          leading: Image.asset(
            action.iconAssetPath,
            width: 35, height: 35,
          ),
          title: Text(
            action.title,
            style: AppFontStyles.headerMediumStyle,
          ),
        ),
      ),
    );
  }
}