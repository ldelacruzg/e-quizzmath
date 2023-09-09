class Class {
  final String id;
  final String code;
  final String title;

  Class({
    required this.id,
    required this.code,
    required this.title,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      code: json['code'],
      title: json['title'],
    );
  }
}
