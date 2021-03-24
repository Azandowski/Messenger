import 'package:flutter/rendering.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/utils/snackbar_util.dart';
import 'package:messenger_mobile/modules/category/presentation/chooseChats/presentation/chat_choose_page.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/cubit/time_cubit/timer_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/remove_dialog_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart' as main_chat_cubit;
import '../../../../category/presentation/chooseChats/presentation/chat_choose_page.dart';
import '../../../domain/entities/chat_actions.dart';
import '../widgets/chatControlPanel/chatControlPanel.dart';
import '../widgets/remove_dialog_view.dart';
import 'chat_screen.dart';
import 'chat_screen_import.dart';

extension ChatScreenStateHelper on ChatScreenState {

  // Get App Bar
  PreferredSizeWidget buildAppBar (
    ChatTodoCubit chatTodoCubit,
    ChatTodoState state,
    ChatState chatScreenState,
    ChatViewModel chatViewModel,
    NavigatorState navigator,
    Function(ChatAppBarActions) onTapChatAction
  ) {
    return state is ChatTodoSelection ? SelectionAppBar(
      chatViewModel: chatViewModel, 
      widget: widget, 
      chatTodoCubit: chatTodoCubit,
      appBar: AppBar(),
    ) : ChatAppBar(
      chatViewModel: chatViewModel, 
      navigator: navigator, 
      widget: widget, 
      appBar: AppBar(),
      isSecretModeOn: chatScreenState.isSecretModeOn,
      onTapChatAction: onTapChatAction
    );
  }

  DecorationImage getBackground (ChatState state) {
    return DecorationImage(
      image: state.wallpaperPath != null ? 
        FileImage(File(state.wallpaperPath)) : 
          AssetImage('assets/images/bg-home.png'),
      fit: BoxFit.cover
    );
  }

