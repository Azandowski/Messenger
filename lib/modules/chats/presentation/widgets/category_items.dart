import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';

import '../../../../app/appTheme.dart';
import '../../domain/entities/category.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;
  final Function onNextClick;

<<<<<<< HEAD
  const CategoriesSection(
      {@required this.categories,
      @required this.currentSelectedItemId,
      Key key})
      : super(key: key);
=======
  const CategoriesSection({
    @required this.categories,
    @required this.currentSelectedItemId,
    @required this.onNextClick,
    Key key
  }) : super(key: key);
>>>>>>> ecd24ebe470adc8a338b668b973c1237c0901218

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Категории чатов', style: AppFontStyles.headingTextSyle),
            GestureDetector(
              child: Icon(Icons.chevron_right),
              onTap: onNextClick,
            )
          ]),
          SizedBox(
            height: 15,
          ),
          CategoryItemsScroll(
            categories: categories,
            currentSelectedItemId: currentSelectedItemId,
          )
        ],
      ),
    );
  }
}

class CategoryItemsScroll extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int currentSelectedItemId;

  const CategoryItemsScroll({
    @required this.categories,
    @required this.currentSelectedItemId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CategoryItem(
                      entity: e,
                      isSelected: currentSelectedItemId == e.id,
                      onSelect: () {
                        BlocProvider.of<ChatsCubit>(context).tabUpdate(e.id);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
