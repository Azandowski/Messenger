import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/code_entity.dart';
import '../../../../domain/usecases/create_code.dart';

part 'typephone_state.dart';

class TypephoneCubit extends Cubit<TypephoneState> {
  final CreateCode createCode;

  TypephoneCubit({
    @required this.createCode,
  }) : super(TypephoneInitial());

  Future<void> sendPhone(String phoneNumber) async {
    emit(SendingPhone());
    var codeOrFail = await createCode(PhoneParams(phoneNumber: phoneNumber));
    codeOrFail.fold(
      (failure) {
        emit(InvalidPhone(failure.message));
      },
      (code) {
        emit(Success(code));
      },
    );
  }
}

//  Future<void> logInWithGoogle() async {
//     emit(state.copyWith(status: FormzStatus.submissionInProgress));
//     try {
//       await _authenticationRepository.logInWithGoogle();
//       emit(state.copyWith(status: FormzStatus.submissionSuccess));
//     } on Exception {
//       emit(state.copyWith(status: FormzStatus.submissionFailure));
//     } on NoSuchMethodError {
//       emit(state.copyWith(status: FormzStatus.pure));
//     }
//   }
