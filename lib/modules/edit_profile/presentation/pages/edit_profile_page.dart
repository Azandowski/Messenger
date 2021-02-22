import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import 'package:messenger_mobile/core/widgets/independent/textfields/customTextField.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/edit_profile/bloc/index.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/data/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/widgets/user_picker_view.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  static final pageID = 'editProfilePage';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  EditProfileBloc provider;

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
        body: BlocProvider<EditProfileBloc>(
          create: (_) {
            provider = EditProfileBloc(
                editUser: EditUser(EditUserRepositoryImpl(
              editProfileDataSource: EditProfileDataSourceImpl(
                  request: http.MultipartRequest(
                      'POST', Endpoints.updateCurrentUser.buildURL())),
              networkInfo: sl<NetworkInfo>(),
            )));

            return provider;
          },
          child: BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
              if (state is EditProfileSuccess) {
                // Send Response: Needs Update
                Navigator.of(context).pop(true);
              }

              if (state is EditProfileNormal || state is EditProfileLoading) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 12),
                        UserPickerView(
                          context: context,
                          user: user,
                          imageFile: provider.imageFile,
                        ),
                        Container(
                            padding: const EdgeInsets.only(top: 12),
                            color: Theme.of(context).backgroundColor,
                            child: Column(
                              children: [
                                IgnorePointer(
                                  ignoring: state is EditProfileLoading,
                                  child: CustomTextField(
                                    customPadding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    labelText: "Фамилия",
                                    textCtr: provider.nameTextController,
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: state is EditProfileLoading,
                                  child: CustomTextField(
                                    customPadding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    labelText: "Имя",
                                    textCtr: provider.surnameTextController,
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: state is EditProfileLoading,
                                  child: CustomTextField(
                                    customPadding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    labelText: "Отчество",
                                    textCtr: provider.patronymTextController,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                ActionButton(
                                  isLoading: state is EditProfileLoading,
                                  text: 'Сохранить',
                                  onTap: () {
                                    if (state is EditProfileNormal) {
                                      provider.add(EditProfileUpdateUser(
                                          token: token,
                                          image: provider.imageFile,
                                          name:
                                              provider.nameTextController.text,
                                          surname: provider
                                              .surnameTextController.text,
                                          patronym: provider
                                              .patronymTextController.text));
                                    }
                                  },
                                )
                              ],
                            )),
                      ]),
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}
