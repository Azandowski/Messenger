import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';

import '../../../../../app/appTheme.dart';
import '../../../domain/entities/chat_entity.dart';

class ChatsList extends StatelessWidget {
  final List<ChatViewModel> items;
  final ChatCellType cellType;
  final Function(ChatEntity) onSelect;
  final Function(ChatCellActionType, ChatEntity) onSelectedOption;
  
  ChatsList({
    @required this.items,
    @required this.cellType,
    this.onSelect,
    this.onSelectedOption,
    Key key,
  }) : super(key: key) {
    assert(
      (cellType == ChatCellType.addChat && onSelect != null) || (
        cellType != ChatCellType.addChat && onSelect == null
      ),
      'Method onSelect is required for addChat'
    );
    assert(
      (cellType == ChatCellType.optionsWithChat && onSelectedOption != null) || (
        cellType != ChatCellType.optionsWithChat && onSelectedOption == null
      ),
      'Method onSelectedOption is required for optionsWithChat'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
      itemBuilder: (context, i) {
        ChatViewModel item = items[i];
        bool isSelected = cellType == ChatCellType.addChat && item.isSelected;
        
        return Container(
          color: isSelected ? AppColors.lightPinkColor : Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
            leading: FittedBox(
              fit: BoxFit.scaleDown,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(item.imageURL),
                    minRadius: 30,
                  ),
                  if (isSelected) 
                    Positioned(
                      bottom: 0, 
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          color: AppColors.successGreenColor,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        ),
                      ),
                    )
                ],
              ),
            ),
            title: Text(
              item.entity.title, 
              style: AppFontStyles.headerMediumStyle,
            ),
            subtitle: item.hasDescription ? 
              Text(
                item.description,
                style: AppFontStyles.mediumStyle,
              ) : null,
            trailing: cellType == ChatCellType.optionsWithChat ? 
              PopupMenuButton<ChatCellActionType>(
                itemBuilder: (context) => [
                  ChatCellActionType.move, ChatCellActionType.delete
                ].map((e) {
                  return PopupMenuItem(
                    value: e,
                    child: Text(e.title)
                  );
                }).toList(),
                onSelected: (ChatCellActionType action) {
                  onSelectedOption(action, item.entity);
                }
              ) : SizedBox(),
            onTap: (){
              onSelect(item.entity);
            },
          ),
        );
      },
      itemCount: items.length,
    ));
  }
}

// * * ???????? cell
enum ChatCellType {
  addChat, optionsWithChat
}


// * * ???????????? ?????????????????? actions ?? cell
enum ChatCellActionType {
  // * * ?????????? ?????????? ?????????????? ?????? ???? ????????????
  delete, 
  // * * ?????????? ?????????? ?????????????????????? ?????? ?? ???????????? ??????????????????
  move
}


extension ChatItemActionUIExtension on ChatCellActionType {
  String get title {
    switch (this) {
      case ChatCellActionType.delete:
        return '??????????????';
      case ChatCellActionType.move:
        return '??????????????????????';
      default:
        return null;
    }
  }
}