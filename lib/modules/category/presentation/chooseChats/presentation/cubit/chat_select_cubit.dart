import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';

part 'chat_select_state.dart';

class ChatSelectCubit extends Cubit<ChatSelectState> {
  ChatSelectCubit() : super(ChatSelectInitial(selectedChats: []));

  addChat(ChatViewModel chatViewModel){
    var list = getCopyChats();
    if(!chatViewModel.isSelected){
     list.add(chatViewModel.entity);
     emit(ChatSelectInitial(selectedChats: list));
    }else{
      list.removeWhere((e) => e.chatId == chatViewModel.entity.chatId);
      emit(ChatSelectInitial(selectedChats: list));
    }
  }

  List<ChatEntity> getCopyChats() => state.selectedChats.map((e) => e.clone()).toList();
}
