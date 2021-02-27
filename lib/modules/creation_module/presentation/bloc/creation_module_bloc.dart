import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'creation_module_event.dart';
part 'creation_module_state.dart';
class CreationModuleBloc extends Bloc<CreationModuleEvent, CreationModuleState> {
  CreationModuleBloc() : super(CreationModuleInitial());
  @override
  Stream<CreationModuleState> mapEventToState(
    CreationModuleEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
