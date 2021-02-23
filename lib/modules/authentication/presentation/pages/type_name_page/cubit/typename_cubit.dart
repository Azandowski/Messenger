import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'typename_state.dart';

class TypeNameCubit extends Cubit<TypeNameState> {
  TypeNameCubit() : super(TypenameInitial());
}
