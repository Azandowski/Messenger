import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'creation_module_state.dart';

class CreationModuleCubit extends Cubit<CreationModuleState> {


  CreationModuleCubit() : super(CreationModuleInitial());
}
