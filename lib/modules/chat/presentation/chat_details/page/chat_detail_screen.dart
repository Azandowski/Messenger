import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialog_params.dart';
import 'package:messenger_mobile/core/widgets/independent/dialogs/dialogs.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_appbar.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_screen.dart';

import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/widgets/independent/buttons/icon_text_button.dart';
import '../../../../../locator.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../../groupChat/presentation/choose_contacts/choose_contacts_page.dart';
import '../../../../groupChat/presentation/choose_contacts/choose_contacts_screen.dart';
import '../../../../profile/presentation/widgets/profile_item.dart';
import '../../../domain/entities/chat_detailed.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../chat_members/chat_members_screen.dart';
import '../cubit/chat_details_cubit.dart';
import '../widgets/chat_admin_settings.dart';
import '../widgets/chat_detail_header.dart';
import '../widgets/chat_media_block.dart';
import '../widgets/chat_members_block.dart';
import '../widgets/chat_setting_item.dart';
import 'chat_skeleton_page.dart';

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

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  @override
  void initState() {
    super.initState();
    _chatDetailsCubit = context.read<ChatDetailsCubit>();
    _chatDetailsCubit.loadDetails(widget.chatEntity.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailsCubit, ChatDetailsState>(
      listener: (context, state) {
        _handleListener(state);
      },
      builder: (context, state) {
        if (!(state is ChatDetailsLoading)) {
          return Stack(
            children: [
              SingleChildScrollView(
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
                    if (!(state.chatDetailed?.chat?.isPrivate ?? false))
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
                      memberRole: state.chatDetailed.chatMemberRole,
                      onShowMoreClick: () {
                        _navigator.push(ChatMembersScreen.route(
                          state.chatDetailed.chat.chatId, widget.getChatDetails
                        ));
                      },
                      onTapItem: (item) {
                        _handleContactDeletionAlert(item);
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
              ),
              ChildDetailAppBar(
                canEdit: state.chatDetailed.chatMemberRole == ChatMember.admin,
                onPressRightIcon: () {
                  _navigator.push(CreateGroupPage.route(
                    mode: CreateGroupScreenMode.edit,
                    chatEntity: widget.chatEntity
                  ));
                },
                onPressLeftIcon: () {
                  _chatDetailsCubit.onFinish(
                    id: widget.chatEntity.chatId, 
                    callback: (newPermissions) {
                      sl<Application>().navKey.currentContext.read<ChatGlobalCubit>().updateChatSettings(
                        chatPermissions: newPermissions, id: widget.chatEntity.chatId
                      );
                    }
                  );
  
                  Navigator.of(context).pop();
                },
              ),
            ],
          );  
        } else {
          return ChatSkeletonPage();
        }
      },
    );
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

  // MARK: - Contact Deletion

  void _handleContactDeletionAlert (ContactEntity entity) {
    showDialog(context: context, builder: (context) => DialogsView(
      title: 'Удалить участника',
      description: 'Это действие нельзя отменить',
      actionButton: [
        DialogActionButton(
          title: 'Назад',
          buttonStyle: DialogActionButtonStyle.cancel,
          onPress: () {
            Navigator.of(context).pop();
          }
        ),
        DialogActionButton(
          title: 'Удалить',
          buttonStyle: DialogActionButtonStyle.dangerous,
          onPress: () {
            Navigator.of(context).pop();
            _chatDetailsCubit.kickMember(widget.chatEntity.chatId, entity.id);
          }
        )
      ]
    ));
  }

  @override
  void didSaveChats(List<ContactEntity> contacts) {
    _chatDetailsCubit.addMembersToChat(widget.chatEntity.chatId, contacts);
  }
}
