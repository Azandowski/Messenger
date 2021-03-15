import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/creation_module/domain/repositories/creation_module_repository.dart';
import 'package:messenger_mobile/modules/creation_module/domain/usecases/params.dart';

class SearchContacts implements UseCase<PaginatedResult<ContactEntity>, SearchContactParams> {
  final CreationModuleRepository repository;

  SearchContacts(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> call(SearchContactParams params) async {
    return await repository.searchContacts(params.phoneNumber, params.nextPageURL);
  }
}