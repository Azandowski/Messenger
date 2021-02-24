import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/placeholders/load_widget.dart';
import 'package:messenger_mobile/modules/create_category/presentation/chooseChats/bloc/choosechats_bloc.dart';

class ChooseChatsPage extends StatelessWidget {
  static var id = 'dmasm';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseChatsBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Выбрано: 4'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                child: Text('Выберите те чаты, которые вы хотите добавить',style: AppFontStyles.greyPhoneStyle,),
              ),
            ),
            BlocConsumer<ChooseChatsBloc, ChooseChatsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ChooseChatsLoaded) {
                  return ChatsList(state: state,);
                } else if (state is ChooseChatLoading) {
                  return LoadWidget();
                } else {
                  return Text('default');
                }
              },
            )
          ],
        ),
      ),
    );
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
    return Expanded(
        child: ListView.separated(
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        var item = state.chatEntities[i];
        return ListTile(
          leading: FittedBox(
            fit: BoxFit.scaleDown,
            child: Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(item.imageUrl),minRadius: 30,),
                Positioned(bottom: 0, right: 0,
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
        );
      },
      itemCount: state.chatEntities.length,
    ));
  }
}
