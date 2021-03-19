import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/utils/snackbar_util.dart';

import '../../../../../../app/appTheme.dart';
import '../../../../../../core/services/network/Endpoints.dart';
import '../../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../../core/widgets/independent/small_widgets/photo_picker_view.dart';
import '../../../../../../core/widgets/independent/textfields/outlineTextField.dart';
import '../../../../../../locator.dart';
import '../../../../../edit_profile/data/datasources/edit_profile_datasource.dart';
import '../../../../../edit_profile/data/repositories/edit_profile_repositories.dart';
import '../../../../../profile/domain/entities/user.dart';
import '../../../../../profile/domain/usecases/edit_user.dart';
import '../cubit/typename_cubit.dart';

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
            SnackUtil.showError(context: context, message: 'Ошибка');
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
                    style: AppFontStyles.placeholderMedium),
                SizedBox(
                  height: 24,
                ),
                BlocBuilder<TypeNameCubit, TypeNameState>(
                  builder: (context, state) {
                    if (state is FileSelected) {
                      _image = state.imageFile;
                    }

                    return PhotoPickerView(
                      defaultPhotoProvider: _image != null ? 
                        FileImage(_image) : widget.user?.profileImage != null ? NetworkImage(widget.user?.profileImage) : null,
                      onSelectPhoto: () {
                        context.read<TypeNameCubit>().getImage(ImageSource.camera);
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
