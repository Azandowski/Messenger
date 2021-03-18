import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/creation_module/data/datasources/creation_module_datasource.dart';
import 'package:messenger_mobile/modules/creation_module/data/repositories/creation_module_repository.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:mockito/mockito.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockCreationModuleDataSource extends Mock
    implements CreationModuleDataSource {}

void main() {
  CreationModuleRepositoryImpl repository;
  MockNetworkInfo networkInfo;
  MockCreationModuleDataSource creationModuleDataSource;

  setUp(() {
    networkInfo = MockNetworkInfo();
    creationModuleDataSource = MockCreationModuleDataSource();
    repository = CreationModuleRepositoryImpl(
      dataSource: creationModuleDataSource,
      networkInfo: networkInfo,
    );
  });

  final tPagination = Pagination();
  test('should return ServerFailure if datasource throws an error', () async {
    when(creationModuleDataSource.fetchContacts(any))
        .thenThrow(ServerFailure(message: "message"));

    final result = await repository.fetchContacts(tPagination);

    expect(result, Left(ServerFailure(message: "message")));
  });

  test('should return PaginatedResult when everything is OK', () async {
    final PaginatedResult<ContactEntity> expected =
        PaginatedResult<ContactEntity>();
    when(creationModuleDataSource.fetchContacts(any))
        .thenAnswer((_) async => expected);

    final result = await repository.fetchContacts(tPagination);

    expect(result, Right(expected));
  });
}
