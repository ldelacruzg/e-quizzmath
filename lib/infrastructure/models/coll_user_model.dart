import 'package:e_quizzmath/domain/user/entities/user.dart';

class UserModel extends User {
  final String id;

  UserModel({
    required this.id,
    required String firstName,
    required String lastName,
    required String email,
    String phone = '',
  }) : super(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['FullName'],
      lastName: json['LastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FullName': firstName,
      'LastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  User toUserEntity() {
    return User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }
}
