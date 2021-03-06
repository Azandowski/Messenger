import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/appTheme.dart';
import '../../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../../core/widgets/independent/textfields/outlineTextField.dart';
import '../../../bloc/authentication_bloc.dart';
import '../../../bloc/index.dart';
import '../../../widgets/offertText.dart';
import '../cubit/typephone_cubit.dart';

class TypePhonePage extends StatefulWidget {
  @override
  _TypePhonePageState createState() => _TypePhonePageState();
}

class _TypePhonePageState extends State<TypePhonePage> {
  TextEditingController _phoneCtrl = TextEditingController();

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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocConsumer<TypephoneCubit, TypephoneState>(
      listener: (context, state) {
        if (state is InvalidPhone) {
          _phoneCtrl.clear();
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        } else if (state is Success) {
          context
              .read<AuthenticationBloc>()
              .add(GoToCodePage(codeEntity: state.codeEntity));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Введите номер телефона',
                style: AppFontStyles.headingBlackStyle,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              OutlineTextField(
                  labelText: 'Номер телефона',
                  prefixText: '+',
                  focusNode: focusNode,
                  textInputType: TextInputType.phone,
                  textEditingController: _phoneCtrl,
                  width: width,
                  height: height),
              OffertTextWidget(),
              ActionButton(
                isLoading: state is SendingPhone,
                text: 'Продолжить',
                onTap: () {
                  context.read<TypephoneCubit>().sendPhone(_phoneCtrl.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
