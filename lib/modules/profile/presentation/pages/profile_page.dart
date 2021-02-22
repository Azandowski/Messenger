import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/presentation/bloc/index.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/pages/edit_profile_page.dart';
import 'package:messenger_mobile/modules/profile/bloc/index.dart';
import 'package:messenger_mobile/modules/profile/bloc/profile_cubit.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_header.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_item.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_shimmer.dart';

class ProfilePage extends StatefulWidget {
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ProfileCubit cubit = sl<ProfileCubit>();

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
      body: BlocListener(
        cubit: cubit,
        listener: (context, state) {
          if (state is ProfileError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: TextStyle(
                  color: Colors.red
                )),
              ), // SnackBar
            );
          }
        },
        child: BlocProvider<ProfileCubit>(
          create: (_) => cubit..loadUser(LoadProfile(token: token)),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) { 
              if (profileState is ProfileLoading) {
                return ProfilePageShimmer();
              } else if (profileState is ProfileLoaded) {
                return Column(
                  children: [
                    ProfileHeader(
                      imageURL: profileState.user.profileImage,
                      name: profileState.user.name,
                      phoneNumber: profileState.user.phoneNumber,
                      onPress: () {
                        _handleEditScreenNavigation(context);
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
                        sl<AuthenticationBloc>().add(LoggedOut());
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
      )
    );
  }

  _handleEditScreenNavigation (BuildContext context) async {
    final needsUpdate = await Navigator.of(context).pushNamed(EditProfilePage.pageID);
    

    if (needsUpdate != null && needsUpdate) {
      BlocProvider.of<ProfileCubit>(context).loadUser(LoadProfile(token: sl<AuthConfig>().token));
    }
  }
}
