import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/widgets/independent/buttons/icon_text_button.dart';
import '../../../../../main.dart';
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
  final int id;
  final GetChatDetails getChatDetails;

  ChatDetailScreen({
    @required this.id,
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
    _chatDetailsCubit.loadDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _chatDetailsCubit.onFinish(
          id: widget.id, 
          callback: (newPermissions) {
            navigatorKey.currentContext.read<ChatGlobalCubit>().updateChatSettings(
              chatPermissions: newPermissions, id: widget.id
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
                  if (state.chatDetailed?.chatMemberRole == ChatMember.admin)
                    ...[
                      ChatAdminSettings(
                        permissions: state.chatDetailed?.settings
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
                        id: widget.id,
                        callback: (ChatPermissions permissons) {
                          context.read<ChatGlobalCubit>().updateChatSettings(
                            chatPermissions: permissons, id: widget.id
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
                      _chatDetailsCubit.doLeaveChat(widget.id);
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
        context.read<ChatGlobalCubit>().leaveFromChat(id: widget.id);
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
    _chatDetailsCubit.addMembersToChat(widget.id, contacts);
  }
}
