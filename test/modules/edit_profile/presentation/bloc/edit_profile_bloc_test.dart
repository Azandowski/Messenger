import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/edit_profile/bloc/index.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditUser extends Mock implements EditUser {}


void main () { 
  EditProfileBloc bloc;
  MockEditUser mockEditUser;
  
  setUp(() { 
    mockEditUser = MockEditUser();
    bloc = EditProfileBloc(editUser: mockEditUser);
  });

  test('initialState should be Normal State', () {
    // assert
    expect(bloc.state, equals(EditProfileNormal()));
  });

  test ('should return error if there is an error', () {
    when(mockEditUser(any)).thenAnswer((_) async => Left(ServerFailure(message: 'ERROR')));

    // assert layer
    final expected = [ 
      EditProfileLoading(),
      EditProfileError(message: 'ERROR')
    ];

    bloc.add(EditProfileUpdateUser(token: ''));
  });

  test ('If success state becomes success', () {
    when(mockEditUser(any )).thenAnswer((_) async => Right(true));

    // assert layer
    final expected = [ 
      EditProfileLoading(),
      EditProfileSuccess()
    ];

    bloc.add(EditProfileUpdateUser(token: ''));
  }); 
}
