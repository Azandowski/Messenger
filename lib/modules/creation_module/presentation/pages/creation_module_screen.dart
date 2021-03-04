import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contcats_list.dart';

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
    return BlocProvider(
      create: (context) => ContactBloc(fetchContacts: sl(), httpClient: sl())..add(ContactFetched()),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Создать',
              style: AppFontStyles.headingTextSyle,
            ),
          ),
          body: ContactsList(),
        ),
    );
  }
}