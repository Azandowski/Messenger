import 'package:equatable/equatable.dart';

class ChatPermissions extends Equatable {
  final bool isSoundOn;
  final bool isMediaSendOn;

  ChatPermissions({
    this.isSoundOn = true,
    this.isMediaSendOn = true
  });

  ChatPermissions copyWith({
    isSoundOn,
    isMediaSendOn
  }) {
    return ChatPermissions(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMediaSendOn: isMediaSendOn ?? this.isMediaSendOn
    );
  }

  @override
  List<Object> get props => [isSoundOn, isMediaSendOn];
}
