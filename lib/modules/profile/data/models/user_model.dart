import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

class UserModel extends User {
  final String name;
  final String phoneNumber;
  final String profileImage;

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
      phoneNumber: json['phone'],
      profileImage: json['profile_image']
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'phone': phoneNumber,
      'profile_image': profileImage
    };
  }
}