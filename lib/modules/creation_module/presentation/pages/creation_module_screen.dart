import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import '../../../../app/appTheme.dart';
import '../../../../app/application.dart';
import '../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../locator.dart';
import '../../../chat/presentation/chat_details/page/chat_detail_page.dart';
import '../../../chat/presentation/chat_details/page/chat_detail_screen.dart';
import '../../../groupChat/domain/usecases/create_chat_group.dart';
import '../../../groupChat/presentation/create_group/create_group_page.dart';
import '../bloc/contact_bloc/contact_bloc.dart';
import '../bloc/open_chat_cubit/open_chat_cubit.dart';
import '../bloc/open_chat_cubit/open_chat_listener.dart';
import '../helpers/creation_actions.dart';
import '../widgets/actions_builder.dart';
import '../widgets/contcats_list.dart';
import 'search_contact/search_contact_page.dart';


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
  
  // MARK: - Props

  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  PaginatedScrollController _scrollController = PaginatedScrollController();
  OpenChatListener _openChatListener = OpenChatListener();

  // MARK: - Life-Cycle

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    context.read<ContactBloc>().add(ContactFetched());
    super.initState();
  }

  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Создать',
          style: AppFontStyles.headingTextSyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search
            ), 
            onPressed: () {
              _navigator.push(SearchContactPage.route(
                initialContacts: context.read<ContactBloc>().state.contacts
              ));
            }
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => OpenChatCubit(
          createChatGruopUseCase: sl<CreateChatGruopUseCase>()
        ),
        child: BlocConsumer<OpenChatCubit, OpenChatState>(
          listener: (context, state) {
            _openChatListener.handleStateUpdate(context, state);
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
                        context.read<OpenChatCubit>().createChatWithUser(contact.id);
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