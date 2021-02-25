import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/appTheme.dart';
import '../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../core/widgets/independent/placeholders/load_widget.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../widgets/chat_list.dart';
import '../bloc/choosechats_bloc.dart';

abstract class ChatChooseDeleagete{
  void didSaveChats(List<ChatEntity> chats);
}

class ChooseChatsPage extends StatelessWidget {

  static Route route(ChatChooseDeleagete deleagete) {
    return MaterialPageRoute<void>(builder: (_) => ChooseChatsPage(deleagete: deleagete,));
  }

  final ChatChooseDeleagete deleagete;
  
  int _items = 0;

  ChooseChatsPage({Key key,@required this.deleagete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseChatsBloc(),
      child: BlocConsumer<ChooseChatsBloc, ChooseChatsState>(
        listener: (context, state) {
          if(state is ChooseChatsLoaded){
          _items = state.chatEntities.where((element) => element.selected).toList().length;
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Выбрано: ${_items}'),
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Container(
                          child: Text('Выберите те чаты, которые вы хотите добавить',style: AppFontStyles.greyPhoneStyle,),
                        ),
                      ),
                      returnStateWidget(state,context),
                    ],
            ),
                if(state is ChooseChatsLoaded)  Positioned(
                    bottom: 40,
                    child: ActionButton(text: 'Добавить чаты', onTap: (){
                      var selectedChats = state.chatEntities.where((element) => element.selected).toList();
                      deleagete.didSaveChats(selectedChats);
                      Navigator.pop(context);
                    }),
                  ),
                ],
              )
         );
       }
      ),
    );
  }

  Widget returnStateWidget(state, context){
    if (state is ChooseChatsLoaded) {
        return ChatsList(items: state.chatEntities,cellType: ChatCellType.add,
        onSelect: (chatEntity){
          BlocProvider.of<ChooseChatsBloc>(context).add(ChatChosen(chatEntity.copyWith(selected: !chatEntity.selected)));
        },
        );
    } else if (state is ChooseChatLoading) {
        return LoadWidget();
    } else {
        return Text('default');
    }
  }
}

