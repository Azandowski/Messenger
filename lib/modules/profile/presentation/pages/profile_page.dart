import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../locator.dart';
import '../../bloc/index.dart';
import '../../data/datasources/profile_datasource.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/usecases/get_user.dart';
import '../widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String token = sl<AuthConfig>().token;

    return Scaffold(
        appBar: AppBar(
          title: Text('Профиль'),
        ),
        body: BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
                  getUser: GetUser(ProfileRepositiryImpl(
                    profileDataSource: ProfileDataSourceImpl(),
                    networkInfo: sl<NetworkInfoImpl>(),
                  )),
                )..add(LoadProfile(token: token)),
            child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (_, profileState) {
              if (profileState is ProfileLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (profileState is ProfileLoaded) {
                return Container(
                  color: Colors.red,
                  child: ProfileHeader(
                    imageURL: profileState.user.profileImage,
                    name: profileState.user.name,
                    phoneNumber: profileState.user.phoneNumber,
                  ),
                );
              } else {
                return Container();
              }
            })));
  }
}
