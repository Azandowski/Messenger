import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/category/bloc/category_bloc.dart';
import '../../../category/presentation/category_list/category_list.dart';
import '../bloc/cubit/chats_cubit_cubit.dart';
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
          categories: categoryState.categoryList,
          currentSelectedItemId: chatsState.currentTabIndex, 
          onNextClick: () {
            Navigator.pushNamed(context, CategoryList.id);
          },
          onItemSelect: (int id) {
            context.read<ChatsCubit>().tabUpdate(id);
          },
        );
      },
    );
  }
}