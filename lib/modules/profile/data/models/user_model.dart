import '../../../../core/services/network/config.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  final String name;
  final String surname;
  final String patronym;
  final String phoneNumber;
  final String profileImage;
  final int id;
  final bool isBlocked;
  final String status;

  UserModel(
      {this.name,
      this.surname,
      this.patronym,
      this.phoneNumber,
      this.id,
      this.profileImage,
      this.isBlocked,
      this.status})
      : super(
            name: name,
            surname: surname,
            patronym: patronym,
            phoneNumber: phoneNumber,
            id: id,
            profileImage: profileImage,
            isBlocked: isBlocked,
            status: status);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        surname: json['surname'],
        patronym: json['patronym'],
        phoneNumber: json['phone'],
        id: json['id'],
        profileImage: json['avatar'] != null
            ? (json['avatar'] as String).contains('://')
                ? json['avatar']
                : ConfigExtension.buildURLHead() + json['avatar']
            : null,
        isBlocked: json['isBlocked'] == 1,
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'surname': surname,
      'patronym': patronym,
      'phone': phoneNumber,
      'avatar': profileImage,
      'isBlocked': isBlocked ? 1 : 0,
      'status': status
    };
  }
}
