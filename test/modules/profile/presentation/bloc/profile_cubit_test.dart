import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_current_user.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/set_wallpaper.dart';
import 'package:messenger_mobile/modules/profile/presentation/bloc/index.dart';
import 'package:mockito/mockito.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockAuthConfig extends Mock implements AuthConfig {}

class MockSetWallpaper extends Mock implements SetWallpaper {}

void main() {
  User tUser;
  ProfileCubit cubit;
  MockGetCurrentUser mockGetCurrentUser;
  MockAuthConfig mockAuthConfig;
  MockSetWallpaper mockSetWallpaper;

  setUp(() {
    tUser = User(
      id: 1,
      name: 'Name',
      surname: 'Surname',
      patronym: 'Patronym',
      phoneNumber: '+77777777777',
      profileImage: 'image',
      status: 'status',
    );

    mockSetWallpaper = MockSetWallpaper();
    mockGetCurrentUser = MockGetCurrentUser();
    mockAuthConfig = MockAuthConfig();
    cubit = ProfileCubit(
      getUser: mockGetCurrentUser,
      setWallpaper: mockSetWallpaper,
      authConfig: mockAuthConfig,
    );
  });

  test('initial state should be ProfileLoaded', () {
    expect(cubit.state, isA<ProfileLoaded>());
  });

  blocTest('shoud emit [ProfileLoading, ProfileLoaded] if everything is OK',
      build: () => cubit,
      act: (ProfileCubit profilecubit) {
        when(mockGetCurrentUser(any)).thenAnswer((_) async => Right(tUser));
        profilecubit.updateProfile();
      },
      expect: () => [
            isA<ProfileLoading>(),
            isA<ProfileLoaded>(),
          ]);

  blocTest('shoud emit [ProfileLoading, ProfileError] if there is an error',
      build: () => cubit,
      act: (ProfileCubit profilecubit) {
        when(mockAuthConfig.token).thenReturn('test');
        when(mockGetCurrentUser(any)).thenAnswer((_) async =>
            Left(ServerFailure(message: FailureMessages.noConnection)));
        profilecubit.updateProfile();
      },
      expect: () => [
            isA<ProfileLoading>(),
            isA<ProfileError>(),
          ]);
}
