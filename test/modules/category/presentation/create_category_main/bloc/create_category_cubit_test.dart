import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/category/domain/entities/create_category_screen_params.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/create_category.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/transfer_chat.dart';
import 'package:messenger_mobile/modules/category/presentation/create_category_main/bloc/create_category_cubit.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_category_chats.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';
import 'package:mockito/mockito.dart';

class MockCreateCategoryUseCase extends Mock implements CreateCategoryUseCase {}

class MockGetImage extends Mock implements GetImage {}

class MockTransferChats extends Mock implements TransferChats {}

class MockGetCategoryChats extends Mock implements GetCategoryChats {}

class MockAuthConfig extends Mock implements AuthConfig {}

void main() {
  CreateCategoryCubit cubit;
  MockCreateCategoryUseCase mockCreateCategory;
  MockGetImage mockGetImage;
  MockTransferChats mockTransferChats;
  MockGetCategoryChats mockGetCategoryChats;
  MockAuthConfig mockAuthConfig;
  CategoryEntity tCategoryEntity;

  setUp(() {
    mockCreateCategory = MockCreateCategoryUseCase();
    mockGetImage = MockGetImage();
    mockTransferChats = MockTransferChats();
    mockGetCategoryChats = MockGetCategoryChats();
    mockAuthConfig = MockAuthConfig();

    cubit = CreateCategoryCubit(
      createCategory: mockCreateCategory,
      getImageUseCase: mockGetImage,
      transferChats: mockTransferChats,
      getCategoryChats: mockGetCategoryChats,
      authConfig: mockAuthConfig,
    );

    tCategoryEntity =
        CategoryEntity(id: 1, name: "name", avatar: "avatar", totalChats: 1);
  });

  test('state should be CreateCategoryNormal after init', () {
    expect(cubit.state, isA<CreateCategoryNormal>());
  });

  group('selectPhoto', () {
    blocTest(
      'should emit [CreateCategoryError] on StorageFailure',
      build: () => cubit,
      act: (cubit) {
        when(mockGetImage(any)).thenAnswer((_) async => Left(StorageFailure()));
        cubit.selectPhoto(ImageSource.gallery);
      },
      expect: () => [
        CreateCategoryError(message: 'Unable to get image'),
      ],
    );

    blocTest(
      'should emit [CreateCategoryNormal] when image file is received',
      build: () => cubit,
      act: (cubit) {
        when(mockGetImage(any)).thenAnswer((_) async => Right(File('image')));
        cubit.selectPhoto(ImageSource.gallery);
      },
      expect: () => [
        isA<CreateCategoryNormal>(),
      ],
    );
  });

  group('sendData', () {
    blocTest(
      'should emit [CreateCategoryLoading, CreateCategoryError] on ConnectionFailure',
      build: () => cubit,
      act: (CreateCategoryCubit cubit) {
        when(mockCreateCategory(any))
            .thenAnswer((_) async => Left(ConnectionFailure()));
        cubit.sendData(CreateCategoryScreenMode.create, 1);
      },
      expect: () => [
        isA<CreateCategoryLoading>(),
        isA<CreateCategoryError>(),
      ],
    );

    blocTest(
      'should emit [CreateCategoryLoading, CreateCategorySuccess] on success',
      build: () => cubit,
      act: (CreateCategoryCubit cubit) {
        when(mockCreateCategory(any)).thenAnswer(
          (_) async => Right([tCategoryEntity]),
        );
        cubit.sendData(CreateCategoryScreenMode.create, 1);
      },
      expect: () => [
        isA<CreateCategoryLoading>(),
        isA<CreateCategorySuccess>(),
      ],
    );
  });

  group('doTransferChats', () {
    blocTest(
      'should emit [CreateCategoryTransferLoading, CreateCategoryError] on ConnectionFailure',
      build: () => cubit,
      act: (CreateCategoryCubit cubit) {
        when(mockTransferChats(any))
            .thenAnswer((_) async => Left(ConnectionFailure()));
        cubit.doTransferChats(1);
      },
      expect: () => [
        isA<CreateCategoryTransferLoading>(),
        isA<CreateCategoryError>(),
      ],
    );

    blocTest(
      'should emit [CreateCategoryTransferLoading, CreateCategoryNormal] on success',
      build: () => cubit,
      act: (CreateCategoryCubit cubit) {
        when(mockTransferChats(any)).thenAnswer(
          (_) async => Right([
            tCategoryEntity,
          ]),
        );
        cubit.doTransferChats(1);
      },
      expect: () => [
        isA<CreateCategoryTransferLoading>(),
        isA<CreateCategoryNormal>(),
      ],
    );
  });

  group('prepareEditing', () {
    blocTest(
      'should emit [CreateCategoryChatsLoading, CreateCategoryError] on ConnectionFailure',
      build: () => cubit,
      act: (CreateCategoryCubit cubit) {
        when(mockGetCategoryChats(any))
            .thenAnswer((_) async => Left(ConnectionFailure()));
        cubit.prepareEditing(tCategoryEntity);
      },
      expect: () => [
        isA<CreateCategoryChatsLoading>(),
        isA<CreateCategoryError>(),
      ],
    );

    final tChatEntity = ChatEntity(
      chatCategory: tCategoryEntity,
      title: "title",
      imageUrl: "imageUrl",
      chatId: 1,
      date: DateTime.now(),
      permissions: ChatPermissions(),
      unreadCount: 1,
      description: "description",
    );

    // blocTest(
    //   'should emit [CreateCategoryChatsLoading, CreateCategoryNormal] on ConnectionFailure',
    //   build: () => cubit,
    //   act: (CreateCategoryCubit cubit) {
    //     when(mockGetCategoryChats(any))
    //         .thenAnswer((_) async => Right([tChatEntity]));
    //     cubit.prepareEditing(tCategoryEntity);
    //   },
    //   expect: ()=>[
    //     isA<CreateCategoryChatsLoading>(),
    //     isA<CreateCategoryNormal>(),
    //   ],
    // );
  });
}
