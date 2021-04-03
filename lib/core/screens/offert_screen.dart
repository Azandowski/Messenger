import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
class OffertView extends StatelessWidget {
  final OffertType type;

  const OffertView({
    @required this.type,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.title),
        backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: Container(
        child: PdfView(
          controller: PdfController(
            document:  PdfDocument.openAsset(type.path)
          ),
        )
      )
    );
  }
}

enum OffertType {
  agent, offert, personalData
}

extension OffertDataExtension on OffertType {
  String get path {
    switch (this) {
      case OffertType.agent:
        return 'assets/docs/superwork_agent.pdf';
      case OffertType.offert:
        return 'assets/docs/superwork_offert.pdf';
      case OffertType.personalData:
        return 'assets/docs/personal_data.pdf';
    }
  }

  String get title {
    if (this == OffertType.offert || this == OffertType.agent) {
      return 'contract'.tr();
    } else {
      return 'agreement'.tr();
    }
  }
}