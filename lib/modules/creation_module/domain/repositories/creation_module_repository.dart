import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/pagination.dart';
import '../../data/models/contact_response.dart';

abstract class CreationModuleRepository {
  Future<Either<Failure, PaginatedResult<ContactEntity>>> fetchContacts(Pagination pagination);
}