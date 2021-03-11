import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/icon_text_button.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_skeleton_page.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_header.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_members_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_members/chat_members_screen.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/choose_contacts_screen.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_item.dart';

import '../../../../../main.dart';

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
          if (state is ChatDetailsError) {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ChatDetailsProccessing) {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(content: LinearProgressIndicator(), duration: Duration(days: 2),)
            );
          } else {
            if (state is ChatDetailsLeave) {
              context.read<ChatGlobalCubit>().leaveFromChat(id: widget.id);
              Navigator.of(context).popUntil((route) => route.isFirst);
            }

            Scaffold.of(context).hideCurrentSnackBar();
          }
        },
        builder: (context, state) {
          if (!(state is ChatDetailsLoading)) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatDetailHeader(chatDetailed: state.chatDetailed),
                  DividerWrapper(
                    children: ChatSettings.values.map((e) => ChatSettingItem(
                      chatSetting: e,
                      isOn: !e.getValue(state.chatDetailed?.settings),
                      onToggle: (value) {
                        _chatDetailsCubit.toggleChatSetting(
                          settings: e, 
                          newValue: value, 
                          id: widget.id,
                          callback: (ChatPermissions permissons) {
                            context.read<ChatGlobalCubit>().updateChatSettings(
                              chatPermissions: permissons, id: widget.id
                            );
                          } 
                        );
                      },
                    )).toList(),
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