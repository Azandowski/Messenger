import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/placeholders/load_widget.dart';
import 'package:messenger_mobile/modules/create_category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/create_category/presentation/chooseChats/bloc/choosechats_bloc.dart';

class ChooseChatsPage extends StatefulWidget {
  static var id = 'dmasm';

  @override
  _ChooseChatsPageState createState() => _ChooseChatsPageState();
}

class _ChooseChatsPageState extends State<ChooseChatsPage> {
  int _items = 0;
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
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Container(
                      child: Text('Выберите те чаты, которые вы хотите добавить',style: AppFontStyles.greyPhoneStyle,),
                    ),
                  ),
                  returnStateWidget(state),

                ],
            )
         );
       }
      ),
    );
  }

  Widget returnStateWidget(state){
    if (state is ChooseChatsLoaded) {
                        return ChatsList(state: state,);
                      } else if (state is ChooseChatLoading) {
                        return LoadWidget();
                      } else {
                        return Text('default');
                   }
  }
}

class ChatsList extends StatelessWidget {
  final ChooseChatsLoaded state;

  const ChatsList({
    @required this.state,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
      itemBuilder: (context, i) {
        ChatEntity item = state.chatEntities[i];
        return Container(
          color: item.selected ?  AppColors.lightPinkColor : Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
            leading: FittedBox(
              fit: BoxFit.scaleDown,
              child: Stack(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(item.imageUrl),minRadius: 30,),
                  if(item.selected) Positioned(bottom: 0, right: 0,
                   child: ClipOval(
                     child: Container(
                       color: AppColors.successGreenColor,
                     child: Icon(Icons.done,color: Colors.white,)
                     ),
                     ),
                     )
                ],
              ),
            ),
            title: Text(state.chatEntities[i].title, style: AppFontStyles.mainStyle,),
            onTap: (){
                  BlocProvider.of<ChooseChatsBloc>(context).add(ChatChosen(item.copyWith(selected: !item.selected)));
            },
          ),
        );
      },
      itemCount: state.chatEntities.length,
    ));
  }
}
