import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/bottom_action_button.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/gradient_main_button.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/image_text_view.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/pages/search_contact/search_contact_page.dart';
import '../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../core/utils/snackbar_util.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../locator.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../../creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import '../../../creation_module/presentation/widgets/contact_cell.dart';
import 'cubit/choosecontact_cubit.dart';
import 'cubit/contact_entity_viewmodel.dart';

abstract class ContactChooseDelegate{
  void didSaveContacts(List<ContactEntity> contacts);
}

class ChooseContactsScreen extends StatefulWidget {

  final ContactChooseDelegate delegate;
  final bool isSingleSelect;
  final List<int> excludeContactsIDS;

  ChooseContactsScreen({
    @required this.delegate,  
    @required this.isSingleSelect,
    this.excludeContactsIDS
  });

  @override
  _ChooseContactsScreenState createState() => _ChooseContactsScreenState();
}


class _ChooseContactsScreenState extends State<ChooseContactsScreen> implements SearchContactDelegate {
  
  // * * Props
  
  ContactBloc _contactBloc;
  NavigatorState get _navigator => sl<Application>().navKey.currentState;
  final _scrollController = PaginatedScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _contactBloc = context.read<ContactBloc>();    
    context.read<ChooseContactCubit>().injectUserContacts(
      _contactBloc.state.contacts,
      excludeContactsIDS: widget.excludeContactsIDS
    );
  }

  // * * UI

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseContactCubit, List<ContactEntityViewModel>>(
      builder: (context, contacts) {
        return BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state.status == ContactStatus.failure) {
              SnackUtil.showError(context: context, message: 'could_not_handle_contacts'.tr());
            } else if (state.status == ContactStatus.success) {
              context.read<ChooseContactCubit>().injectUserContacts(
                state.contacts,
                excludeContactsIDS: widget.excludeContactsIDS
              );
            }
          },
          builder: (_, state) { 
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'selected_count'.tr(namedArgs: {
                    'count': '${contacts.where((e) => e.isSelected).length}'
                  })
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _navigator.push(SearchContactPage.route(
                        initialContacts: context.read<ContactBloc>().state.contacts,
                        delegate: this
                      ));
                    },
                  )
                ],
              ),
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: state.hasReachedMax && contacts.length == 0 ? 
                        _buildEmptyScreen() : 
                        ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (context, int index) {
                            var isSelected = false; 
                            var _blocChoose = context.read<ChooseContactCubit>();

                            if (index < contacts.length) {
                              isSelected = contacts[index].isSelected;
                            }

                            return (
                              index >= contacts.length 
                                || state.status == ContactStatus.loading ) ? 
                              CellShimmerItem(circleSize: 35) : 
                                ContactCell(
                                  contactItem: contacts[index].contactEntity,
                                  cellType: ContactCellType.add,
                                  isSelected: isSelected,
                                  onTap:() {
                                    if (isSelected) {
                                      _blocChoose.removeContact(contacts[index].contactEntity);
                                    } else {
                                      _blocChoose.addContact(contacts[index].contactEntity, widget.isSingleSelect);
                                    }
                                  },
                                );
                          }, 
                          separatorBuilder: (context, int index) {
                            return Divider();
                          }, 
                          itemCount: state.hasReachedMax ? 
                            contacts.length : contacts.length + 4
                        ),
                    ),
                    if (state.status == ContactStatus.success)  
                      BottomActionButtonContainer(
                        onTap: () {
                          Navigator.pop(context);
                          widget.delegate.didSaveContacts(
                            contacts.where((e) => e.isSelected).map((e) => e.contactEntity)
                          .toList());
                        }, 
                        title: 'ready'.tr()
                      )
                  ],
                ),
              )
            );
          }
        );
      }
    );
  }

  Widget _buildEmptyScreen () {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmptyView(
            text: 'no_contacts'.tr()
          ),
          SizedBox(height: 20),
          ActionButton(
            text: 'invite_friends'.tr(), 
            onTap: () async {
              await FlutterShare.share(
                title: 'AIO Messenger',
                text: 'invite_friends_hint'.tr(),
                linkUrl: 'https://messengeraio.page.link/invite'
              );
            }
          )
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.isPaginated) _contactBloc.add(ContactFetched());
  }

  @override
  void didSelectContact(ContactEntity contact) {
    Navigator.of(context).pop();
    var _blocChoose = context.read<ChooseContactCubit>();
    _blocChoose.addContact(contact, widget.isSingleSelect);
  }
}

