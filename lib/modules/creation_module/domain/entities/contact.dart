import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactEntity extends Equatable{
  final int id;
  final String name;
  final String surname;
  final String patronym;
  final String avatar;
  final DateTime lastVisit;

  ContactEntity({
    this.id,
    this.name,
    this.surname,
    this.patronym,
    this.avatar,
    this.lastVisit
  });

  String get fullName {
    var fullname = [surname, name, patronym]
      .where((e) => e != null && e != "")
      .join(" ");

    return fullname.trim() == '' ? 'anonymous'.tr() : fullname;
  }

  @override
  List<Object> get props => [id,name,surname,patronym,avatar,lastVisit];

  ContactEntity copyWith({
    int id,
    String name,
    String surname,
    String patronym,
    String avatar,
    DateTime lastVisit,
  }) {
    return ContactEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      patronym: patronym ?? this.patronym,
      avatar: avatar ?? this.avatar,
      lastVisit: lastVisit ?? this.lastVisit,
      surname: surname ?? this.surname,
    );
  }
}