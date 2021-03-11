import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../widgets/contcats_list.dart';
import 'package:easy_localization/easy_localization.dart';

class CreationModuleScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreationModuleScreen());
  }

  @override
  State<StatefulWidget> createState() {
    return _CreationModuleScreenState();
  }
}

class _CreationModuleScreenState extends State<CreationModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'create'.tr(),
          style: AppFontStyles.headingTextSyle,
        ),
      ),
      body: ContactsList(),
    );
  }
}
