import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/contact.dart';
import '../repositories/creation_module_repository.dart';
import 'params.dart';

class SearchContacts implements UseCase<PaginatedResult<ContactEntity>, SearchContactParams> {
  final CreationModuleRepository repository;

  SearchContacts(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> call(SearchContactParams params) async {
    return await repository.searchContacts(params.phoneNumber, params.nextPageURL);
  }
}