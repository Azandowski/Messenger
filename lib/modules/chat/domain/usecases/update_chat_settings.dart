import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';


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