  Widget buildChatBottom (
    ChatTodoState state, 
    ChatTodoCubit chatTodoCubit,
    double width, 
    double height,
    { bool canSendMedia }
  ) {
    if (state is ChatTodoSelection || state is ChatToDoLoading) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16,8,16,8),
        child: ActionButton(
          isLoading: state is ChatToDoLoading,
          text: state.isDelete ? 'Удалить' : 'Переслать',
          onTap: () {
            if (state.isDelete) {
              showDialog(context: context, builder: (ctx) {
                return DeleteDialogView(onDelete: (forMe){
                  chatTodoCubit.deleteMessage(
                    chatID: widget.chatEntity.chatId,
                    forMe: forMe
                  );
                });
              });
            } else {
              Navigator.push(context, ChooseChatsPage.route(this, actionText: 'Переслать'));
            }
          }
        ),
      );
    } else {
      return ChatControlPanel(
        messageTextController: messageTextController, 
        width: width,
        height: height,
        canSendMedia: canSendMedia
      );
    }
  }

  Widget buildTopMessage (
    ChatState state, 
    double width, 
    double height, 
    ChatTodoCubit cubit
  ) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppColors.indicatorColor,
            width: 2,
            height: 55,
          ),
          SizedBox(width: 8,),
          Expanded(
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Закрепленное сообщение',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: AppColors.indicatorColor,
                  ),
                ),
                Container(
                  child: Text(state.topMessage.text,
                    style: AppFontStyles.black14w400.copyWith(
                      height: 1.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.close), onPressed: (){
            showDialog(context: context, builder: (ctx){
              return DialogsView( 
                title: 'Вы хотите открепить сообщение?',
                actionButton: [
                  DialogActionButton(
                    title: 'Отмена', 
                    buttonStyle: DialogActionButtonStyle.cancel,
                    onPress: () {
                      Navigator.pop(context);
                    }
                  ),
                  DialogActionButton(
                    title: 'Открепить', 
                    buttonStyle: DialogActionButtonStyle.submit,
                    onPress: () {
                      cubit.disattachMessage();
                      Navigator.pop(context);
                    }
                  ),
                ],
              );
            });
          // cubit.detachMessage();
          })
        ],
      ),
    );
  }

  Widget buildSeparator (int index, ChatState state) {
    if (!(state is ChatLoading && getItemsCount(state) - 1 == index)) {
      Message nextMessage = state.messages.getItemAt(index + 1);
    
      if (
        nextMessage != null && 
        nextMessage.dateTime?.day != null && 
        state.messages[index].dateTime?.day != null && 
        nextMessage.dateTime?.day != state.messages[index].dateTime?.day
      ) {
        return ChatActionView(
          chatAction: TimeAction(
            dateTime: state.messages[index].dateTime,
            action: ChatActions.newDay
          ),
        );
      } 
    } 
 
    return Container();
  }

  Future<void> messageActionProcess(
    MessageCellActions action, 
    BuildContext context, 
    MessageViewModel messageViewModel,
    PanelBlocCubit panelBlocCubit,
    ChatTodoCubit chatTodoCubit
  ) async {
    switch (action){
      case MessageCellActions.copyMessage:
        Clipboard.setData(ClipboardData(text: messageViewModel.messageText))
        ..then((result) {
          final snackBar = SnackBar(
            content: Text('Скопировано в буфер обмена'),
          );
          
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        break;
      case MessageCellActions.attachMessage:
        chatTodoCubit.attachMessage(messageViewModel.message);
        break;
      case MessageCellActions.replyMessage:
        panelBlocCubit.addMessage(messageViewModel);
        break;
      case MessageCellActions.replyMore:
        chatTodoCubit.enableSelectionMode(messageViewModel.message, false);
        break;
      case MessageCellActions.deleteMessage:
        chatTodoCubit.enableSelectionMode(messageViewModel.message, true);
        break;
    }
  }

  

  void handleListener (
    ChatState state, 
    {
      AutoScrollController scrollController,
      ChatTodoCubit todoCubit
    }
  ) {
    if (state is ChatError) {
      SnackUtil.showError(context: context, message: state.message);
    } else if (state is ChatLoadingSilently) {
      SnackUtil.showLoading(context: context);
    } else if (state is ChatInitial) {
      // Update Notification Badge
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      var chatGlobalCubit = context.read<main_chat_cubit.ChatGlobalCubit>();
      
      chatGlobalCubit.setSecretMode(isOn: state.isSecretModeOn, chatId: widget.chatEntity.chatId);
      
      var globalIndexOfChat = chatGlobalCubit.state.chats.indexWhere((e) => e.chatId == widget.chatEntity.chatId);

      if (globalIndexOfChat != -1) {
        if (chatGlobalCubit.state.chats[globalIndexOfChat].unreadCount != 0) {
          context.read<main_chat_cubit.ChatGlobalCubit>().resetChatNoReadCounts(chatId: widget.chatEntity.chatId);
          if (widget.chatEntity.chatCategory?.id != null) {

            int index = categoryBloc.state.categoryList.indexWhere((e) => e.id == widget.chatEntity.chatCategory?.id);
            int noReadCount = categoryBloc.state.categoryList[index].noReadCount;
            categoryBloc.add(CategoryReadCountChanged(
              categoryID: widget.chatEntity.chatCategory?.id,
              newReadCount: noReadCount > 0 ? noReadCount - 1 : 0
            ));
          }
        }
      }

      if (scrollController != null && state.focusMessageID != null) {
        int index = state.messages.indexWhere((e) => e.id == state.focusMessageID);
        if (index != -1) {
          todoCubit.enableSelectionMode(state.messages[index], false);
          scrollController.scrollToIndex(
            index, duration: Duration(seconds: 1), preferPosition: AutoScrollPosition.middle
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }


  void handleScrollControllerChanges (ChatBloc chatBloc) {
    // MARK: - Pagination 
    if (!(chatBloc.state is ChatLoading)) {
      if (chatBloc.scrollController.isPaginated && !chatBloc.state.hasReachedMax) {
        if (chatBloc.scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          chatBloc.add(LoadMessages(
            isPagination: true,
            direction: RequestDirection.top
          ));
        }
      } else if (chatBloc.scrollController.isReverslyPaginated && !chatBloc.state.hasReachBottomMax) {
        if (chatBloc.scrollController.position.userScrollDirection == ScrollDirection.forward) { 
          chatBloc.add(LoadMessages(
            isPagination: true,
            direction: RequestDirection.bottom
          ));
        }
      }


      // Hide/Show Bottom Pin
      if (chatBloc.scrollController.offset > chatBloc.scrollController.position.viewportDimension * 2) {
        bool isBottomPinShown = chatBloc.state.unreadCount != null &&  chatBloc.state.unreadCount != 0
          && chatBloc.state.showBottomPin != null 
            && chatBloc.state.showBottomPin
              && !chatBloc.state.hasReachBottomMax;

        if (!isBottomPinShown) {
          chatBloc.add(ToggleBottomPin(show: true));
        }
      } else {
        var isShownBefore = 
          (chatBloc.state.unreadCount == null || chatBloc.state.unreadCount == 0)
            && (chatBloc.state.showBottomPin == null || chatBloc.state.showBottomPin) 
              && chatBloc.state.hasReachBottomMax;
        if (isShownBefore) {
            chatBloc.add(ToggleBottomPin(show: false));
        }
      }

      if (chatBloc.scrollController.offset < chatBloc.scrollController.position.viewportDimension * 0.5) {
        if (chatBloc.state.unreadCount != null) {
          chatBloc.add(ToggleBottomPin(show: false, newUnreadCount: 0));
        } 
      }
    }
  }

  Widget buildMessageCell ({
    @required int index, 
    @required ChatState state,
    @required ChatTodoState cubit,
    @required PanelBlocCubit panelBlocCubit,
    @required ChatTodoCubit chatTodoCubit,
    @required ChatBloc chatBloc
  }) {
    var spinnerIndex;
    if (state is ChatLoading) {
      spinnerIndex = state.direction == null || state.direction == RequestDirection.top ? 
        getItemsCount(state) - 1 : 0;
    }
    
    if (state is ChatLoading && spinnerIndex == index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: LoadWidget(size: 20)
      );
    } else if (getItemsCount(state) - 1 == index) {
      if (state.messages.getItemAt(index - 1) != null) {
        return ChatActionView(
          chatAction: TimeAction(
            action: ChatActions.newDay,
            dateTime: state.messages[index - 1].dateTime,
          ),
        );
      }

      return Container();
    } else {
      var indexMinus = 0;
      
      if (state is ChatLoading) {
        if (!(state.direction == null || state.direction == RequestDirection.top)) {
          indexMinus = 1;
        }
      }

      int currentIndex = index - indexMinus;
      int nextMessageUserID = state.messages.getItemAt(currentIndex - 1)?.user?.id;
      int prevMessageUserID = state.messages.getItemAt(currentIndex + 1)?.user?.id;
      Message currentMessage = state.messages[currentIndex];
      bool isSelected = false;
      
      if (cubit is ChatTodoSelection) {
        isSelected = cubit.selectedMessages
          .where((element) => element.id == currentMessage.id)
          .toList().length > 0;
      } 

      int myUserID = sl<AuthConfig>().user?.id;
      bool isTimeDeletionEnabled = (currentMessage.isRead || currentMessage.user?.id != myUserID) && 
        currentMessage.timeDeleted != null && 
          currentMessage.chatActions == null;
      print('isTimeDeletionEnabled: $isTimeDeletionEnabled');

      MessageCellParams messageCellParams ({int timeLeft}) => MessageCellParams(
        state: state, 
        nextMessageUserID: nextMessageUserID, 
        prevMessageUserID: prevMessageUserID, 
        chatTodoCubit: chatTodoCubit, 
        currentMessage: currentMessage, 
        cubit: cubit,
        panelBlocCubit: panelBlocCubit, 
        isSelected: isSelected,
        timeDeleted: timeLeft
      );

      return AutoScrollTag(
        key: ValueKey(index),
        controller: chatBloc.scrollController,
        index: index,
        child: isTimeDeletionEnabled ?
          BlocProvider(
            create: (context) => TimerCubit(currentMessage),
            child: BlocConsumer<TimerCubit, TimerState> (
              listener: (context, timerState) {
                if (timerState.timeLeft == null || timerState.timeLeft == 0) {
                  chatBloc.add(MessageDelete(ids: [currentMessage.id]));
                  context.read<main_chat_cubit.ChatGlobalCubit>().updateLastMessage(
                    widget.chatEntity.chatId, 
                    state.messages.getItemAt(currentIndex + 1)
                  );
                }
              },
              builder: (context, timerState) {
                return this._buildCellOfMessage(
                  params: messageCellParams(
                    timeLeft: timerState.timeLeft
                  ),
                  chatBloc: chatBloc
                );
              }, 
            )
          ) : currentMessage.chatActions == null ? 
            this._buildCellOfMessage(params: messageCellParams(), chatBloc: chatBloc) :
              ChatActionView(
                chatAction: buildChatAction(currentMessage)
              )
      );
    }
  }


  Widget _buildCellOfMessage ({
    @required MessageCellParams params,
    @required ChatBloc chatBloc
  }) {
    return MessageCell(
      isSwipeEnabled: params.state.chatEntity.permissions?.isForwardOn ?? true,
      nextMessageUserID: params.nextMessageUserID,
      prevMessageUserID: params.prevMessageUserID,
      onReply: (MessageViewModel message){
        params.panelBlocCubit.addMessage(message);
      },
      onAction: (MessageCellActions action){
        messageActionProcess(
          action, context, 
          MessageViewModel(params.currentMessage), 
          params.panelBlocCubit, params.chatTodoCubit
        );
      },
      messageViewModel: MessageViewModel(
        params.currentMessage,
        isSelected: params.isSelected,
        timeLeftToBeDeleted: params.timeDeleted
      ),
      onTap: () {
        if (params.cubit is ChatTodoSelection) {
          if (params.isSelected) {
            params.chatTodoCubit.removeMessage(params.currentMessage);
          } else {
            params.chatTodoCubit.selectMessage(params.currentMessage);
          }
        }
      },
      onClickForwardMessage: (int id) {
        chatBloc.add(LoadMessages(
          isPagination: false,
          direction: RequestDirection.bottom,
          messageID: id
        ));
      },
    );
  }
}



extension AutoScrollControllerReversedExtension on AutoScrollController {
  
  bool get isPaginated {
    var triggerFetchMoreSize = 0.7 * position.maxScrollExtent;
    return offset > triggerFetchMoreSize;
  }

  bool get isReverslyPaginated {
    return offset < 100;
  }
}


class MessageCellParams {
  final ChatState state;
  final int nextMessageUserID;
  final int prevMessageUserID;
  final ChatTodoCubit chatTodoCubit;
  final Message currentMessage;
  final ChatTodoState cubit;
  final PanelBlocCubit panelBlocCubit;
  final bool isSelected;
  final int timeDeleted;

  MessageCellParams({
    @required this.state,
    @required this.nextMessageUserID,
    @required this.prevMessageUserID,
    @required this.chatTodoCubit,
    @required this.currentMessage,
    @required this.cubit,
    @required this.panelBlocCubit,
    @required this.isSelected,
    @required this.timeDeleted
  });
}