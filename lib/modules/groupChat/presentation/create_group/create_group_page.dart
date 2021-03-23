import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../choose_contacts/cubit/choosecontact_cubit.dart';
import 'create_group_screen.dart';
import 'cubit/creategroup_cubit.dart';

class CreateGroupPage extends StatefulWidget {

  final CreateGroupScreenMode mode;
  final ChatEntity entity;

  CreateGroupPage({
    @required this.mode,
    @required this.entity 
  });

  static Route route({ CreateGroupScreenMode mode, ChatEntity chatEntity}) {
    return MaterialPageRoute<void>(builder: (_) => CreateGroupPage(
      mode: mode ?? CreateGroupScreenMode.create, entity: chatEntity,
    ));
  }

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState(
    mode: mode, entity: entity
  );
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  
  final CreateGroupScreenMode mode;
  final ChatEntity entity;
  
  _CreateGroupPageState({
    @required this.mode,
    @required this.entity
  });

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
          title: Text(mode.title),
        ),
        body: CreateGroupScreen(
          mode: mode,
          entity: entity,
        ),
      ),
    );
  }
}