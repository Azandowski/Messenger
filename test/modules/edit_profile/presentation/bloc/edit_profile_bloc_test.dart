import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_event.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_state.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditUser extends Mock implements EditUser {}

class MockGetImage extends Mock implements GetImage {}

void main() {
  EditProfileCubit cubit;
  MockEditUser mockEditUser;
  MockGetImage mockGetImage;

  setUp(() {
    mockEditUser = MockEditUser();
    mockGetImage = MockGetImage();
    cubit = EditProfileCubit(
      editUser: mockEditUser,
      getImageUseCase: mockGetImage,
    );
  });

  test('initialState should be EditProfileLoading', () {
    // assert
    expect(cubit.state, equals(EditProfileLoading()));
  });

  group('updateProfile', () {
    final event = EditProfileUpdateUser(token: 'token');

    blocTest(
      'Should emit [EditProfileSuccess] on success',
      build: () => cubit,
      act: (EditProfileCubit editProfileCubit) {
        when(mockEditUser(any)).thenAnswer((_) async => Right(true));

        editProfileCubit.updateProfile(event);
      },
      expect: [
        isA<EditProfileLoading>(),
        isA<EditProfileSuccess>(),
      ],
    );

    blocTest(
      'Should emit [EditProfileError] on any Failure',
      build: () => cubit,
      act: (EditProfileCubit editProfileCubit) {
        when(mockEditUser(any))
            .thenAnswer((_) async => Left(ConnectionFailure()));

        editProfileCubit.updateProfile(event);
      },
      expect: [
        isA<EditProfileLoading>(),
        isA<EditProfileError>(),
      ],
    );
  });

  group('pickProfileImage', () {
    final event = PickProfileImage(imageSource: ImageSource.gallery);

    blocTest(
      'Should emit [EditProfileNormal] on success',
      build: () => cubit,
      act: (EditProfileCubit editProfileCubit) {
        when(mockGetImage(any))
            .thenAnswer((_) async => Right(File('image.jpg')));

        editProfileCubit.pickProfileImage(event);
      },
      expect: [
        isA<EditProfileNormal>(),
      ],
    );

    blocTest(
      'Should emit [EditProfileError] on any Failure',
      build: () => cubit,
      act: (EditProfileCubit editProfileCubit) {
        when(mockGetImage(any))
            .thenAnswer((_) async => Left(ConnectionFailure()));

        editProfileCubit.pickProfileImage(event);
      },
      expect: [
        isA<EditProfileError>(),
      ],
    );
  });
}
