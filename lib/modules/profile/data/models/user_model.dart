import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

class UserModel extends User {
  final String name;
  final String surname;
  final String patronym;
  final String phoneNumber;
  final String profileImage;

  UserModel({
    this.name, 
    this.surname,
    this.patronym,
    this.phoneNumber, 
    this.profileImage
  }) : super(
    name: name,
    surname: surname,
    patronym: patronym,
    phoneNumber: phoneNumber,
    profileImage: profileImage
  );

  factory UserModel.fromJson(Map<String, dynamic> json) { 
    return UserModel(
      name: json['name'],
      surname: json['surname'],
      patronym: json['patronym'],
      phoneNumber: json['phone'],
      profileImage: json['profile_image']
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'surname': surname,
      'patronym': patronym,
      'phone': phoneNumber,
      'profile_image': profileImage
    };
  }
}