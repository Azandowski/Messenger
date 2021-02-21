import 'package:flutter/material.dart';

class OffertView extends StatelessWidget {
  //TODO Add OffertType Enum if there is multiple types of offerts

  const OffertView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Type Titile"),
        backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: Text('OFFERT'),
      //TODO add PDF VIEW package
      // Container(
      //   child:  Pd(
      //     controller: PdfController(
      //       document:  PdfDocument.openAsset(type.path)
      //     ),
      //   )
      // )
    );
  }
}
