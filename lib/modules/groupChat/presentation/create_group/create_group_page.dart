import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../choose_contacts/cubit/choosecontact_cubit.dart';
import '../../../../locator.dart';
import 'create_group_screen.dart';
import 'cubit/creategroup_cubit.dart';

class CreateGroupPage extends StatefulWidget {
  static var id = 'creategrouppage';
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CreateGroupCubit(
          getImageUseCase: sl(),
          createChatGruopUseCase: sl())),
        BlocProvider(create: (_) => ChooseContactCubit()),
      ],  
      child: Scaffold(
        appBar: AppBar(
          title: Text('Создать категорию'),
        ),
        body: CreateGroupScreen(),
      ),
    );
  }
}