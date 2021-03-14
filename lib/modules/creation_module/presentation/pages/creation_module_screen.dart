import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/creation_module_cubit/creation_module_cubit.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/helpers/creation_actions.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/actions_builder.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/create_chat_group.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/appTheme.dart';
import '../../../../locator.dart';
import '../../../../main.dart';
import '../widgets/contcats_list.dart';


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
  
  PaginatedScrollController _scrollController = PaginatedScrollController();

  NavigatorState get _navigator => navigatorKey.currentState;


  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    context.read<ContactBloc>().add(ContactFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Создать',
          style: AppFontStyles.headingTextSyle,
        ),
      ),
      body: BlocProvider(
        create: (context) => CreationModuleCubit(
          createChatGruopUseCase: sl<CreateChatGruopUseCase>()
        ),
        child: BlocConsumer<CreationModuleCubit, CreationModuleState>(
          listener: (context, state) {
            if (state is CreationModuleLoading) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                SnackBar(
                  content: LinearProgressIndicator(), 
                  duration: Duration(days: 2),
                )
              );
            } else if (state is CreationModuleError){
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(
                  state.message
                )));
            } else if (state is OpenChatWithUser) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatScreen(
                  chatEntity: state.newChat
                )),
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActionsContainer(
                      onTap: (CreationActions action) {
                        actionProcess(action, context);
                      },
                    ),
                    ContactsList(
                      isScrollable: false,
                      didSelectContactToChat: (contact) {
                        context.read<CreationModuleCubit>().createChatWithUser(contact.id);
                      },
                    )
                  ],
                )
              ),
            );
          },
        ),
      ),
    );
  }

    // * * Actions

  Future<void> actionProcess(
    CreationActions action, 
    BuildContext context
  ) async {
    switch (action){
      case CreationActions.createGroup:
        _navigator.push(CreateGroupPage.route());
        break;
      case CreationActions.createSecretChat:
        // TODO: Handle this case.
        break;
      case CreationActions.startVideo:
        // TODO: Handle this case.
        break;
      case CreationActions.startLive:
        // TODO: Handle this case.
        break;
      case CreationActions.inviteFriends:
        return await FlutterShare.share(
          title: 'AIO Messenger',
          text: 'Хэй, поскорее скачай мессенджер AIO!',
          linkUrl: 'https://messengeraio.page.link/invite'
        );
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.isPaginated) {
      var _contactBloc = context.read<ContactBloc>();
      
      if (_contactBloc.state.status != ContactStatus.loading) {
        _contactBloc.add(ContactFetched());
      }
    }
  }
}