import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../../../../core/widgets/independent/placeholders/load_widget.dart';
import '../../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../data/models/chat_view_model.dart';
import '../../../domain/entities/chat_entity.dart';

class ChatsList extends StatelessWidget {
  final List<ChatViewModel> items;
  final List<int> loadingItemsIDS;
  final ChatCellType cellType;
  final Function(ChatViewModel) onSelect;
  final Function(ChatCellActionType, ChatEntity) onSelectedOption;
  final bool isScrollable;
  final bool showSpinner;

  ChatsList({
    @required this.items,
    @required this.cellType,
    this.loadingItemsIDS,
    this.onSelect,
    this.onSelectedOption,
    this.isScrollable = true,
    this.showSpinner = false,
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
    final listView = ListView.builder(
      physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: !isScrollable,
      itemBuilder: (context, i) {
        if (!showSpinner) {
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
                    AvatarImage(
                      path: item.imageURL,
                      isFromAsset: false,
                      width: 60, height: 60,
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
              trailing: (loadingItemsIDS ?? []).contains(item.entity.chatId) ? 
                LoadWidget(
                  inCenter: false,
                  size: 16,
                ) : cellType == ChatCellType.optionsWithChat ? 
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
                onSelect(item);
              },
            ),
          );
        } else {
          return CellShimmerItem();
        }
      },
      itemCount: showSpinner ? 10 : items.length,
    );

    return isScrollable ? Expanded(
      child: listView
    ) : listView;
  }
}

// * * Типы cell
enum ChatCellType {
  addChat, optionsWithChat
}


// * * Список возможных actions с cell
enum ChatCellActionType {
  // * * Нужен чтобы удалить чат из списка
  delete, 
  // * * Нужен чтобы переместить чат в другую категорию
  move
}


extension ChatItemActionUIExtension on ChatCellActionType {
  String get title {
    switch (this) {
      case ChatCellActionType.delete:
        return 'Удалить';
      case ChatCellActionType.move:
        return 'Переместить';
      default:
        return null;
    }
  }
}