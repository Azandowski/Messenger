import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

class UserModel extends User {
  final String name;
  final String phoneNumber;
  final String profileImage;
  User user;

  UserModel({
    this.name, 
    this.phoneNumber, 
    this.profileImage
  }) : super(
    name: name,
    phoneNumber: phoneNumber,
    profileImage: profileImage
  );

  factory UserModel.fromJson(Map<String, dynamic> json) { 
    return UserModel(
      name: json['name'],
      phoneNumber: json['number'],
      profileImage: json['profile_image']
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'number': phoneNumber,
      'profile_image': profileImage
    };
  }
}