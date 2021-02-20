import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/profile/data/datasources/profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/data/repositories/profile_repository.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements ProfileDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() { 
  ProfileRepositoryImpl repository;
  MockRemoteDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() { 
    dataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProfileRepositoryImpl(
      profileDataSource: dataSource, 
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

  group('Get Current User', () {
    
    final userModel = UserModel(
      name: 'Yerkebulan',
      phoneNumber: '+77470726323',
      profileImage: 'image'
    );
    
    final User user  = userModel;
    final GetUserParams getUserParams = GetUserParams(token: 'sample token');

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        
        // act
        repository.getUser(getUserParams);
        
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(dataSource.getCurrentUser(any))
            .thenAnswer((_) async => userModel);
          // act
          final result = await repository.getUser(getUserParams);
          // assert
          
          verify(dataSource.getCurrentUser(getUserParams.token));
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(dataSource.getCurrentUser(any))
              .thenThrow(ServerFailure(message: ''));
          // act
          final result = await repository.getUser(getUserParams);
          // assert
          verify(dataSource.getCurrentUser(getUserParams.token));
          expect(result, isA<Left>());
        },
      );      
    });

    runTestsOffline(() {
      test(
        'should return internet error',
        () async {
          // arrange
          when(dataSource.getCurrentUser(any))
              .thenAnswer((_) async => userModel);
          // act
          final result = await repository.getUser(getUserParams);
          // assert
          expect(result, isA<Left>());
        });
    });
  });
} 
