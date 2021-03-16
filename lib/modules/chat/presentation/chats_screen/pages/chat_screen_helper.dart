import 'package:flutter/rendering.dart';
import 'package:messenger_mobile/modules/category/presentation/chooseChats/presentation/chat_choose_page.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/remove_dialog_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart' as main_chat_cubit;

extension ChatScreenStateHelper on ChatScreenState {

  // Get App Bar
  PreferredSizeWidget buildAppBar (
    ChatTodoCubit chatTodoCubit,
    ChatTodoState state,
    ChatViewModel chatViewModel,
    NavigatorState navigator
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
    ChatTodoState state, ChatTodoCubit chatTodoCubit,
    double width, double height
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
        height: height
      );
    }
  }

  Widget buildTopMessage (ChatState state,
    double width, double height, ChatTodoCubit cubit){
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
          )
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(state.message)),
        );
    } else if (state is ChatLoadingSilently) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: LinearProgressIndicator(), 
          duration: Duration(days: 2),
        ));
    } else if (state is ChatInitial) {
      // Update Notification Badge

      var chatGlobalCubit = context.read<main_chat_cubit.ChatGlobalCubit>();
      var globalIndexOfChat = chatGlobalCubit.state.chats.indexWhere((e) => e.chatId == widget.chatEntity.chatId);

      if (globalIndexOfChat != -1) {
        if (chatGlobalCubit.state.chats[globalIndexOfChat].unreadCount != 0) {
          context.read<main_chat_cubit.ChatGlobalCubit>().resetChatNoReadCounts(chatId: widget.chatEntity.chatId);
          if (widget.chatEntity.chatCategory?.id != null) {

            int index = categoryBloc.state.categoryList.indexWhere((e) => e.id == widget.chatEntity.chatCategory?.id);

            categoryBloc.add(CategoryReadCountChanged(
              categoryID: widget.chatEntity.chatCategory?.id,
              newReadCount: categoryBloc.state.categoryList[index].noReadCount - 1
            ));
          }
        }
      }

      if (scrollController != null && state.focusMessageID != null) {
        int index = state.messages.indexWhere((e) => e.id == state.focusMessageID);
        if (index != -1) {
          todoCubit.enableSelectionMode(state.messages[index], false);
          scrollController.scrollToIndex(
            index, duration: Duration(seconds: 2), preferPosition: AutoScrollPosition.middle
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