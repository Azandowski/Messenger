import 'package:equatable/equatable.dart';
class Contact extends Equatable{
  int id;
  String name;
  String surname;
  String patronym;
  String avatar;
  DateTime lastVisit;

  Contact(
      {this.id,
      this.name,
      this.surname,
      this.patronym,
      this.avatar,
      this.lastVisit});

  @override
  List<Object> get props => [id,name,surname,patronym,avatar,lastVisit];
}