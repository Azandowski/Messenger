import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../core/widgets/independent/small_widgets/chat_count_view.dart';
import '../../domain/entities/contact.dart';
import '../bloc/contact_bloc/contact_bloc.dart';
import 'contact_cell.dart';
import 'package:easy_localization/easy_localization.dart';

enum ContactsMode { showPeople, showMyContacts }

class ContactsList extends StatefulWidget {
  
  final ContactsMode mode;
  final bool isScrollable;
  final Function(ContactEntity) didSelectContactToChat; 
  final Function(ContactEntity) onTapContact;

  ContactsList({ 
    this.isScrollable = true,
    this.didSelectContactToChat,
    this.mode = ContactsMode.showMyContacts,
    this.onTapContact
  });

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
    _contactBloc = BlocProvider.of<ContactBloc>(context);
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.status == ContactStatus.failure){
          SnackUtil.showError(
            context: context, 
            message: 'could_not_handle_contacts'.tr()
          );
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
                  title: widget.mode == ContactsMode.showMyContacts ?
                    'contacts_count'.tr(namedArgs: {
                      'count': '${state.maxTotal}'
                    }) : 'your_contacts_count'.tr(
                      namedArgs: {
                        'count': '${state.contacts.length}'
                      }
                    )
                );
              } else {
                return index >= state.contacts.length + 1 ? 
                  CellShimmerItem(circleSize: 35,) : 
                    ContactCell(
                      contactItem: state.contacts[index - 1],
                      onTrilinIconTapped: () async {
                        if (widget.didSelectContactToChat != null) {
                          widget.didSelectContactToChat(state.contacts[index - 1]);
                        }
                      },
                      onTap: () {
                        if (widget.onTapContact != null) {
                          widget.onTapContact(state.contacts[index - 1]);
                        }
                      }
                    );
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