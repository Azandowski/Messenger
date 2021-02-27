import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/category/bloc/category_bloc.dart';
import 'package:messenger_mobile/modules/category/presentation/category_list/category_list.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/pages/create_category_screen.dart';
import 'package:messenger_mobile/modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';

import 'category_items.dart';

class ChatScreenCategoriesView extends StatelessWidget {
  
  final ChatsCubitState chatsState;

  const ChatScreenCategoriesView({
    @required this.chatsState,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, categoryState) {
        return CategoriesSection(
          isLoading: categoryState is CategoryEmpty,
          categories: categoryState is CategoryLoaded ? categoryState.categoryList : [],
          currentSelectedItemId: chatsState.currentTabIndex, 
          onNextClick: () {
            Navigator.pushNamed(context, CategoryList.id);
            // Navigator.pushNamed(context, CreateCategoryScreen.id);
          },
          onItemSelect: (int id) {
            context.read<ChatsCubit>().tabUpdate(id);
          },
        );
      },
    );
  }
}