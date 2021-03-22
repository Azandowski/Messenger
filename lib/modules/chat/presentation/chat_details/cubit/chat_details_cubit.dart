import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/block_user.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/kick_member.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_social_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';

import '../../../../category/data/models/chat_permission_model.dart';
import '../../../../category/domain/entities/chat_permissions.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../domain/entities/chat_detailed.dart';
import '../../../domain/usecases/add_members.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../../domain/usecases/kick_member.dart';
import '../../../domain/usecases/leave_chat.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/update_chat_settings.dart';
import '../widgets/chat_setting_item.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  
  final GetChatDetails getChatDetails;
  final AddMembers addMembers;
  final LeaveChat leaveChat;
  final UpdateChatSettings updateChatSettings;
  final KickMembers kickMembers;
  final BlockUser blockUser;
  final SetSocialMedia setSocialMedia;

  ChatPermissions initialPermissions;

  ChatDetailsCubit({
    @required this.getChatDetails,
    @required this.addMembers,
    @required this.leaveChat,
    @required this.updateChatSettings,
    @required this.kickMembers,
    @required this.blockUser,
    @required this.setSocialMedia
  }) : super(ChatDetailsLoading());

  Future<void> loadDetails (int id, ProfileMode mode) async {
    var response =  await getChatDetails.call(GetChatDetailsParams(
      mode: mode, id: id
    ));

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

  Future<void> kickMember (int id, int userID) async {
    emit(ChatDetailsProccessing(chatDetailed: this.state.chatDetailed));

    var response = await kickMembers(KickMemberParams(
      id: id, 
      userID: userID
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
      case ChatSettings.forwardMessages:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          isForwardOn: newValue
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
          adminMessageSend: newPermissions.adminMessageSend,
          isForwardOn: newPermissions.isForwardOn
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

  Future<void> blockUnblockUser ({
    @required int userID, 
    @required bool isBlock
  }) async {
    emit(ChatDetailsProccessing(chatDetailed: this.state.chatDetailed));

    var response = await blockUser(BlockUserParams(
      isBloc: isBlock, 
      userID: userID
    ));

    response.fold((failure) => emit(ChatDetailsError(
      message: failure.message,
      chatDetailed: this.state.chatDetailed
    )), (_) {
      var newUser = state.chatDetailed.user.copyWith(isBlocked: isBlock);
      var chatDetails = state.chatDetailed.copyWith(user: newUser);
      emit(ChatDetailsLoaded(
        chatDetailed: chatDetails
      ));
    });
  }

  Future<void> setNewSocialMedia ({
    @required int id,
    @required SocialMedia newSocialMedia,
  }) async {
    emit(ChatDetailsProccessing(chatDetailed: this.state.chatDetailed));

    var response = await setSocialMedia(SetSocialMediaParams(
      id: id, 
      socialMedia: newSocialMedia
    ));

    response.fold((failure) => emit(ChatDetailsError(
      message: failure.message,
      chatDetailed: this.state.chatDetailed
    )), (response) {
      emit(ChatDetailsLoaded(
        chatDetailed: state.chatDetailed.copyWith(socialMedia: newSocialMedia)
      ));
    });
  }

  void showError (String message) {
    emit(ChatDetailsError(
      chatDetailed: this.state.chatDetailed,
      message: message
    ));
  }


  bool get _needsPermissionsUpdate {
    return 
      initialPermissions?.isSoundOn != this.state.chatDetailed?.settings?.isSoundOn || 
        initialPermissions?.isMediaSendOn != this.state.chatDetailed?.settings?.isMediaSendOn ||
          initialPermissions.adminMessageSend != this.state.chatDetailed?.settings?.adminMessageSend || 
            initialPermissions.isForwardOn != this.state.chatDetailed?.settings?.isForwardOn; 
  }
}
