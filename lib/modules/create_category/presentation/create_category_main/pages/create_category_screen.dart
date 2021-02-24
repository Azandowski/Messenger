import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/modules/create_category/data/datasources/create_category_datasource.dart';
import 'package:messenger_mobile/modules/create_category/data/repositories/create_category_repository.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/create_category.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/bloc/create_category_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/create_category/presentation/create_category_main/widgets/create_category_header.dart';

import '../../../../../locator.dart';

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
                content:
                    Text(state.message, style: TextStyle(color: Colors.red)),
              ), // SnackBar
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      CreateCategoryHeader(
                        imageProvider: null,
                        selectImage: (file) {
                          
                        },
                      ),
                      ChatCountView(
                        count: cubit.chatCounts
                      )
                    ],
                  ),
                ),
              ),
              BottomActionButtonContainer(
                title: 'Сохранить',
                onTap: () {

                },
              )
            ],
          );
        },
      ),
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
      )
    );

    return cubit;
  }
}