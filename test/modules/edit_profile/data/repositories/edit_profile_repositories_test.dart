import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/data/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';

class MockEditProfileDataSource extends Mock implements EditProfileDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  EditUserRepositoryImpl repository;
  MockEditProfileDataSource mockEditProfileDataSource;
  MockNetworkInfo mockNetworkInfo;
  EditUserParams editUserParams;

  setUp(() {
    mockEditProfileDataSource = MockEditProfileDataSource();
    mockNetworkInfo = MockNetworkInfo();
    editUserParams = EditUserParams(
      token: 'test',
      name: 'Name',
      patronym: 'Patronym',
      surname: 'Surname',
      phoneNumber: '+77777777777',
      image: File('image.jpg'),
    );

    repository = EditUserRepositoryImpl(
      editProfileDataSource: mockEditProfileDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  test('should check network connectivity', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    await repository.updateUser(editUserParams);
    verify(mockNetworkInfo.isConnected);
  });

  test('should return ConnectionFailure when there is no connection', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    final result = await repository.updateUser(editUserParams);
    expect(result, equals(Left(ConnectionFailure())));
    verifyZeroInteractions(mockEditProfileDataSource);
  });

  test('should return ServerFailure if there is any exception', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockEditProfileDataSource.updateUser(
      file: editUserParams.image,
      data: editUserParams.jsonBody,
      token: editUserParams.token,
    )).thenThrow(ServerFailure(message: 'test'));

    final result = await repository.updateUser(editUserParams);

    expect(result, equals(Left(ServerFailure(message: 'test'))));
  });

  test('should return Right(bool) if everything is OK', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockEditProfileDataSource.updateUser(
      file: editUserParams.image,
      data: editUserParams.jsonBody,
      token: editUserParams.token,
    )).thenAnswer((_) async => true);

    final result = await repository.updateUser(editUserParams);

    expect(result, equals(Right(true)));
  });
}
