import 'package:flutter/material.dart';

import '../../../../creation_module/domain/entities/contact.dart';

class ContactViewModel{
  final ContactEntity entity;
  bool isSelected;

  ContactViewModel({
    @required this.entity
    }); 
}