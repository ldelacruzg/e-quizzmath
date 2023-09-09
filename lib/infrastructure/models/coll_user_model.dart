import 'package:e_quizzmath/domain/user/entities/user.dart';

class UserModel extends User {
  final String id;

  UserModel({
    required this.id,
    required String firstName,
    required String lastName,
    required String email,
    String phone = '',
    String type = '',
  }) : super(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          type: type,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['FullName'],
      lastName: json['LastName'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FullName': firstName,
      'LastName': lastName,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }

  User toUserEntity() {
    return User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      type: type,
    );
  }
}
