import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../../../category/data/models/chat_view_model.dart';
import '../../../../category/domain/entities/chat_entity.dart';
import 'divider_wrapper.dart';

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
              'shared_groups'.tr(),
              style: AppFontStyles.grey14w400,
            ),
          ),
        ),
        ...groups.map(
          (e) => _buildGroupCell(e, context)
        ).toList()
      ]
    );
  }

  Widget _buildGroupCell (ChatEntity entity, BuildContext context) {
    ChatViewModel chatViewModel = ChatViewModel(entity);

    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => 
            ChatScreen(chatEntity: entity)
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}