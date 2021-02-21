import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/edit_profile/data/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';


class MockEditProfileDataSource extends Mock implements EditProfileDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}


void main() { 
  EditUserRepositoryImpl repository;
  MockEditProfileDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() { 
    dataSource = MockEditProfileDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = EditUserRepositoryImpl(  
      editProfileDataSource: dataSource,
      networkInfo: mockNetworkInfo
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }


  group('Update Current User', () { 
    final userModel = UserModel(
      name: 'Yerkebulan',
      phoneNumber: '+77470726323',
      profileImage: 'image'
    );
    
    final User user  = userModel;

    final EditUserParams editUserParams = EditUserParams(
      token: '',
      name: userModel.name
    );
    
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        
        // act
        repository.updateUser(editUserParams);
        
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(dataSource.updateUser(
            file: anyNamed('file'), 
            data: anyNamed('data'), 
            token: anyNamed('token')
          )).thenAnswer((_) async => true);
          // act
          final result = await repository.updateUser(editUserParams);
          
          // assert
          verify(dataSource.updateUser(
            file: editUserParams.image, 
            data: editUserParams.jsonBody, 
            token: editUserParams.token
          ));

          expect(result, equals(Right(true)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(dataSource.updateUser(
            file: anyNamed('file'), 
            data: anyNamed('data'), 
            token: anyNamed('token')
          )).thenThrow(ServerFailure(message: ''));
          
          // act
          final result = await repository.updateUser(editUserParams);
          
          // assert
          verify(dataSource.updateUser(
            file: editUserParams.image, 
            data: editUserParams.jsonBody, 
            token: editUserParams.token
          ));
          expect(result, isA<Left>());
        },
      );      
    });
  });
}