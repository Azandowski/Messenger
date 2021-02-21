import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/bloc/index.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/pages/edit_profile_page.dart';
import 'package:messenger_mobile/modules/profile/bloc/index.dart';
import 'package:messenger_mobile/modules/profile/data/datasources/profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/repositories/profile_repository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_header.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  
  Widget buildSeparator () {
    return SizedBox(
      height: 25,
      child: Container(color: Colors.grey[200],),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    String token = sl<AuthConfig>().token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль', 
          style: TextStyle(color: Colors.black)
        ),
        backgroundColor: Color.fromRGBO(250, 249, 255, 1)
      ),
      backgroundColor: Colors.grey[200],
      body: BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          getUser: GetUser(ProfileRepositoryImpl(
            profileDataSource: ProfileDataSourceImpl(
              client: sl<http.Client>()
            ), 
            networkInfo:  sl<NetworkInfoImpl>(),)
          ),
        )..add(LoadProfile(token: token)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) { 
            if (profileState is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (profileState is ProfileLoaded) {
              return Column(
                children: [
                  ProfileHeader(
                    imageURL: profileState.user.profileImage,
                    name: profileState.user.name,
                    phoneNumber: profileState.user.phoneNumber,
                    onPress: () {
                      Navigator.of(context).pushNamed(EditProfilePage.pageID);
                    },
                  ),
                  buildSeparator(),
                  ProfileItem(
                    profileItemData: ProfileItemData(
                      icon: Icons.info,
                      title: 'Политика конфиденциальности',
                      isRed: false
                    ),
                  ),
                  buildSeparator(),
                  ProfileItem(
                    profileItemData: ProfileItemData(
                      icon: Icons.exit_to_app,
                      title: 'Выйти из аккаунта',
                      isRed: true,
                    ),
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context, listen: false).add(LoggedOut());
                    },
                  ),
                ],
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
