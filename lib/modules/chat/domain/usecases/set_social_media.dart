import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

class SetSocialMedia implements UseCase<ChatPermissions, SetSocialMediaParams> {
  final ChatRepository repository;

  SetSocialMedia({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatPermissions>> call(SetSocialMediaParams params) {
    return repository.setSocialMedia(id: params.id, socialMedia: params.socialMedia);
  }
}