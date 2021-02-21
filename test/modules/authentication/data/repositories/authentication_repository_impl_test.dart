import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_model.dart';
import 'package:messenger_mobile/modules/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/login.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

class MockLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  AuthenticationRepositiryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositiryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
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

  group('createCode repo', () {
    final CodeModel codeEntity =
        CodeModel(id: 12, phone: '+77055946560', code: '1122', attempts: 0);
    final phone = '+77055946560';
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.createCode(PhoneParams(phoneNumber: '+77055946560'));
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    runTestsOnline(() {
      test(
        'should return codeEntity when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.createCode(any))
              .thenAnswer((_) async => codeEntity);
          // act
          final result =
              await repository.createCode(PhoneParams(phoneNumber: phone));
          // verify
          verify(mockRemoteDataSource.createCode(phone));
          expect(result, equals(Right(codeEntity)));
        },
      );

      test(
        'should return server failure when the login to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.createCode(any))
              .thenThrow(ServerFailure(message: 'invalid phone'));
          // act
          final result =
              await repository.createCode(PhoneParams(phoneNumber: phone));
          // assert
          verify(mockRemoteDataSource.createCode(phone));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure(message: 'invalid phone'))));
        },
      );
    });
  });

  group('login repo', () {
    final code = '1212';
    final phone = '+77055946560';
    final tokenModel = TokenModel(token: 'sometoken');
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.createCode(PhoneParams(phoneNumber: '+77055946560'));
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return token when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any))
              .thenAnswer((_) async => tokenModel);
          // act
          final result = await repository
              .login(LoginParams(phoneNumber: phone, code: code));
          // verify
          verify(mockRemoteDataSource.login(phone, code));
          expect(result, equals(Right(tokenModel)));
        },
      );

      test(
        'should return server failure when the login to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(any, any))
              .thenThrow(ServerFailure(message: 'no_internet'));
          // act
          final result = await repository
              .login(LoginParams(phoneNumber: phone, code: code));
          // assert
          verify(mockRemoteDataSource.login(phone, code));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure(message: 'no_internet'))));
        },
      );
    });
  });
}
