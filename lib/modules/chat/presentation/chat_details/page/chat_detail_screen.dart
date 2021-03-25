import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/application.dart';
import '../../../../../core/config/auth_config.dart';
import '../../../../../core/utils/snackbar_util.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../widgets/chat_detail_appbar.dart';
import '../widgets/chat_groups_block.dart';
import '../widgets/social_media_block.dart';
import '../../chats_screen/pages/chat_screen.dart';
import '../../../../creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';
import '../../../../creation_module/presentation/bloc/open_chat_cubit/open_chat_listener.dart';
import '../../../../groupChat/domain/usecases/create_chat_group.dart';
import '../../../../groupChat/presentation/create_group/create_group_page.dart';
import '../../../../groupChat/presentation/create_group/create_group_screen.dart';
import '../../../../social_media/domain/entities/social_media.dart';
import '../../../../social_media/presentation/pages/social_media_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/application.dart';
import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/widgets/independent/buttons/icon_text_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import '../../../../../locator.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../../groupChat/presentation/choose_contacts/choose_contacts_page.dart';
import '../../../../groupChat/presentation/choose_contacts/choose_contacts_screen.dart';
import '../../../../groupChat/presentation/create_group/create_group_page.dart';
import '../../../../groupChat/presentation/create_group/create_group_screen.dart';
import '../../../../profile/presentation/widgets/profile_item.dart';
import '../../../domain/entities/chat_detailed.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../chat_members/chat_members_screen.dart';
import '../cubit/chat_details_cubit.dart';
import '../widgets/chat_admin_settings.dart';
import '../widgets/chat_detail_appbar.dart';
import '../widgets/chat_detail_header.dart';
import '../widgets/chat_media_block.dart';
import '../widgets/chat_members_block.dart';
import '../widgets/chat_setting_item.dart';
import 'chat_skeleton_page.dart';

enum ProfileMode { user, chat }

class ChatDetailScreen extends StatefulWidget {
  final int id;
  final ProfileMode mode;
  final GetChatDetails getChatDetails;

