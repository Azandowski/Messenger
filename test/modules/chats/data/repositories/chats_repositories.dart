import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/data/repositories/chats_repository_impl.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements ChatsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() { 
  ChatsRepositoryImpl repository;
  MockRemoteDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() { 
    dataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ChatsRepositoryImpl(
      chatsDataSource: dataSource, 
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

  group('Get Categories', () {
    
    final List<CategoryModel> categories = [
      CategoryModel(
        id: 1,
        totalChats: 1,
        name: 'Superwork',
        avatar: 'image.png'
      )
    ];

    final GetCategoriesParams params = GetCategoriesParams(token: '');

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        
        // act
        repository.getCategories(params);
        
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(dataSource.getCategories(any))
            .thenAnswer((_) async => categories);
          // act
          final result = await repository.getCategories(params);
          // assert
          
          verify(dataSource.getCategories(params.token));
          expect(result, equals(Right(categories)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(dataSource.getCategories(any))
              .thenThrow(ServerFailure(message: ''));
          // act
          final result = await repository.getCategories(params);
          // assert
          verify(dataSource.getCategories(params.token));
          expect(result, isA<Left>());
        },
      );      
    });

    runTestsOffline(() {
      test(
        'should return internet error',
        () async {
          // arrange
          when(dataSource.getCategories(any))
              .thenAnswer((_) async => categories);
          // act
          final result = await repository.getCategories(params);
          expect(result, isA<Left>());
        });
    });
  });
} 
