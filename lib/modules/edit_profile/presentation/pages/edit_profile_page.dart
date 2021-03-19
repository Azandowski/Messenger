import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/utils/snackbar_util.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../core/widgets/independent/pickers/photo_picker.dart';
import '../../../../core/widgets/independent/small_widgets/photo_picker_view.dart';
import '../../../../core/widgets/independent/textfields/customTextField.dart';
import '../../../../locator.dart';
import '../../../profile/domain/entities/user.dart';
import '../../../profile/domain/usecases/edit_user.dart';
import '../../data/datasources/edit_profile_datasource.dart';
import '../../data/repositories/edit_profile_repositories.dart';
import '../bloc/index.dart';

class EditProfilePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => EditProfilePage());
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  EditProfileCubit cubit;

  @override
  void initState() {
    _initCubit();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = sl<AuthConfig>().user;
    final String token = sl<AuthConfig>().token;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Редактировать",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color.fromRGBO(250, 249, 255, 1)),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          cubit: cubit..initProfile(EditProfileInit(user: user)),
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              Navigator.of(context).pop(true);
            } else if (state is EditProfileError) {
              SnackUtil.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    PhotoPickerView(
                      defaultPhotoProvider: cubit.imageFile != null ? 
                        FileImage(cubit.imageFile) : user?.profileImage != null ? NetworkImage(user?.profileImage) : null,
                      onSelectPhoto: () {
                        PhotoPicker().showImageSourceSelectionDialog(context,
                            (imageSource) {
                          cubit.pickProfileImage(PickProfileImage(imageSource: imageSource));
                        });
                      },
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 12),
                        color: Theme.of(context).backgroundColor,
                        child: Column(
                          children: [
                            IgnorePointer(
                              ignoring: state is EditProfileLoading,
                              child: CustomTextField(
                                customPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                labelText: "Фамилия",
                                textCtr: cubit.nameTextController,
                              ),
                            ),
                            IgnorePointer(
                              ignoring: state is EditProfileLoading,
                              child: CustomTextField(
                                customPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                labelText: "Имя",
                                textCtr: cubit.surnameTextController,
                              ),
                            ),
                            IgnorePointer(
                              ignoring: state is EditProfileLoading,
                              child: CustomTextField(
                                customPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                labelText: "Отчество",
                                textCtr: cubit.patronymTextController,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ActionButton(
                              isLoading: state is EditProfileLoading,
                              text: 'Сохранить',
                              onTap: () {
                                if (!(state is EditProfileLoading)) {
                                  cubit.updateProfile(EditProfileUpdateUser(
                                    token: token,
                                    image: cubit.imageFile,
                                    name: cubit.nameTextController.text,
                                    surname: cubit.surnameTextController.text,
                                    patronym: cubit.patronymTextController.text));
                                }
                              },
                            )
                          ],
                        )),
                  ]),
            );
          },
        ));
  }

  void _initCubit() {
    cubit = EditProfileCubit(
        getImageUseCase: sl(),
        editUser: EditUser(EditUserRepositoryImpl(
          editProfileDataSource: EditProfileDataSourceImpl(
              request: http.MultipartRequest(
                  'POST', Endpoints.updateCurrentUser.buildURL())),
          networkInfo: sl<NetworkInfo>(),
        )));
  }
}
