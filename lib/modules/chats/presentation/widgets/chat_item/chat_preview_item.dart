import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/images/ImageWithCorner.dart';
import '../../../../category/data/models/chat_view_model.dart';
import 'chat_notification_view.dart';
import 'chat_preview_settings.dart';

class ChatPreviewItem extends StatelessWidget {
  
  final ChatViewModel viewModel;

  ChatPreviewItem(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(147, 87, 205, viewModel.isSelected ? 0.15 : 0),
      padding: const EdgeInsets.symmetric(
        vertical: 8, horizontal: 16
      ),
      child: Row(
        children: [
          AvatarImage(
            isFromAsset: false,
            path: viewModel.imageURL,
            width: 55,
            height: 55,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      viewModel.title,
                      style: AppFontStyles.headerMediumStyle,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    ChatPreviewSettings(
                      dateString: viewModel.dateTime,
                      settings: viewModel.chatSettings,
                    )
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        viewModel.description,
                        style: viewModel.descriptionStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    _bottomPinBuilder()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  // * * Build Chat Bottom Icon

  Widget _bottomPinBuilder () {
    switch (this.viewModel.bottomPin) {
      case ChatBottomPin.badge:
        return _buildNotificationBadge();
      case ChatBottomPin.unread: case ChatBottomPin.read:
        return _buildReadUnreadIcon();
      case ChatBottomPin.none:
        return Container();
    }
  }

  // show number of unread messages
  Widget _buildNotificationBadge () {
    return ChatNotificationView(
      badgeCount: viewModel.unreadMessages,
    );
  }

  // show Read or Unread
  Widget _buildReadUnreadIcon () {
    return Image(
      width: 22,
      height: 8,
      image: AssetImage('assets/images/${viewModel.isRead ? "read" : "unread"}.png'),
    );
  }
}