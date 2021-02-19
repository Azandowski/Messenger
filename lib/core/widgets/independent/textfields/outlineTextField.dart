import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';


class OutlineTextField extends StatelessWidget {
  final num height;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final bool isFocused;

  const OutlineTextField({
    Key key, 
    this.focusNode, 
    this.textEditingController,
    this.isFocused = false,
    this.height = 40.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    // return TextFormField(
    //   focusNode: focusNode,
    //   controller: textEditingController,
    //   keyboardType: TextInputType.phone,
    //   cursorColor: Color(0xff396FB4),
    //   decoration: InputDecoration(
    //       prefix: Text('+',
    //           style: GoogleFonts.roboto(color: Colors.black)),
    //       contentPadding: EdgeInsets.symmetric(
    //           horizontal: width / (360 / 16),
    //           vertical: height / (724 / 18)),
    //       focusedBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(10),
    //           borderSide: BorderSide(
    //             style: BorderStyle.solid,
    //             color: Color(0xff8F4BCF),
    //             width: 1,
    //           )),
    //       enabledBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(10),
    //           borderSide: BorderSide(
    //             style: BorderStyle.solid,
    //             color: Color(0xff898989),
    //             width: 1,
    //           )),
    //       disabledBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(10),
    //           borderSide: BorderSide(
    //             style: BorderStyle.solid,
    //             color: Color(0xff8F4BCF),
    //             width: 1,
    //           )),
    //       border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(10),
    //           borderSide: BorderSide(
    //             style: BorderStyle.solid,
    //             color: Color(0xff8F4BCF),
    //             width: 1,
    //           )),
    //       labelText: 'Номер телефона',
    //       labelStyle: GoogleFonts.roboto(
    //           fontWeight: FontWeight.w400,
    //           fontSize: height / (724 / 12),
    //           color: isFocused ? Color(0xff396FB4) : Color(0xff898989))),
    // );
  }
}