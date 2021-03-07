import 'package:bloc/bloc.dart';

import '../../../../creation_module/domain/entities/contact.dart';


class ChooseContactCubit extends Cubit<List<ContactEntity>> {
  final List<ContactEntity> contactList;
  ChooseContactCubit({
    this.contactList,
  }) : super([]){
    emit(contactList ?? []);
  }

  void addContact(ContactEntity newContact){
   List<ContactEntity> list = state.map((e) => e.copyWith()).toList();
   list.add(newContact.copyWith(
     id: newContact.id,
     name: newContact.name,
     avatar: newContact.avatar,
     surname: newContact.surname,
     patronym: newContact.patronym,
     lastVisit: newContact.lastVisit
   ));
   emit(list);
  }

  void removeContact(ContactEntity newContact){
   List<ContactEntity> list = state.map((e) => e.copyWith()).toList();
   list.remove(newContact.copyWith(
     id: newContact.id,
     name: newContact.name,
     avatar: newContact.avatar,
     surname: newContact.surname,
     patronym: newContact.patronym,
     lastVisit: newContact.lastVisit
   ));
   emit(list);
  }
}
