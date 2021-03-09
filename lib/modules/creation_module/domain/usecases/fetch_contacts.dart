import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination.dart';
import '../../data/models/contact_response.dart';
import '../repositories/creation_module_repository.dart';

class FetchContacts implements UseCase<PaginatedResult<ContactEntity>, Pagination> {
  final CreationModuleRepository repository;

  FetchContacts(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> call(Pagination pagination) async {
    return await repository.fetchContacts(pagination);
  }
}

class PhoneParams extends Equatable {
  final String phoneNumber;

  PhoneParams({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
