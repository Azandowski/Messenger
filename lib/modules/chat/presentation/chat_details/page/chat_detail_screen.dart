import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/icon_text_button.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_skeleton_page.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_admin_settings.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_header.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_members_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_members/chat_members_screen.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_screen.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_item.dart';

import '../../../../../main.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatEntity chatEntity;
  final GetChatDetails getChatDetails;

  ChatDetailScreen({
    @required this.chatEntity,
    @required this.getChatDetails
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> implements ContactChooseDelegate {
  
  ChatDetailsCubit _chatDetailsCubit;

  NavigatorState get _navigator => navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    _chatDetailsCubit = context.read<ChatDetailsCubit>();
    _chatDetailsCubit.loadDetails(widget.chatEntity.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _chatDetailsCubit.onFinish(
          id: widget.chatEntity.chatId, 
          callback: (newPermissions) {
            navigatorKey.currentContext.read<ChatGlobalCubit>().updateChatSettings(
              chatPermissions: newPermissions, id: widget.chatEntity.chatId
            );
          }
        );

        return true;
      },
      child: BlocConsumer<ChatDetailsCubit, ChatDetailsState>(
        listener: (context, state) {
          _handleListener(state);
        },
        builder: (context, state) {
          if (!(state is ChatDetailsLoading)) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatDetailHeader(chatDetailed: state.chatDetailed),
                  if (state.chatDetailed?.chatMemberRole == ChatMember.admin && !(state.chatDetailed?.chat?.isPrivate ?? false))
                    ...[
                      ChatAdminSettings(
                        permissions: state.chatDetailed?.settings,
                        didSelectOption: (ChatSettings settings, bool newValue) {
                          _chatDetailsCubit.toggleChatSetting(
                            settings: settings, 
                            newValue: newValue, 
                            id: widget.chatEntity.chatId,
                            callback: (ChatPermissions permissons) {
                              context.read<ChatGlobalCubit>().updateChatSettings(
                                chatPermissions: permissons, id: widget.chatEntity.chatId
                              );
                            } 
                          );
                        },
                      ),
                      Divider()
                    ],
                  ChatSettingItem(
                    chatSetting: ChatSettings.noSound,
                    isOn: !ChatSettings.noSound.getValue(state.chatDetailed?.settings),
                    onToggle: (value) {
                      _chatDetailsCubit.toggleChatSetting(
                        settings: ChatSettings.noSound, 
                        newValue: value, 
                        id: widget.chatEntity.chatId,
                        callback: (ChatPermissions permissons) {
                          context.read<ChatGlobalCubit>().updateChatSettings(
                            chatPermissions: permissons, id: widget.chatEntity.chatId
                          );
                        } 
                      );
                    },
                  ),
                  _buildSeparator(),
                  ChatMediaBlock(
                    media: state.chatDetailed.media
                  ),
                  _buildSeparator(),
                  IconTextButton(
                    imageAssetPath: 'assets/icons/create.png',
                    onPress: () {
                      _navigator.push(ChooseContactsPage.route(this));
                    },
                    title: 'Добавить участников',
                  ),
                  _buildSeparator(),
                  ChatMembersBlock(
                    members: state.chatDetailed.members, 
                    membersCount: state.chatDetailed.membersCount, 
                    onShowMoreClick: () {
                      _navigator.push(ChatMembersScreen.route(
                        state.chatDetailed.chat.chatId, widget.getChatDetails
                      ));
                    }
                  ),
                  _buildSeparator(),
                  ProfileItem(
                    profileItemData: ProfileItemData(
                      icon: Icons.exit_to_app,
                      title: 'Выйти',
                      isRed: true,
                    ),
                    onTap: () {
                      _chatDetailsCubit.doLeaveChat(widget.chatEntity.chatId);
                    },
                  ),
                  _buildSeparator(height: 200)
                ],
              ),
            );
          } else {
            return ChatSkeletonPage();
          }
        },
      ),
    );
  }


  List<ChatSettings> _getChatSettings (ChatDetailsState state) {
    if ((state.chatDetailed?.chatMemberRole ?? ChatMember.member) == ChatMember.admin) {
      return [
        ChatSettings.noSound,
        ChatSettings.noMedia
      ];
    } else {
      return [
        ChatSettings.noSound
      ];
    }
  }

  void _handleListener (ChatDetailsState state) {
    if (state is ChatDetailsError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is ChatDetailsProccessing) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: LinearProgressIndicator(), duration: Duration(days: 2),)
        );
    } else {
      if (state is ChatDetailsLeave) {
        context.read<ChatGlobalCubit>().leaveFromChat(id: widget.chatEntity.chatId);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  Widget _buildSeparator ({double height}) {
    return Container(
      height: height ?? 20,
      color: Colors.grey[200],
    );
  }

  @override
  void didSaveChats(List<ContactEntity> contacts) {
    _chatDetailsCubit.addMembersToChat(widget.chatEntity.chatId, contacts);
  }
}
