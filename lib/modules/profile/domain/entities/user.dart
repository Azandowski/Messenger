import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String phoneNumber;
  final String profileImage;

  User({
    this.name, 
    this.phoneNumber, 
    this.profileImage
  });

  @override
  List<Object> get props => [name, phoneNumber, profileImage];
}