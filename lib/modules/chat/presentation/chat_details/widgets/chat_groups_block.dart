import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/images/ImageWithCorner.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';

class ChatGroups extends StatelessWidget {

  final List<ChatEntity> groups;

  ChatGroups({
    @required this.groups
  });

  @override
  Widget build(BuildContext context) {
    return DividerWrapper(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Center(
            child: Text(
              'Общие группы',
              style: AppFontStyles.grey14w400,
            ),
          ),
        ),
        ...groups.map(
          (e) => _buildGroupCell(e)
        ).toList()
      ]
    );
  }

  Widget _buildGroupCell (ChatEntity entity) {
    ChatViewModel chatViewModel = ChatViewModel(entity);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          AvatarImage(
            isFromAsset: false,
            path: chatViewModel.imageURL,
            width: 35,
            height: 35,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatViewModel.title,
                  style: AppFontStyles.headerMediumStyle,
                  overflow: TextOverflow.ellipsis, 
                ),
                Text(
                  chatViewModel.description,
                  style: chatViewModel.descriptionStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}