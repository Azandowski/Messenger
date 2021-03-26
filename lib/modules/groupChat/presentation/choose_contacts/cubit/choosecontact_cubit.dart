import 'package:bloc/bloc.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/choose_contacts/cubit/contact_entity_viewmodel.dart';
import '../../../../creation_module/domain/entities/contact.dart';


class ChooseContactCubit extends Cubit<List<ContactEntityViewModel>> {
  
  final List<ContactEntityViewModel> contactsList;
  
  ChooseContactCubit({
    this.contactsList,
  }) : super([]){
    emit(contactsList ?? []);
  }

  /// Пользователь выбрал контакт
  /// Если мод выборки только одного [isSingleSelect] контакта то 
  /// в массиве будет только один элемент, [newContact] - это контак который должен был быть выбран
  void addContact (
    ContactEntity newContact, 
    bool isSingleSelect
  ) {
    List<ContactEntityViewModel> newContactsList = state.map((e) => e.copyWith()).toList();
    var indexOfContact = newContactsList.indexWhere((e) => e.contactEntity.id == newContact.id);
    
    if (indexOfContact == -1) {
      var contactEntityViewModel = ContactEntityViewModel(
        isSelected: true,
        contactEntity: newContact.copyWith()
      );

      if (!isSingleSelect) { 
        newContactsList.insert(0, contactEntityViewModel);
      } else {
        newContactsList = [contactEntityViewModel];
      }
    } else {
      newContactsList[indexOfContact] = newContactsList[indexOfContact].copyWith(
        isSelected: true
      );
    }
   
    emit(newContactsList);
  }


  /// Удалить выборку с контакта [oldContact]
  void removeContact(ContactEntity oldContact){
    List<ContactEntityViewModel> newContactsList = state.map((e) => e.copyWith()).toList();
    var indexOfContact = newContactsList.indexWhere((e) => e.contactEntity.id == oldContact.id);

    if (indexOfContact != -1) {
      newContactsList[indexOfContact] = newContactsList[indexOfContact].copyWith(isSelected: false);
    }

    emit(newContactsList);
  }


  void injectUserContacts (List<ContactEntity> contacts) {
    List<ContactEntityViewModel> newContactsList = state.map((e) => e.copyWith()).toList();
    contacts.forEach((contact) {
      var indexOfContact = newContactsList.indexWhere((e) => e.contactEntity.id == contact.id);

      if (indexOfContact == -1) {
        newContactsList.add(ContactEntityViewModel(
          contactEntity: contact
        ));
      }
    });

    emit(newContactsList);
  }
}