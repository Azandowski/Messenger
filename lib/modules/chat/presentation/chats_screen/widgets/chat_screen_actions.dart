
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/utils/unavailable_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../app/appTheme.dart';
import '../../../../../app/application.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../../locator.dart';
import '../../../../category/domain/entities/chat_entity.dart';
import '../../../../chats/presentation/pages/chats_search_screen.dart';
import '../../chat_details/page/chat_detail_page.dart';
import '../../chat_details/page/chat_detail_screen.dart';
import '../../time_picker/time_picker_screen.dart';
import 'appBars/chat_app_bar.dart';


class ChatScreenActions extends StatelessWidget {
  
  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  
  final TimePickerDelegate timePickerDelegate;
  final ChatEntity chatEntity;
  final bool isSecretModeOn;
  final Function(ChatAppBarActions) onTapChatAction;

  const ChatScreenActions({
    @required this.onTapChatAction,
    this.timePickerDelegate,
    this.chatEntity,
    this.isSecretModeOn = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.video_call, 
            color: AppColors.indicatorColor,
          ), 
          onPressed: () {
            UnavailableFeatureDialog.show(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
            UnavailableFeatureDialog.show(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: AppColors.indicatorColor,
          ),
          onPressed: () {
            showDialog(context: context,builder: (_) {
              return DialogsView( 
                dialogViewType: DialogViewType.actionSheet,
                actionButton: [
                  DialogActionButton(
                    title: chatEntity.isPrivate ? 'profile_info'.tr() : 'more_info'.tr(), 
                    iconData: Icons.person,
                    buttonStyle: DialogActionButtonStyle.black,
                    onPress: () {
                      _navigator.push(ChatDetailPage.route(
                        chatEntity.chatId,
                        ProfileMode.chat
                      ));
                    }
                  ),
                  DialogActionButton(
                    title: 'search'.tr(), 
                    iconData: Icons.search,
                    buttonStyle: DialogActionButtonStyle.black,
                    onPress: () {
                      _navigator.push(ChatsSearchScreen.route(chatEntity: chatEntity));
                    }
                  ),
                  DialogActionButton(
                    title: (isSecretModeOn ?? false) ? 'turn_off_secret_mode'.tr() : 'turn_on_secret_mode'.tr(), 
                    iconData: Icons.timer,
                    buttonStyle: DialogActionButtonStyle.dangerous,
                    onPress: () {
                      if (!(isSecretModeOn ?? false)) {
                        showDialog(context: context, builder: (_) => showSecretModeDialog(
                          onSelect: (bool isAgree) {
                            if (isAgree) {
                              onTapChatAction(ChatAppBarActions.onOffSecretMode);
                            }
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        ));
                      } else {
                        onTapChatAction(ChatAppBarActions.onOffSecretMode);
                        Navigator.of(context).pop();
                      }
                    }
                  ),
                ],
              );
            });
          },
        )
      ],
    );
  }

  Widget showSecretModeDialog ({
    @required Function(bool) onSelect
  }) {
    return DialogsView(
      dialogViewType: DialogViewType.alert,
      imageProvider: AssetImage('assets/images/privacy_logo.png'),
      title: "deletion_timer".tr(),
      titleStyle: AppFontStyles.headingTextSyle,
      buttonsLayout: DialogViewButtonsLayout.vertical,
      customDescription: Column(
        children: [
          _buildItem(
            iconPath: 'assets/icons/fire.png', 
            title: 'can_delete_messages'.tr()
          ),
          SizedBox(height: 12),
          _buildItem(
            iconPath: 'assets/icons/lock.png', 
            title: 'forward_lock'.tr()
          ),
          SizedBox(height: 12),
          _buildItem(
            iconPath: 'assets/icons/server.png', 
            title: 'no_cache'.tr()
          )
        ],
      ),
      actionButton: [
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.custom,
          customButton: ActionButton(
            text: "ready".tr(),
            onTap: () {
              onSelect(true);
            }
          ),
        ),
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.cancel,
          title: "cancel".tr(),
          onPress: () {
            onSelect(false);
          }
        )
      ],
    );
  }

  Widget _buildItem ({
    @required String iconPath,
    @required String title
  }) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 14,
          height: 14,
        ),
        SizedBox(width: 8),
        Expanded(child: 
          Text(
            title,
            style: AppFontStyles.grey12w400
          )
        )
      ],
    );
  }
}


