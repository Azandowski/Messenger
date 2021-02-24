import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../locator.dart';
import '../../../../../main.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../chooseChats/presentation/chat_choose_page.dart';
import '../../widgets/chat_list.dart';
import '../bloc/create_category_cubit.dart';
import '../widgets/chat_count_view.dart';
import '../widgets/create_category_header.dart';

class CreateCategoryScreen extends StatelessWidget implements ChatChooseDeleagete {
  static final String id = 'create_category';

  NavigatorState get _navigator => navigatorKey.currentState;

  CreateCategoryCubit cubit = sl<CreateCategoryCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать категорию'),
      ),
      body: BlocProvider.value(
        value: cubit,
        child: BlocConsumer<CreateCategoryCubit, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategoryError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(state.message, style: TextStyle(color: Colors.red)),
                    ), // SnackBar
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 30),
                        CreateCategoryHeader(
                          imageProvider: null,
                          selectImage: (file) {
                            
                          },
                          onAddChats: (){
                            _navigator.push(ChooseChatsPage.route(this));
                          }     
                        ),
                        ChatCountView(
                          count: cubit.chatCounts
                        ),
                        if(state is CreateCategoryNormal) ChatsList(
                          cellType: ChatCellType.delete,
                          items: state.chats,
                          onDelete: (chatEntity){
                            cubit.deleteChat(chatEntity);
                          },
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 30,
                        child: ActionButton(
                        text: 'Сохранить',
                        onTap: () {
      
                        },
                      ),
                    )
                  ],
                );
              },
            ),
      ),
    );
  }

  @override
  void didSaveChats(List<ChatEntity> chats) {
    cubit.addChats(chats);
  }
}