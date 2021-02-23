import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String surname;
  final String patronym;
  final String phoneNumber;
  final String profileImage;

  User(
      {this.name,
      this.surname,
      this.patronym,
      this.phoneNumber,
      this.profileImage});

  @override
  List<Object> get props =>
      [name, surname, patronym, phoneNumber, profileImage];

  static const empty = null;

  String get fullName {
    return [surname, name, patronym]
        .where((e) => e != null && e != "")
        .join(" ");
  }
}
