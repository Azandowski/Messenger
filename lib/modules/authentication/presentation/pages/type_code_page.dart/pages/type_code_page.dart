import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../app/appTheme.dart';
import '../../../../../../core/utils/snackbar_util.dart';
import '../../../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../../../locator.dart';
import '../../../../domain/entities/code_entity.dart';
import '../../../widgets/pin_field.dart';
import '../../type_phone_page/cubit/typephone_cubit.dart';
import '../cubit/cubit/typecode_cubit.dart';

class TypeCodePage extends StatefulWidget {
  const TypeCodePage({Key key, @required this.codeEntity}) : super(key: key);

  static Route route(CodeEntity codeEntity) {
    return MaterialPageRoute<void>(
        builder: (_) => TypeCodePage(
              codeEntity: codeEntity,
            ));
  }

  final CodeEntity codeEntity;

  @override
  _TypeCodePageState createState() => _TypeCodePageState();
}

class _TypeCodePageState extends State<TypeCodePage> {
  final TextEditingController _pinPutController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();
  int timer = 30;

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (time) {
      if (mounted) {
        setState(() {
          if (timer != 0) {
            timer--;
          } else {
            time.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var phoneCubit = context.read<TypephoneCubit>();
    return BlocProvider(
      create: (context) => TypeCodeCubit(login: sl(), saveToken: sl()),
      child: BlocConsumer<TypeCodeCubit, TypeCodeState>(
        listener: (context, state) {
          if (state is InvalidCode) {
            _pinPutController.clear();
            SnackUtil.showError(context: context, message: state.message);
          } else if (state is SuccessCode) {
            SnackUtil.showInfo(context: context, message: 'success'.tr());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'enter_code'.tr(),
                  style: AppFontStyles.headingBlackStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'code_sent_to'.tr(namedArgs: {
                    'number': '${widget.codeEntity.phone}' 
                  }),
                  style: AppFontStyles.placeholderStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                PinField(
                  pinPutFocusNode: _pinPutFocusNode,
                  phoneCubit: phoneCubit,
                  widget: widget,
                  pinPutController: _pinPutController,
                  onSubmit: (value) {
                    _pinPutFocusNode.unfocus();
                    phoneCubit.sendPhone(widget.codeEntity.phone);
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Center(
                  child: timer > 0
                    ? Text(
                      'get_code_after'.tr(namedArgs: {
                        'seconds': '$timer'
                      }),
                      style: AppFontStyles.placeholderStyle
                    )
                    : InkWell(
                        onTap: () {
                          phoneCubit.sendPhone(widget.codeEntity.phone);
                          setState(() {
                            timer = 30;
                            _startTimer();
                            _pinPutController.clear();
                          });
                        },
                        child: Text('retry_code'.tr(),
                            style: AppFontStyles.placeholderStyle),
                      )
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                ActionButton(
                  text: 'confirm'.tr(),
                  isLoading: state is SendingCode,
                  onTap: () {
                    if (_pinPutController.value.text != null &&
                        _pinPutController.value.text != '' &&
                        _pinPutController.value.text.length == 4) {
                      context.read<TypeCodeCubit>().sendCode(
                            widget.codeEntity,
                            _pinPutController.text,
                          );
                    } else {
                      SnackUtil.showError(context: context, message: 'invalidCode'.tr());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
