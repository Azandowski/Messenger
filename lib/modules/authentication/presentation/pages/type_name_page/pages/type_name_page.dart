import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import 'package:messenger_mobile/core/widgets/independent/textfields/outlineTextField.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_name_page/cubit/typename_cubit.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_phone_page/cubit/typephone_cubit.dart';
import 'package:messenger_mobile/modules/authentication/presentation/widgets/offertText.dart';

class TypeNamePage extends StatefulWidget {
  @override
  _TypeNamePageState createState() => _TypeNamePageState();
}

class _TypeNamePageState extends State<TypeNamePage> {
  TextEditingController _nameCtrl = TextEditingController();

  FocusNode focusNode = FocusNode();

  bool isFocused = false;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        isFocused = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildBody(context),
      ))),
    );
  }

  buildBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TypeNameCubit(),
      child: BlocConsumer<TypeNameCubit, TypeNameState>(
        listener: (context, state) {
          if (state is InvalidPhone) {
            _nameCtrl.clear();
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('ads')),
              );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Почти готово!',
                  style: AppFontStyles.headingBlackStyle,
                ),
                Text('Добавьте фото и укажите свое имя',
                    style: AppFontStyles.paleHeading),
                SizedBox(
                  height: height * 0.05,
                ),
                OutlineTextField(
                    focusNode: focusNode,
                    textEditingController: _nameCtrl,
                    width: width,
                    height: height),
                OffertTextWidget(),
                ActionButton(
                  isLoading: state is SendingPhone,
                  text: 'Продолжить',
                  onTap: () {
                    context.read<TypephoneCubit>().sendPhone(_nameCtrl.text);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
