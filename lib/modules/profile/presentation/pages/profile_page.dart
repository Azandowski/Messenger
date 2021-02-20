import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/bloc/index.dart';
import 'package:messenger_mobile/modules/profile/data/datasources/profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/repositories/profile_repository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_header.dart';

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
          getUser: GetUser(ProfileRepositoryImpl(
            profileDataSource: ProfileDataSourceImpl(), 
            networkInfo:  sl<NetworkInfoImpl>(),)
          ),
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
          }
        )
      )
    );
  }
}