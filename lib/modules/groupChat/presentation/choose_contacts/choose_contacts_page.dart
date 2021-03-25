import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'choose_contacts_screen.dart';
import 'cubit/choosecontact_cubit.dart';

class ChooseContactsPage extends StatefulWidget {
  final ContactChooseDelegate delegate;
  final bool isSingleSelect;
  static var id = 'choosecontactspage';

  static Route route(ContactChooseDelegate delegate, { bool isSingleSelect }) {
    return MaterialPageRoute<void>(builder: (_) => ChooseContactsPage(
      delegate: delegate,
      isSingleSelect: isSingleSelect ?? false
    ));
  }

  const ChooseContactsPage({
    @required this.delegate,
    this.isSingleSelect = false
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
      child: ChooseContactsScreen(
        delegate: widget.delegate,
        isSingleSelect: widget.isSingleSelect
      ),
    );
  }
}