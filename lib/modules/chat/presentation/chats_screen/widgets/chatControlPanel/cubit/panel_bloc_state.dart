part of 'panel_bloc_cubit.dart';

abstract class PanelBlocState extends Equatable {
  const PanelBlocState();

  @override
  List<Object> get props => [];
}

class PanelBlocInitial extends PanelBlocState {}

class PanelBlocReplyMessage extends PanelBlocState{
  final MessageViewModel messageViewModel;

  PanelBlocReplyMessage({
    @required this.messageViewModel
  });

  @override
  List<Object> get props => [messageViewModel];
}
