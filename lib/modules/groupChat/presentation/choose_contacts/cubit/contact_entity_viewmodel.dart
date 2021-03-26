import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ContactEntityViewModel {
  final ContactEntity contactEntity;
  final bool isSelected;

  ContactEntityViewModel({
    @required this.contactEntity,
    this.isSelected = false
  });

  ContactEntityViewModel copyWith ({
    bool isSelected,
    ContactEntity contactEntity
  }) {
    return ContactEntityViewModel(
      isSelected: isSelected ?? this.isSelected,
      contactEntity: contactEntity ?? this.contactEntity.copyWith()
    );
  }
}