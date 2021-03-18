import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/creation_module/domain/repositories/creation_module_repository.dart';
import 'package:messenger_mobile/modules/creation_module/domain/usecases/fetch_contacts.dart';
import 'package:mockito/mockito.dart';

class MockCreationModuleReopsitory extends Mock
    implements CreationModuleRepository {}

void main() {
  MockCreationModuleReopsitory repository;
  FetchContacts usecase;
  setUp(() {
    repository = MockCreationModuleReopsitory();
    usecase = FetchContacts(repository);
  });

  final tPagination = Pagination();
  test('should call repository once and return PaginatedResult', () async {
    final Right<Failure, PaginatedResult<ContactEntity>> a =
        Right(PaginatedResult<ContactEntity>());
    when(repository.fetchContacts(any)).thenAnswer((_) async => a);

    final result = await usecase(tPagination);

    expect(result, equals(a));
    verify(repository.fetchContacts(tPagination));
    verifyNoMoreInteractions(repository);
  });
}
