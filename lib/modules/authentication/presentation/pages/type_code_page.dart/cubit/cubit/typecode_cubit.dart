import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/code_entity.dart';
import '../../../../../domain/entities/token_entity.dart';
import '../../../../../domain/usecases/login.dart';
import '../../../../../domain/usecases/save_token.dart';

part 'typecode_state.dart';

class TypeCodeCubit extends Cubit<TypeCodeState> {
  final Login login;
  final SaveToken saveToken;
  TypeCodeCubit({@required this.login, @required this.saveToken})
      : super(TypecodeInitial());

  Future<void> sendCode(CodeEntity codeEntity, String code) async {
    emit(SendingCode());
    var tokenOrFail =
        await login(LoginParams(phoneNumber: codeEntity.phone, code: code));
    tokenOrFail.fold(
      (failure) {
        emit(InvalidCode(failure.message));
      },
      (TokenEntity token) async {
        await saveToken(token.token);
        emit(SuccessCode(token));
      },
    );
  }
}
