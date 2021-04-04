import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/config/language.dart';
import '../../../../core/blocs/authorization/bloc/auth_bloc.dart';
import '../../../../core/blocs/category/bloc/category_bloc.dart';
import '../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../locator.dart';
import '../../../creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
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
    print(context.locale);
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr(), 
        style: TextStyle(color: Colors.black)
      ),
      backgroundColor: Color.fromRGBO(250, 249, 255, 1)),
      backgroundColor: Colors.grey[200],
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is ProfileError) {
            SnackUtil.showError(context: context, message: state.message);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                          title: 'privacy_policy'.tr(),
                          isRed: false),
                    ),
                    ProfileItem(
                      profileItemData: ProfileItemData(
                        icon: Icons.wallpaper,
                        title: 'wallpaper'.tr(),
                        isRed: false,
                      ),
                      onTap: () async {
                        final PickedFile image = await ImagePicker().getImage(
                          source: ImageSource.gallery
                        );
                        
                        final file = File(image.path);
                        cubit.setWallpaperFile(file);
                      }
                    ),
                    DropdownButton<ApplicationLanguage>(
                      value: sl<Application>().appLanguage,
                      items: ApplicationLanguage.values.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name)
                        )
                      ).toList(),
                      onChanged: (newLang) {
                        EasyLocalization.of(context).setLocale(newLang.localeCode);
                        // context.locale = newLang.localeCode;
                        sl<Application>().changeAppLanguage(newLang.localeCode);
                      },
                    ),
                    buildSeparator(),
                    ProfileItem(
                      profileItemData: ProfileItemData(
                        icon: Icons.exit_to_app,
                        title: 'logout_from_account'.tr(),
                        isRed: true,
                      ),
                      onTap: () {
                        context.read<AuthBloc>().add(
                          AuthenticationLogoutRequested(
                            categoryBloc: context.read<CategoryBloc>(), 
                            chatBloc: context.read<ChatGlobalCubit>(),
                            contactBloc: context.read<ContactBloc>()
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
