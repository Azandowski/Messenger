import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/utils/pagination.dart';
import '../entities/contact.dart';

abstract class CreationModuleRepository {
  Future<Either<Failure, PaginatedResult<ContactEntity>>> fetchContacts(Pagination pagination);
}