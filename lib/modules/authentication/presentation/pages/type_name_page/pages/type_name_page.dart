import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import 'package:messenger_mobile/core/widgets/independent/textfields/outlineTextField.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_name_page/cubit/typename_cubit.dart';
import 'package:messenger_mobile/modules/authentication/presentation/pages/type_phone_page/cubit/typephone_cubit.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/data/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/widgets/user_picker_view.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';

class TypeNamePage extends StatefulWidget {
  final User user;

  const TypeNamePage({Key key, @required this.user}) : super(key: key);

  @override
  _TypeNamePageState createState() => _TypeNamePageState();
}

class _TypeNamePageState extends State<TypeNamePage> {
  FocusNode focusNode = FocusNode();

  bool isFocused = false;

  File _imageFile;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        isFocused = true;
      });
    });
    super.initState();
  }

  File _image;

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
      create: (context) => TypeNameCubit(
          getImageUseCase: sl(),
          getCurrenUserUseCase: sl(),
          editUserUseCase: EditUser(EditUserRepositoryImpl(
            editProfileDataSource: EditProfileDataSourceImpl(
                request: http.MultipartRequest(
                    'POST', Endpoints.updateCurrentUser.buildURL())),
            networkInfo: sl(),
          ))),
      child: BlocConsumer<TypeNameCubit, TypeNameState>(
        listener: (context, state) {
          if (state is ErrorUploading) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Error')),
              );
          }
        },
        builder: (context, state) {
          var cubit = context.read<TypeNameCubit>();
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Почти готово!',
                  style: AppFontStyles.headingBlackStyle,
                ),
                SizedBox(
                  height: 24,
                ),
                Text('Добавьте фото и укажите свое имя',
                    style: AppFontStyles.paleHeading),
                SizedBox(
                  height: 24,
                ),
                BlocBuilder<TypeNameCubit, TypeNameState>(
                  builder: (context, state) {
                    if (state is FileSelected) {
                      _image = state.imageFile;
                    }
                    return UserPickerView(
                      context: context,
                      user: widget.user,
                      imageFile: _image,
                      onSelectPhoto: () {
                        context
                            .read<TypeNameCubit>()
                            .getImage(ImageSource.camera);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                OutlineTextField(
                    labelText: 'Ваше имя',
                    focusNode: focusNode,
                    textEditingController: cubit.nameCtrl,
                    width: width,
                    height: height),
                SizedBox(
                  height: height * 0.05,
                ),
                ActionButton(
                  isLoading: state is UpdatingUser,
                  text: 'Продолжить',
                  onTap: () {
                    if (!(state is UpdatingUser)) {
                      cubit.updateProfile(_image);
                    }
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
