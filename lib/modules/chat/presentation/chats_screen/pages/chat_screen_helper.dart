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
      delegate: this,
      chatTodoCubit: chatTodoCubit,
      appBar: AppBar(),
    ) : ChatAppBar(
      chatViewModel: chatViewModel, 
      navigator: navigator, 
      widget: widget, 
      delegate: this,
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
        // TODO: Handle this case.
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
    {AutoScrollController scrollController}
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
        int index = state.messages.indexWhere((e) => e.id == 597);
        if (index != -1) {
          scrollController.scrollToIndex(index);
        }
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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