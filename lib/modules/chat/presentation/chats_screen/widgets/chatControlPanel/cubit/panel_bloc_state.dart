part of 'panel_bloc_cubit.dart';

abstract class PanelBlocState extends Equatable {
  const PanelBlocState({
    @required this.showBottomPanel,
    @required this.showEmojies
  });

  final bool showBottomPanel;
  final bool showEmojies;

  @override
  List<Object> get props => [
    showBottomPanel, showEmojies
  ];

  PanelBlocState copyWith ({
    bool showEmojies,
    bool showBottomPanel
  });
}

class PanelBlocError extends PanelBlocState {
  final bool showBottomPanel;
  final String errorMessage;
  final bool showEmojies;

  PanelBlocError({
    @required this.showBottomPanel,
    @required this.errorMessage,
    @required this.showEmojies
  }) : super(
    showBottomPanel: showBottomPanel,
    showEmojies: showEmojies
  );

  @override
  List<Object> get props => [
    showBottomPanel,
    errorMessage,
    showEmojies
  ];

  @override
  PanelBlocState copyWith({
    bool showEmojies,
    bool showBottomPanel
  }) {
    return PanelBlocError(
      errorMessage: errorMessage,
      showEmojies: showEmojies ?? this.showEmojies,
      showBottomPanel: showBottomPanel ?? this.showBottomPanel
    );
  }
}

class PanelBlocInitial extends PanelBlocState {
  final bool showBottomPanel;
  final bool showEmojies;

  PanelBlocInitial({
    @required this.showBottomPanel,
    @required this.showEmojies
  }) : super(
    showBottomPanel: showBottomPanel,
    showEmojies: showEmojies
  );

  @override
  List<Object> get props => [
    showBottomPanel,
    showEmojies
  ];

  @override
  PanelBlocState copyWith({
    bool showEmojies,
    bool showBottomPanel
  }) {
    return PanelBlocInitial(
      showEmojies: showEmojies ?? this.showEmojies,
      showBottomPanel: showBottomPanel ?? this.showBottomPanel
    );
  }
}

class PanelBlocReplyMessage extends PanelBlocState {
  final MessageViewModel messageViewModel;
  final bool showBottomPanel;
  final bool showEmojies;

  PanelBlocReplyMessage({
    @required this.messageViewModel,
    @required this.showBottomPanel,
    @required this.showEmojies
  }) : super(
    showBottomPanel: showBottomPanel,
    showEmojies: showEmojies
  );

  @override
  List<Object> get props => [
    messageViewModel,
    showBottomPanel,
    showEmojies
  ];

  @override
  PanelBlocState copyWith({
    bool showEmojies,
    bool showBottomPanel
  }) {
    return PanelBlocReplyMessage(
      showEmojies: showEmojies ?? this.showEmojies,
      showBottomPanel: showBottomPanel ?? this.showBottomPanel,
      messageViewModel: messageViewModel
    );
  }
}
