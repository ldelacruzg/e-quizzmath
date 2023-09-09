class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;
  final String? type;

  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.type,
  });

  toJS() {
    return {
      "FullName": firstName,
      "LastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
      "type": type,
    };
  }
}
