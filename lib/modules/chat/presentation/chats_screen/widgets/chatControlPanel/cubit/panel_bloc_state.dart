part of 'panel_bloc_cubit.dart';

abstract class PanelBlocState extends Equatable {
  const PanelBlocState({
    @required this.showBottomPanel
  });

  final bool showBottomPanel;

  @override
  List<Object> get props => [
    showBottomPanel
  ];
}

class PanelBlocError extends PanelBlocState{
  final bool showBottomPanel;
  final String errorMessage;

  PanelBlocError({
    @required this.showBottomPanel,
    @required this.errorMessage,
  });

  @override
  List<Object> get props => [
    showBottomPanel,
    errorMessage,
  ];
}

class PanelBlocInitial extends PanelBlocState {
  final bool showBottomPanel;

  PanelBlocInitial({
    @required this.showBottomPanel
  });

  @override
  List<Object> get props => [
    showBottomPanel
  ];
}

class PanelBlocReplyMessage extends PanelBlocState{
  final MessageViewModel messageViewModel;
  final bool showBottomPanel;

  PanelBlocReplyMessage({
    @required this.messageViewModel,
    @required this.showBottomPanel
  }) : super(
    showBottomPanel: showBottomPanel
  );

  @override
  List<Object> get props => [
    messageViewModel,
    showBottomPanel
  ];
}
