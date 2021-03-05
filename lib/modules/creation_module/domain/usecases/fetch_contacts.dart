import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';
import 'package:messenger_mobile/modules/creation_module/domain/repositories/creation_module_repository.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class FetchContacts implements UseCase<ContactResponse, Pagination> {
  final CreationModuleRepository repository;

  FetchContacts(this.repository);

  @override
  Future<Either<Failure, ContactResponse>> call(Pagination pagination) async {
    return await repository.fetchContacts(pagination);
  }
}

class PhoneParams extends Equatable {
  final String phoneNumber;

  PhoneParams({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
