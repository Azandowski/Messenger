import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/edit_profile/bloc/index.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/data/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatelessWidget {
  
  static final pageID = 'editProfilePage';

  @override
  Widget build(BuildContext context) {
    final User user = sl<AuthConfig>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Редактировать",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(250, 249, 255, 1)
      ),
      body: BlocProvider<EditProfileBloc>(
        create: (_) => EditProfileBloc(
          editUser: EditUser(EditUserRepositoryImpl(
            editProfileDataSource: EditProfileDataSourceImpl(
              request: http.MultipartRequest('POST', Endpoints.updateCurrentUser.buildURL())
            ),
            networkInfo:  sl<NetworkInfoImpl>(),)
          )
        ),
        child: BlocBuilder<EditProfileBloc, EditProfileState> (
          builder: (_, state) {
            if (state is EditProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EditProfileNormal || state is EditProfileSuccess) {
              if (state is EditProfileSuccess) {
                Navigator.of(context).pop();
              }

              return Container(
                height: 400,
                color: Colors.red
              );
            } 
          },
        ),
      )
    );
  }
}