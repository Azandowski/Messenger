import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../../domain/entities/chat_entity.dart';

enum ChatCellType {add, delete}

class ChatsList extends StatelessWidget {
  final items;
  final ChatCellType cellType;
  final Function(ChatEntity) onSelect;
  final Function(ChatEntity) onDelete;
  const ChatsList({
    @required this.items,
    @required this.cellType,
    this.onSelect,
    this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
      itemBuilder: (context, i) {
        ChatEntity item = items[i];
        bool selected = cellType == ChatCellType.add && item.selected;
        return Container(
          color: selected ? AppColors.lightPinkColor : Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
            leading: FittedBox(
              fit: BoxFit.scaleDown,
              child: Stack(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(item.imageUrl),minRadius: 30,),
                  if(selected) Positioned(bottom: 0, right: 0,
                   child: ClipOval(
                     child: Container(
                       color: AppColors.successGreenColor,
                     child: Icon(Icons.done,color: Colors.white,)
                     ),
                     ),
                     )
                ],
              ),
            ),
            title: Text(item.title, style: AppFontStyles.mainStyle,),
            trailing: cellType == ChatCellType.add ? SizedBox() : GestureDetector(
              onTap: (){
                onDelete(item);
              },
              child: Icon(Icons.delete)) ,
            onTap: (){
              onSelect(item);
            },
          ),
        );
      },
      itemCount: items.length,
    ));
  }
}