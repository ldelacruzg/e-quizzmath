class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String type;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    this.type = '',
  });

  get fullName => '$firstName $lastName';
}
