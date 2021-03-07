import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/pagination.dart';
import '../../data/models/contact_response.dart';

abstract class CreationModuleRepository {
  Future<Either<Failure, ContactResponse>> fetchContacts(Pagination pagination);
}