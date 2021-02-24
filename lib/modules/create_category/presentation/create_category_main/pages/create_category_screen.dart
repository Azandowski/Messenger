import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/pickers/photo_picker.dart';
import 'package:messenger_mobile/modules/create_category/data/datasources/create_category_datasource.dart';
import 'package:messenger_mobile/modules/create_category/data/repositories/create_category_repository.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/create_category.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/bloc/create_category_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/chat_item_view.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/create_category_header.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';

import '../../../../../locator.dart';
import 'package:messenger_mobile/modules/create_category/presentation/chooseChats/presentation/chat_choose_page.dart';

class CreateCategoryScreen extends StatelessWidget {
  static final String id = 'create_category';

  CreateCategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать категорию'),
      ),
      body: BlocConsumer<CreateCategoryCubit, CreateCategoryState>(
        cubit: createCubit()..initCubit(),
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Container(
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
                        ),
                        ChatCountView(
                          count: cubit.chatCounts
                        ),
                        ...cubit.chats.map((chat) => ChatItemView(
                          entity: chat, 
                          onSelectedOption: (option) {
                            // TODO: Implement Chat deletion and moving it 
                          }
                        )).toList()
                      ],
                    ),
                  ),
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, ChooseChatsPage.id);
      },),
    );
  }


  // * * Initialization of the cubit
  CreateCategoryCubit createCubit () {
    cubit = CreateCategoryCubit(
      createCategory: CreateCategoryUseCase(
       CreateCategoryRepositoryImpl(
         createCategoryDataSource: CreateCategoryDataSourceImpl(
           multipartRequest: http.MultipartRequest(
             'POST', Endpoints.createCategory.buildURL()
           )
          ), 
         networkInfo: sl<NetworkInfo>()) 
      ),
      getImageUseCase: sl<GetImage>()
    );

    return cubit;
  }
}