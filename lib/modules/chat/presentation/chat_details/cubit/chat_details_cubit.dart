import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/add_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/leave_chat.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/update_chat_settings.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  
  final GetChatDetails getChatDetails;
  final AddMembers addMembers;
  final LeaveChat leaveChat;
  final UpdateChatSettings updateChatSettings;

  ChatPermissions initialPermissions;

  ChatDetailsCubit({
    @required this.getChatDetails,
    @required this.addMembers,
    @required this.leaveChat,
    @required this.updateChatSettings
  }) : super(ChatDetailsLoading());

  Future<void> loadDetails (int id) async {
    var response =  await getChatDetails.call(id);

    response.fold(
      (failure) => emit(ChatDetailsError(
        chatDetailed: this.state.chatDetailed, 
        message: failure.message
      )), 
      (data) {
        initialPermissions = data.settings;
        emit(ChatDetailsLoaded(
          chatDetailed: data
        ));
      }
    );
  }


  Future<void> doLeaveChat (int id) async {
    emit(ChatDetailsProccessing(chatDetailed: this.state.chatDetailed));

    var response = await leaveChat(id);

    response.fold((failure) => emit(ChatDetailsError(
      message: failure.message,
      chatDetailed: this.state.chatDetailed
    )), (response) {
      emit(ChatDetailsLeave(
        chatDetailed: this.state.chatDetailed
      ));
    });
  }

  Future<void> addMembersToChat (int id, List<ContactEntity> contacts) async {
    emit(ChatDetailsProccessing(chatDetailed: this.state.chatDetailed));
    
    var response = await addMembers(AddMembersToChatParams(
      id: id,
      members: contacts.map((e) => e.id).toList()
    ));

    response.fold(
      (failure) => emit(ChatDetailsError(
        message: failure.message,
        chatDetailed: this.state.chatDetailed
      )), (newChatDetailed) => emit(ChatDetailsLoaded(
        chatDetailed: newChatDetailed
      ))
    );
  }

  void toggleChatSetting ({
    @required ChatSettings settings, 
    @required bool newValue, 
    @required int id,
    @required Function(ChatPermissions) callback 
  }) async {
    ChatPermissions newPermissions;
    
    switch (settings) {
      case ChatSettings.noSound:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          isSoundOn: !newValue
        ) ?? ChatPermissions(isSoundOn: !newValue, isMediaSendOn: false);
        break;
      case ChatSettings.noMedia:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          isMediaSendOn: !newValue
        ) ?? ChatPermissions(isSoundOn: false, isMediaSendOn: !newValue);
        break;
      case ChatSettings.adminSendMessage:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          adminMessageSend: newValue
        );
        break;
    }

    var newState = this.state.copyWith(chatDetailed: this.state.chatDetailed.copyWith(
      settings: newPermissions
    ));

    emit(newState);
    callback(newPermissions);
  }

  Future<void> onFinish ({
    @required int id,
    @required Function(ChatPermissions) callback
  }) async {
    if (_needsPermissionsUpdate) {
      var newPermissions = this.state.chatDetailed?.settings;

      var response = await updateChatSettings(UpdateChatSettingsParams(
        id: id,
        permissionModel: ChatPermissionModel(
          isSoundOn: newPermissions.isSoundOn,
          isMediaSendOn: newPermissions.isMediaSendOn,
          adminMessageSend: newPermissions.adminMessageSend
        )
      ));

      response.fold((failure) => emit(ChatDetailsError(
          chatDetailed: this.state.chatDetailed, 
          message: failure.message
        )), (result) {
          callback(result);
      });
    }
  }

  bool get _needsPermissionsUpdate {
    return 
      initialPermissions?.isSoundOn != this.state.chatDetailed?.settings?.isSoundOn || 
        initialPermissions?.isMediaSendOn != this.state.chatDetailed?.settings?.isMediaSendOn ||
          initialPermissions.adminMessageSend != this.state.chatDetailed?.settings?.adminMessageSend;
  }
}
