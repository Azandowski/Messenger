import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/login.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/get_categories.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

class MockLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGetCategories extends Mock implements GetCategories {}

class MockAuthConfig extends Mock implements AuthConfig {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthenticationRepositiryImpl repository;

  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockGetCategories mockGetCategories;
  MockAuthConfig mockAuthConfig;
  User tUser;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockGetCategories = MockGetCategories();
    mockAuthConfig = MockAuthConfig();

    repository = AuthenticationRepositiryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      getCategories: mockGetCategories,
      authConfig: mockAuthConfig,
      isTestMode: true,
    );
    tUser = User(
      name: 'Name',
      surname: 'Surname',
      patronym: 'Patronym',
      phoneNumber: '+77777777777',
      profileImage: 'image',
    );
    when(mockLocalDataSource.getToken()).thenAnswer((_) async => 'test');
    // when(mockLocalDataSource.getContacts()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getCurrentUser(any))
        .thenAnswer((_) async => tUser);
  });

  group('AuthenticationRepositoryImpl.initToken', () {
    test(
      'should get token from localDataSource',
      () async {
        // act
        repository.initToken();

        // assert
        verify(mockLocalDataSource.getToken());
      },
    );
    test(
      'should get contacts from localDataSource',
      () async {
        // act
        repository.initToken();

        // assert
        // verify(mockLocalDataSource.getContacts());
      },
    );
  });

  group('AuthenticationRepositoryImpl.createCode', () {
    final phone = '+77777777777';
    final CodeModel codeEntity =
        CodeModel(id: 12, phone: phone, code: '0000', attempts: 0);

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.createCode(PhoneParams(phoneNumber: phone));
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('run test online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
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
          expect(
            result,
            equals(Left(ServerFailure(message: FailureMessages.invalidPhone))),
          );
        },
      );
    });

    test(
      'should return ServerFailure when device is offline',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        final result =
            await repository.createCode(PhoneParams(phoneNumber: phone));
        // verify
        expect(
          result,
          equals(Left(ServerFailure(message: FailureMessages.noConnection))),
        );
      },
    );
  });

  group('AuthenticationRepository.getToken()', () {
    test(
      'should return token from localDataSource',
      () async {
        // arrange
        final String token = 'test';
        when(mockLocalDataSource.getToken()).thenAnswer((_) async => token);
        // act
        final result = await repository.getToken();
        // assert
        verify(mockLocalDataSource.getToken());
        expect(result, equals(Right(token)));
      },
    );
    test(
      'should return StorageFailure when there is some error',
      () async {
        // arrange
        when(mockLocalDataSource.getToken()).thenThrow(StorageFailure());
        // act
        final result = await repository.getToken();
        // assert
        expect(result, equals(Left(StorageFailure())));
      },
    );
  });

  group('AuthenticationRepository.login()', () {
    final tLoginParams = LoginParams(phoneNumber: '+77777777777', code: '0000');
    final tTokenEntity = TokenEntity(token: 'test');

    test(
      'should save token to localDataSource and return TokenEntity from remoteDataSource',
      () async {
        // arrange
        when(mockRemoteDataSource.login(
                tLoginParams.phoneNumber, tLoginParams.code))
            .thenAnswer((_) async => tTokenEntity);
        // act
        final result = await repository.login(tLoginParams);
        // assert
        verify(mockLocalDataSource.saveToken(tTokenEntity.token));
        expect(result, equals(Right(tTokenEntity)));
      },
    );
    test(
      'should return ServerFailure when there is some error',
      () async {
        // arrange
        when(mockRemoteDataSource.login(
                tLoginParams.phoneNumber, tLoginParams.code))
            .thenThrow(ServerFailure(message: FailureMessages.invalidCode));
        // act
        final result = await repository.login(tLoginParams);
        // assert
        expect(
          result,
          equals(Left(ServerFailure(message: FailureMessages.invalidCode))),
        );
      },
    );
  });

  group('AuthenticationRepository.saveToken()', () {
    test(
      'should save token to localDataSource and return token back',
      () async {
        // arrange
        final token = 'test';
        // act
        final result = await repository.saveToken(token);
        // assert
        verify(mockLocalDataSource.saveToken(token));
        expect(result, equals(Right(token)));
      },
    );
  });

  group('AuthenticationRepository.getCurrentUser()', () {
    test(
      'should getCurrentUser form remoteDataSource and return User',
      () async {
        final token = 'test';
        // act
        final result = await repository.getCurrentUser(token);
        // assert
        verify(mockRemoteDataSource.getCurrentUser(token));
        expect(result, equals(Right(tUser)));
      },
    );

    test(
      'should return ServerFailure when there is error',
      () async {
        // arrange
        final token = 'test';
        when(mockRemoteDataSource.getCurrentUser(token)).thenThrow(
          ServerFailure(message: FailureMessages.noConnection),
        );
        // act
        final result = await repository.getCurrentUser(token);
        // assert
        expect(
          result,
          equals(Left(ServerFailure(message: FailureMessages.noConnection))),
        );
      },
    );
  });
}
