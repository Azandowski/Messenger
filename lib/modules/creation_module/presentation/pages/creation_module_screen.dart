import 'package:flutter/material.dart';

import '../../../../app/appTheme.dart';
import '../widgets/contcats_list.dart';

class CreationModuleScreen extends StatefulWidget {
  
  @override
  _CreationModuleScreenState createState() => _CreationModuleScreenState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreationModuleScreen());
  }
}

class _CreationModuleScreenState extends State<CreationModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Создать',
            style: AppFontStyles.headingTextSyle,
          ),
        ),
        body: ContactsList(),
      );
  }
}