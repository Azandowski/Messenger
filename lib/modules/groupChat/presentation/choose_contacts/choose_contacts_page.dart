import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'choose_contacts_screen.dart';
import 'cubit/choosecontact_cubit.dart';

class ChooseContactsPage extends StatefulWidget {
  final ContactChooseDelegate delegate;
  static var id = 'choosecontactspage';

  static Route route(ContactChooseDelegate delegate,) {
    return MaterialPageRoute<void>(builder: (_) => ChooseContactsPage(delegate: delegate,));
  }

  const ChooseContactsPage({
    @required this.delegate,
    });
  @override
  _ChooseContactsPageState createState() => _ChooseContactsPageState();
}

class _ChooseContactsPageState extends State<ChooseContactsPage> {
    @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
           providers: [
             BlocProvider(create: (BuildContext context) => ChooseContactCubit()),
           ],
            child: ChooseContactsScreen(delegate: widget.delegate,),
      );
  }
}