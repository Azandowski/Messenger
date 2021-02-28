import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/pickers/photo_picker.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/category_list.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/widgets/chat_list.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import '../../../../../locator.dart';
import '../../../../../main.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../chooseChats/presentation/chat_choose_page.dart';
import '../bloc/create_category_cubit.dart';
import '../widgets/create_category_header.dart';

class CreateCategoryScreen extends StatefulWidget {
  static final String id = 'create_category';

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> implements ChatChooseDelegate {
  NavigatorState get _navigator => navigatorKey.currentState;
  final CreateCategoryCubit cubit = sl<CreateCategoryCubit>();
  List<ChatViewModel> chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать категорию'),
      ),
      body: BlocConsumer<CreateCategoryCubit, CreateCategoryState>(
        cubit: cubit,
        listener: (context, state) {
          if (state is CreateCategoryError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(color: Colors.red)),
              ), // SnackBar
            );
          } else if (state is CreateCategorySuccess) {
            Navigator.of(context).pop(state.updatedCategories);
          } else if (state is CreateCategoryNormal) {
            chats = state.chats.map((e) => ChatViewModel(e)).toList();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    CreateCategoryHeader(
                      nameController: cubit.nameController,
                      imageProvider: state.imageFile != null ? 
                        FileImage(state.imageFile) : null,
                      selectImage: (file) {
                        PhotoPicker().showImageSourceSelectionDialog(context,
                          (imageSource) {
                            cubit.selectPhoto(imageSource);
                          });
                      },
                      onAddChats: () {
                        _navigator.push(ChooseChatsPage.route(this));
                      } 
                    ),
                    CellHeaderView(
                      title: 'Чаты: ${chats.length}'
                    ),
                    ChatsList(
                      items: chats,
                      loadingItemsIDS: state is CreateCategoryTransferLoading ? 
                        state.chatsIDs : [],
                      cellType: ChatCellType.optionsWithChat,
                      onSelectedOption: (ChatCellActionType action, ChatEntity entity) async {
                        if (action == ChatCellActionType.delete) {
                          cubit.deleteChat(entity);
                        } else {
                          var response = await _navigator.push(CategoryList.route(isMoveChat: true));

                          if (response is CategoryEntity) {
                            cubit.movingChats = [entity.chatId];
                            cubit.doTransferChats(response.id);
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
              BottomActionButtonContainer(
                title: 'Сохранить',
                isLoading: state is CreateCategoryLoading,
                onTap: () {
                  // TODO: Put here Validation
                  cubit.sendData();
                },
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void didSaveChats(List<ChatEntity> chats) {
    cubit.addChats(chats);
  }
}