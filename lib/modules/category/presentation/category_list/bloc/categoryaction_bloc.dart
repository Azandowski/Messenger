import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'categoryaction_event.dart';
part 'categoryaction_state.dart';

class CategoryActionBloc extends Bloc<CategoryActionEvent, CategoryActionState> {
  CategoryActionBloc() : super(CategoryactionInitial());

  @override
  Stream<CategoryActionState> mapEventToState(
    CategoryActionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
