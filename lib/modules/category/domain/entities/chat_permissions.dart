import 'package:equatable/equatable.dart';

class ChatPermissions extends Equatable {
  final bool isSoundOn;

  ChatPermissions({
    this.isSoundOn = true
  });

  @override
  List<Object> get props => [isSoundOn];
}
