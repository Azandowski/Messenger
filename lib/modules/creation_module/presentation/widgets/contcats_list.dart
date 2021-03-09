import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';

import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../core/widgets/independent/small_widgets/chat_count_view.dart';
import '../bloc/contact_bloc/contact_bloc.dart';
import 'contact_cell.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contact_cell.dart';

class ContactsList extends StatefulWidget {
  
  final bool isScrollable;

  ContactsList({ this.isScrollable = true });

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
        if(state.status == ContactStatus.failure){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Could not handle contacts')));
        }
      },
      builder: (_, state) {
        return RefreshIndicator(
          onRefresh: () async {
            _contactBloc.add(RefreshContacts());
          },
          child: ListView.separated(
            physics: widget.isScrollable ? BouncingScrollPhysics() : 
              NeverScrollableScrollPhysics(),
            shrinkWrap: !widget.isScrollable,
            controller: _scrollController,
            itemBuilder: (context, int index) {
              if (index == 0) {
                return CellHeaderView(
                  title: 'Ваши контакты: ${state.contacts.length}'
                );
              } else {
                return index >= state.contacts.length + 1 ? 
                  CellShimmerItem(circleSize: 35,) : 
                    ContactCell(contactItem: state.contacts[index - 1]);
              }
            }, 
            separatorBuilder: (context, int index) => Divider(), 
            itemCount: state.status != ContactStatus.loading ? 
              state.contacts.length + 1 : state.contacts.length + 6,
          ),
        );
      },
    );
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