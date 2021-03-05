import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';

abstract class CreationModuleRepository {
  Future<Either<Failure, ContactResponse>> fetchContacts(Pagination pagination);
}