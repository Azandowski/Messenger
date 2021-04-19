import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/widgets/independent/pickers/photo_picker.dart';
import '../../../../../../app/appTheme.dart';
import '../../../../../../core/services/network/Endpoints.dart';
import '../../../../../../core/utils/snackbar_util.dart';
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
            SnackUtil.showError(context: context, message: 'error'.tr());
          }
        },
        builder: (context, state) {
          var cubit = context.read<TypeNameCubit>();
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'almost_done'.tr(),
                  style: AppFontStyles.headingBlackStyle,
                ),
                SizedBox(
                  height: 24,
                ),
                Text('add_photo_and_name'.tr(),
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
                        FileImage(_image) : widget.user?.profileImage != null ? 
                          NetworkImage(widget.user?.profileImage) : null,
                      onSelectPhoto: () {
                        PhotoPicker().showImageSourceSelectionDialog(context,
                            (imageSource) {
                              context.read<TypeNameCubit>().getImage(imageSource);
                        });
                      },
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                OutlineTextField(
                    labelText: 'your_name'.tr(),
                    focusNode: focusNode,
                    textEditingController: cubit.nameCtrl,
                    width: width,
                    validator: (text){
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                    height: height),
                SizedBox(
                  height: height * 0.05,
                ),
                ActionButton(
                  isLoading: state is UpdatingUser,
                  text: 'continue'.tr(),
                  onTap: () {
                    if (!(state is UpdatingUser)) {
                      if(cubit.nameCtrl.text != null && cubit.nameCtrl.text != '')
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
