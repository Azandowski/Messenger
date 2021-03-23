import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';


class UpdateChatSettings implements UseCase<ChatPermissions, UpdateChatSettingsParams> {
  final ChatRepository repository;

  UpdateChatSettings({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatPermissions>> call(UpdateChatSettingsParams params) async {
    return repository.updateChatSettings(
      id: params.id,
      permissions: params.permissionModel
    );
  }
}
