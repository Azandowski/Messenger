import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../core/widgets/independent/small_widgets/chat_count_view.dart';
import '../../../groupChat/presentation/create_group/create_group_page.dart';
import '../bloc/contact_bloc/contact_bloc.dart';
import '../helpers/creation_actions.dart';
import 'actions_builder.dart';
import 'contact_cell.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/helpers/creation_actions.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/actions_builder.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contact_cell.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final _scrollController = PaginatedScrollController();
  ContactBloc _contactBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _contactBloc = context.read<ContactBloc>();
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.status == ContactStatus.failure) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Could not handle contacts')));
        }
      },
      builder: (_, state) {
        return RefreshIndicator(
          onRefresh: () async {
            _contactBloc.add(RefreshContacts());
          },
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, int index) {
              if (index == 0) {
                return ActionsContainer(
                  onTap: (CreationActions action) {
                    actionProcess(action, context);
                  },
                );
              } else if (index == 1) {
                return CellHeaderView(
                    title: 'yourContacts'
                        .tr(args: [state.contacts.length.toString()]));
              } else {
                return index >= state.contacts.length + 2
                    ? CellShimmerItem(
                        circleSize: 35,
                      )
                    : ContactCell(contactItem: state.contacts[index - 2]);
              }
            },
            separatorBuilder: (context, int index) =>
                _buildSeparationFor(index: index),
            itemCount: state.status != ContactStatus.loading
                ? state.contacts.length + 2
                : state.contacts.length + 6,
          ),
        );
      },
    );
  }

  // * * UI Helpers

  Widget _buildSeparationFor({@required int index}) {
    if (index > 1) {
      return Divider();
    } else {
      return Container();
    }
  }

  // * * Actions

  Future<void> actionProcess(
      CreationActions action, BuildContext context) async {
    switch (action) {
      case CreationActions.createGroup:
        Navigator.pushNamed(context, CreateGroupPage.id);
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
          text: 'downloadAIO'.tr(),
          linkUrl: 'https://messengeraio.page.link/invite',
        );
        break;
    }
  }

  // * * Life-Cycle

  @override
  void dispose() {
    _scrollController.dispose();
    _contactBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.isPaginated) {
      if (_contactBloc.state.status != ContactStatus.loading) {
        _contactBloc.add(ContactFetched());
      }
    }
  }
}
