import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/independent/buttons/gradient_main_button.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../../creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import '../../../creation_module/presentation/widgets/contact_cell.dart';
import 'cubit/choosecontact_cubit.dart';

abstract class ContactChooseDelegate {
  void didSaveChats(List<ContactEntity> contacts);
}

class ChooseContactsScreen extends StatefulWidget {
  final ContactChooseDelegate delegate;

  ChooseContactsScreen({
    @required this.delegate,
  });

  @override
  _ChooseContactsScreenState createState() => _ChooseContactsScreenState();
}

class _ChooseContactsScreenState extends State<ChooseContactsScreen> {
  // * * Props

  int _contactsCount = 0;
  ContactBloc _contactBloc;
  // * * Life-Cycle
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _contactBloc = context.read<ContactBloc>();
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseContactCubit, List<ContactEntity>>(
        builder: (context, contacts) {
      return BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
        if (state.status == ContactStatus.failure) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Could not handle contacts')));
        }
      }, builder: (_, state) {
        return Scaffold(
            appBar: AppBar(
              title:
                  Text('selectedChats'.tr(args: [contacts.length.toString()])),
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, int index) {
                      var isSelected = contacts.where(
                          (element) => element.id == state.contacts[index].id);
                      var _blocChoose = context.read<ChooseContactCubit>();
                      return index >= state.contacts.length
                          ? CellShimmerItem(
                              circleSize: 35,
                            )
                          : ContactCell(
                              contactItem: state.contacts[index],
                              cellType: ContactCellType.add,
                              isSelected: isSelected.length > 0,
                              onTap: () {
                                if (isSelected.length > 0) {
                                  _blocChoose
                                      .removeContact(state.contacts[index]);
                                } else {
                                  _blocChoose.addContact(state.contacts[index]);
                                }
                              },
                            );
                    },
                    separatorBuilder: (context, int index) {
                      return Divider();
                    },
                    itemCount: state.hasReachedMax
                        ? state.contacts.length
                        : state.contacts.length + 4),
                if (state.status == ContactStatus.success)
                  Positioned(
                    bottom: 40,
                    child: ActionButton(
                        text: 'addContacts'.tr(),
                        onTap: () {
                          widget.delegate.didSaveChats(contacts);
                          Navigator.pop(context);
                        }),
                  ),
              ],
            ));
      });
    });
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
