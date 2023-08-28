class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
  });
}
