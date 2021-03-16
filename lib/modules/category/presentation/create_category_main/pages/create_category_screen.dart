import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/application.dart';

import '../../../../../core/widgets/independent/buttons/bottom_action_button.dart';
import '../../../../../core/widgets/independent/pickers/photo_picker.dart';
import '../../../../../core/widgets/independent/small_widgets/chat_count_view.dart';
import '../../../../../locator.dart';
import '../../../../../main.dart';
import '../../../../chats/domain/entities/category.dart';
import '../../../data/models/chat_view_model.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/create_category_screen_params.dart';
import '../../category_list/category_list.dart';
import '../../chooseChats/presentation/chat_choose_page.dart';
import '../bloc/create_category_cubit.dart';
import '../widgets/chat_list.dart';
import '../widgets/create_category_header.dart';

class CreateCategoryScreen extends StatefulWidget {
  static final String id = 'create_category';

  final CreateCategoryScreenMode mode;
  final CategoryEntity entity;

  CreateCategoryScreen({
    this.mode = CreateCategoryScreenMode.create, 
    this.entity,
    Key key, 
  }) : super(key: key) {
    if (mode == CreateCategoryScreenMode.edit) {
      assert(entity != null, 'entity of edit model should not be null');
    }
  }

  static Route route({ CreateCategoryScreenMode mode, CategoryEntity category }) {
    return MaterialPageRoute<void>(builder: (_) => CreateCategoryScreen(
      mode: mode, entity: category,
    ));
  }

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

// * * State

class _CreateCategoryScreenState extends State<CreateCategoryScreen> implements ChatChooseDelegate {
  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  final CreateCategoryCubit cubit = sl<CreateCategoryCubit>();
  List<ChatViewModel> chats = [];

  _CreateCategoryScreenState();

  @override
  void initState() {
    super.initState();
    if (widget.mode == CreateCategoryScreenMode.edit) {
      cubit.prepareEditing(widget.entity);
    }
  }

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(color: Colors.red)),
              ), // SnackBar
            );
          } else if (state is CreateCategorySuccess) {
            Navigator.of(context).pop(state.updatedCategories);
          } else if (state is CreateCategoryNormal) {
            chats = (state.chats ?? []).map((e) => ChatViewModel(e)).toList();
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        CreateCategoryHeader(
                          nameController: cubit.nameController,
                          imageProvider: state.imageFile != null ? 
                            FileImage(state.imageFile) : cubit.defaultImageUrl != null ? 
                              NetworkImage(cubit.defaultImageUrl) : null,
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
                          title: 'Чаты: ${state is CreateCategoryChatsLoading ? "Загрузка ,,," : (chats ?? []).length }'
                        ),
                        ChatsList(
                          showSpinner: state is CreateCategoryChatsLoading,
                          isScrollable: false,
                          items: chats ?? [],
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
                ),
                BottomActionButtonContainer(
                  title: 'Сохранить',
                  isLoading: state is CreateCategoryLoading,
                  onTap: () {

                    // TODO: Put here Validation
                    cubit.sendData(widget.mode, widget.entity?.id ?? null);
                  },
                )
              ],
            ),
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