  ChatDetailScreen({
    @required this.id,
    @required this.getChatDetails,
    this.mode = ProfileMode.chat
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}



class _ChatDetailScreenState extends State<ChatDetailScreen> 
  implements ContactChooseDelegate, SocialMediaPickerDelegate {
  
  ChatDetailsCubit _chatDetailsCubit;
  OpenChatCubit _openChatCubit;
  final OpenChatListener _openChatListener = OpenChatListener();

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

  @override
  void initState() {
    super.initState();
   _openChatCubit = OpenChatCubit(createChatGruopUseCase: sl<CreateChatGruopUseCase>());
    print("LOADING PROFILE OF ${widget.id}");
    _chatDetailsCubit = context.read<ChatDetailsCubit>();
    _chatDetailsCubit.loadDetails(widget.id, widget.mode);
  }

  @override
  void dispose() {
    _openChatCubit.close();
    super.dispose();
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
                    _buildHeaders(state),
                    if (isAdmin || state.chatDetailed.socialMedia != null)
                      SocialMediaBlock(
                        canEdit: state.chatDetailed?.chatMemberRole == ChatMember.admin && 
                          state.chatDetailed.chat != null,
                        socialMedia: state.chatDetailed.socialMedia,
                        onAddPressed: () {
                          _navigator.push(SocialMediaScreen.route(
                            delegate: this, 
                            socialMedia: state.chatDetailed.socialMedia
                          ));
                        },
                        onTapSocialMedia: (socialMediaType) => _handleSocialMediaClick(socialMediaType)
                      ),
                     _buildSeparator(),
                    if (
                      isAdmin &&
                      !(state.chatDetailed.chat.isPrivate ?? false))
                      ...[
                        ChatAdminSettings(
                          permissions: state.chatDetailed?.settings,
                          didSelectOption: (ChatSettings settings, bool newValue) {
                            _chatDetailsCubit.toggleChatSetting(
                              settings: settings, 
                              newValue: newValue, 
                              id: widget.id,
                              callback: (ChatPermissions permissons) {
                                context.read<ChatGlobalCubit>().updateChatSettings(
                                  chatPermissions: permissons, id: widget.id
                                );
                              } 
                            );
                          },
                        ),
                        Divider()
                      ],
                    if (state.chatDetailed.chat != null)
                      ...[
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
                      ],
                    if (state.chatDetailed.media != null)
                      ...[
                        ChatMediaBlock(
                          media: state.chatDetailed.media
                        ),
                         _buildSeparator(),
                      ],
                    if (state.chatDetailed?.chat != null)
                      if (!(state.chatDetailed?.chat?.isPrivate ?? false))
                        ...[
                          IconTextButton(
                            imageAssetPath: 'assets/icons/create.png',
                            onPress: () {
                              _navigator.push(ChooseContactsPage.route(this));
                            },
                            title: 'Добавить участников',
                          ),
                          _buildSeparator(),
                        ],
                    if (state.chatDetailed.membersCount != null)
                      BlocProvider(
                        create: (context) => _openChatCubit,
                        child: BlocConsumer<OpenChatCubit, OpenChatState>(
                          listener: (context, openChatState) {
                            _openChatListener.handleStateUpdate(context, openChatState);
                          },
                          builder: (context, openChatState) {
                            return ChatMembersBlock(
                              members: state.chatDetailed.members, 
                              membersCount: state.chatDetailed.membersCount, 
                              memberRole: state.chatDetailed.chatMemberRole,
                              onShowMoreClick: () {
                                _navigator.push(ChatMembersScreen.route(
                                  state.chatDetailed.chat.chatId, widget.getChatDetails
                                ));
                              },
                              onTapItem: (item) {
                                if (item.id != sl<AuthConfig>().user.id) {
                                  _handleContactDeletionAlert(item);
                                } else {
                                  _openChatCubit.createChatWithUser(item.id);
                                }
                              }
                            );
                          },
                        ),
                      ),
                    _buildSeparator(),
                    if (state.chatDetailed.groups.length != 0)
                      ...[
                        ChatGroups(
                          groups: state.chatDetailed.groups
                        ),
                        _buildSeparator(),
                      ],
                    if (!isMe)
                      ProfileItem(
                        profileItemData: ProfileItemData(
                          icon: widget.mode == ProfileMode.chat ? 
                            Icons.exit_to_app : Icons.block,
                          title: widget.mode == ProfileMode.chat ? 'Выйти' : 
                            (state.chatDetailed.user?.isBlocked ?? false) ? 'Разблокировать' : 'Заблокировать',
                          isRed: true,
                        ),
                        onTap: () {
                          if (widget.mode == ProfileMode.chat) {
                            _chatDetailsCubit.doLeaveChat(widget.id);
                          } else {
                            var isBlock = !(state.chatDetailed.user?.isBlocked ?? false);
                            _chatDetailsCubit.blockUnblockUser(userID: widget.id, isBlock: isBlock);
                          }
                        },
                      ),
                    _buildSeparator(height: 200)
                  ],
                ),
              ),
              ChildDetailAppBar(
                canEdit: state.chatDetailed.chatMemberRole == ChatMember.admin && state.chatDetailed.chat != null,
                onPressRightIcon: () {
                  _navigator.push(CreateGroupPage.route(
                    mode: CreateGroupScreenMode.edit,
                    chatEntity: state.chatDetailed.chat
                  ));
                },
                onPressLeftIcon: () {
                  _chatDetailsCubit.onFinish(
                    id: widget.id, 
                    callback: (newPermissions) {
                      sl<Application>().navKey.currentContext.read<ChatGlobalCubit>().updateChatSettings(
                        chatPermissions: newPermissions, id: widget.id
                      );
                    }
                  );
  
                  Navigator.of(context).pop(state.chatDetailed?.settings);
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

  Widget _buildHeaders (ChatDetailsState state) {
    return BlocProvider(
      create: (context) => OpenChatCubit(
        createChatGruopUseCase: sl<CreateChatGruopUseCase>()
      ),
      child: BlocConsumer<OpenChatCubit, OpenChatState>(
        listener: (context, openChatState) {
          OpenChatListener().handleStateUpdate(context, openChatState);
        },
        builder: (context, openChatState) {
          return ChatDetailHeader(
            chatDetailed: state.chatDetailed,
            onCommunicationHandle: (CommunicationType type) {
              if (widget.mode == ProfileMode.user) {
                context.read<OpenChatCubit>().createChatWithUser(state.chatDetailed?.user?.id);
              } else {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => 
                    ChatScreen(chatEntity: _chatDetailsCubit.state.chatDetailed.chat)),
                );
              }
            },
          );
        },
      ),
    );
  }


  void _handleSocialMediaClick (SocialMediaType socialMediaType) async {
    var _url = _getSocialMediaURL(socialMediaType, socialMediaType.getValue(_chatDetailsCubit.state.chatDetailed.socialMedia));
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      _chatDetailsCubit.showError('Не удалось открыть');
    }
  }

  void _handleListener (ChatDetailsState state) {
    if (state is ChatDetailsError) {
      SnackUtil.showError(context: context, message: state.message);
    } else if (state is ChatDetailsProccessing) {
      SnackUtil.showLoading(context: context);
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
            _chatDetailsCubit.kickMember(widget.id, entity.id);
          }
        )
      ]
    ));
  }

  bool get isMe {
    return widget.mode == ProfileMode.user && 
      _chatDetailsCubit.state.chatDetailed?.user?.id == sl<AuthConfig>().user.id;
  }

  bool get isAdmin {
    return _chatDetailsCubit.state.chatDetailed?.chatMemberRole == ChatMember.admin && 
      _chatDetailsCubit.state.chatDetailed.chat != null;
  }

  String _getSocialMediaURL (SocialMediaType type, String value) {
    if (type == SocialMediaType.whatsapp) {
      return 'wa.me/$value';
    } else {
      return value;
    }
  }

  // MARK: - Delegates

  @override
  void didSaveContacts(List<ContactEntity> contacts) {
    _chatDetailsCubit.addMembersToChat(widget.id, contacts);
  }

  @override
  void didFillSocialMedia(SocialMedia socialMedia) {
    _chatDetailsCubit.setNewSocialMedia(
      id: widget.id, 
      newSocialMedia: socialMedia
    );
  }
}
