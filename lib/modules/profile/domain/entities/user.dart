import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String surname;
  final String patronym;
  final String phoneNumber;
  final String profileImage;
  final int id;
  final bool isBlocked;
  final String status;

  User({
    this.name,
    this.surname,
    this.patronym,
    this.id,
    this.phoneNumber,
    this.profileImage,
    this.isBlocked,
    this.status
  });

  @override
  List<Object> get props => [
    name, 
    surname, 
    patronym, 
    phoneNumber, 
    profileImage,
    id,
    isBlocked,
    status
  ];

  static const empty = null;

  String get fullName {
    return [surname, name, patronym]
      .where((e) => e != null && e != "")
      .join(" ");
  }

  User copyWith ({
    String name,
    String surname,
    String patronym,
    String phoneNumber,
    String profileImage,
    int id,
    bool isBlocked,
    String status
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      patronym: patronym ?? this.patronym,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      isBlocked: isBlocked ?? this.isBlocked,
      status: status ?? this.status
    );
  }
}
