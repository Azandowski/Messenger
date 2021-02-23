import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_event.dart';
import 'package:messenger_mobile/modules/edit_profile/presentation/bloc/edit_profile_state.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditUser extends Mock implements EditUser {}

void main () { 
  EditProfileCubit cubit;
  MockEditUser mockEditUser;
  
  setUp(() { 
    mockEditUser = MockEditUser();
    cubit = EditProfileCubit(editUser: mockEditUser);
  });

  test('initialState should be Normal State', () {
    // assert
    expect(cubit.state, equals(EditProfileLoading()));
  });

  test ('should return error if there is an error', () {
    when(mockEditUser(any)).thenAnswer((_) async => Left(ServerFailure(message: 'ERROR')));

    // assert layer
    final expected = [ 
      EditProfileLoading(),
      EditProfileError(message: 'ERROR')
    ];

    cubit.updateProfile(EditProfileUpdateUser(token: ''));
  });

  test ('If success state becomes success', () {
    when(mockEditUser(any )).thenAnswer((_) async => Right(true));

    // assert layer
    final expected = [ 
      EditProfileLoading(),
      EditProfileSuccess()
    ];

    cubit.updateProfile(EditProfileUpdateUser(token: ''));
  }); 
}
