import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/pickers/photo_picker.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/bloc/create_category_cubit.dart';

import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/chat_list.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/create_category_header.dart';
import '../../../../../locator.dart';
import '../../../../../main.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../chooseChats/presentation/chat_choose_page.dart';
import '../bloc/create_category_cubit.dart';
import '../widgets/create_category_header.dart';

class CreateCategoryScreen extends StatelessWidget implements ChatChooseDelegate {
  static final String id = 'create_category';
  NavigatorState get _navigator => navigatorKey.currentState;
  final CreateCategoryCubit cubit = sl<CreateCategoryCubit>();

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
                      imageProvider: cubit.imageFile != null ? 
                        FileImage(cubit.imageFile) : null,
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
                    ChatCountView(
                      count: cubit.chats.length
                    ),
                    ChatsList(
                      items: cubit.chats,
                      cellType: ChatCellType.optionsWithChat,
                      onSelectedOption: (ChatCellActionType action, ChatEntity entity) {
                        if (action == ChatCellActionType.delete) {
                          cubit.deleteChat(entity);
                        } else {
                          // TODO: Implement moving chat
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



  // ! Test memory usage 
  // * * Initialization of the cubit
  // CreateCategoryCubit createCubit () {
  //   cubit = CreateCategoryCubit(
  //     createCategory: CreateCategoryUseCase(
  //      CreateCategoryRepositoryImpl(
  //        createCategoryDataSource: CreateCategoryDataSourceImpl(
  //          multipartRequest: http.MultipartRequest(
  //            'POST', Endpoints.createCategory.buildURL()
  //          )
  //         ), 
  //        networkInfo: sl<NetworkInfo>()) 
  //     ),
  //     getImageUseCase: sl<GetImage>()
  //   );

  //   return cubit;
  // }

  @override
  void didSaveChats(List<ChatEntity> chats) {
    cubit.addChats(chats);
  }
}