import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _scrollController = ScrollController();
  ContactBloc _contactBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _contactBloc = context.read<ContactBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if(state.status == ContactStatus.failure){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Could not handle contacts')));
        }
      },
      builder: (context, state) {
        return ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, int index) {
                  if (index == 0) {
                    return ActionsContainer(
                      onTap: (CreationActions action) {
                        print('Click ');
                      },
                    );
                  } else if (index == 1) {
                    return CellHeaderView(title: 'Ваши контакты: ${state.contacts.length}');
                  } else {
                    return index >= state.contacts.length ? 
                    CellShimmerItem(circleSize: 35,) : 
                    ContactCell(contactItem: state.contacts[index-1]);
                  }
                }, 
                separatorBuilder: (context, int index) {
                  if (index > 1) {
                    return Divider();
                  } else {
                    return Container();
                  }
                }, itemCount: state.hasReachedMax
                      ? state.contacts.length
                      : state.contacts.length + 4,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isPaginated) _contactBloc.add(ContactFetched());
  }

  bool get _isPaginated {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.7);
  }
}