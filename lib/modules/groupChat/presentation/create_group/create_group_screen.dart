import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import '../../../creation_module/presentation/widgets/contact_cell.dart';
import '../choose_contacts/choose_contacts_page.dart';
import '../../../../core/widgets/independent/buttons/bottom_action_button.dart';
import '../../../../core/widgets/independent/pickers/photo_picker.dart';
import '../../../../main.dart';
import '../../../../core/widgets/independent/small_widgets/chat_count_view.dart';
import '../../../category/domain/entities/create_category_screen_params.dart';
import '../../../chats/domain/entities/category.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../choose_contacts/choose_contacts_screen.dart';
import '../choose_contacts/models/contact_view_model.dart';
import 'cubit/creategroup_cubit.dart';
import 'widgets/create_group_header.dart';

class CreateGroupScreen extends StatefulWidget {
  static final String id = 'create_group';

  final CreateGroupScreenMode mode;
  final ChatEntity entity;

  CreateGroupScreen({
    this.mode = CreateGroupScreenMode.create, 
    this.entity,
    Key key, 
  }) : super(key: key) {
    if (mode == CreateGroupScreenMode.edit) {
      assert(entity != null, 'entity of edit model should not be null');
    }
  }

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

// * * State

class _CreateGroupScreenState extends State<CreateGroupScreen> implements ContactChooseDelegate {
  NavigatorState get _navigator => navigatorKey.currentState;
  
  CreateGroupCubit _groupCubit;
  List<ContactViewModel> contacts = [];
  TextEditingController _nameController;
  TextEditingController _descriptionController;

  _CreateGroupScreenState();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _groupCubit = context.read<CreateGroupCubit>();

    if (widget.entity != null) {
      _nameController.text = widget.entity.title ?? '';
      _descriptionController.text = widget.entity.description ?? '';
      _groupCubit.initReadyEntity(widget.entity);
    }  
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateGroupCubit, CreateGroupState>(
      cubit: _groupCubit,
      listener: (context, state) {
        if (state is CreateCategoryError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(color: Colors.red)),
            ), // SnackBar
          );
        } else if (state is CreateGroupSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is CreateGroupNormal) {
          contacts = (state.contacts ?? []).map((e) => ContactViewModel(entity: e)).toList();
        }
      },
      builder: (_, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30),
                    CreateGroupHeader(
                      descriptionController: _descriptionController,
                      nameController: _nameController,
                      imageProvider: state.imageFile != null ? 
                        FileImage(state.imageFile) : _groupCubit.defaultImageUrl != null ? 
                          NetworkImage(_groupCubit.defaultImageUrl) : null,
                      selectImage: (file) {
                        PhotoPicker().showImageSourceSelectionDialog(context,
                          (imageSource) {
                            _groupCubit.selectPhoto(imageSource);
                          });
                      },
                      onAddContacts: () {
                        Navigator.of(context).push(ChooseContactsPage.route(this));
                      },
                    ),

                    if (widget.mode == CreateGroupScreenMode.create)
                      ...[
                        CellHeaderView(
                          title: 'Участники: ${state is CreateGroupContactsLoading ? "Загрузка ,,," : (contacts ?? []).length }'
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i){
                              var contact = contacts[i].entity;
                              return ContactCell(contactItem: contact, cellType: ContactCellType.delete,onTrilinIconTapped: (){
                                _groupCubit.deleteContact(contact);
                              },);
                            },
                            itemCount: contacts.length,
                          ),
                        )
                      ]
                  ],
                ),
              ),
              BottomActionButtonContainer(
                title: 'Готово',
                isLoading: state is CreateGroupLoading,
                onTap: () {
                  _groupCubit.createChat(
                    _nameController.text, 
                    _descriptionController.text,
                    isCreate: widget.mode == CreateGroupScreenMode.create,
                    chatID: widget.mode == CreateGroupScreenMode.edit ? 
                      widget.entity.chatId : null
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }


  @override
  void didSaveChats(List<ContactEntity> contacts) {
    _groupCubit.addContacts(contacts);
  }
}


enum CreateGroupScreenMode {
  edit, create
}

extension CreateGroupScreenModeUIExtension on CreateGroupScreenMode {
  String get title {
    switch (this) {
      case CreateGroupScreenMode.edit:
        return 'Редактировать';
      case CreateGroupScreenMode.create:
        return 'Создать чат';
    }
  }
}