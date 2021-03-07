import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/authorization/bloc/auth_bloc.dart';
import '../../../../core/blocs/category/bloc/category_bloc.dart';
import '../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../locator.dart';
import '../../../edit_profile/presentation/pages/edit_profile_page.dart';
import '../bloc/index.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_item.dart';
import '../widgets/profile_shimmer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileCubit cubit = sl<ProfileCubit>();

  Widget buildSeparator() {
    return SizedBox(
      height: 25,
      child: Container(
        color: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromRGBO(250, 249, 255, 1)),
      backgroundColor: Colors.grey[200],
      body: BlocListener(
          cubit: cubit,
          listener: (context, state) {
            if (state is ProfileError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message,
                      style: TextStyle(color: Colors.red)),
                ), // SnackBar
              );
            }
          },
          child: BlocProvider<ProfileCubit>(
            create: (_) => cubit,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return ProfilePageShimmer();
                } else {
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
                            isRed: false),
                      ),
                      buildSeparator(),
                      ProfileItem(
                        profileItemData: ProfileItemData(
                          icon: Icons.exit_to_app,
                          title: 'Выйти из аккаунта',
                          isRed: true,
                        ),
                        onTap: () {
                          context.read<AuthBloc>().add(
                            AuthenticationLogoutRequested(
                              categoryBloc: context.read<CategoryBloc>(), 
                              chatBloc: context.read<ChatGlobalCubit>()
                            )
                          );
                        },
                      ),
                    ],
                  );
                }
              }
            )
          )
        )
      );
  }

  _handleEditScreenNavigation(BuildContext context) async {
    var needsUpdate = await Navigator.of(context).push(EditProfilePage.route());
    if (needsUpdate != null && needsUpdate is bool && needsUpdate) {
      cubit.updateProfile();
    }
  }
}
