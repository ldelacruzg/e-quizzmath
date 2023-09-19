class Class {
  String id;
  String code;
  String title;
  String description;

  Class({
    this.id = '',
    this.code = '',
    required this.title,
    required this.description,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'code': code,
    };
  }
}
