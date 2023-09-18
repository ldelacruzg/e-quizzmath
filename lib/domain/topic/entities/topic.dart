class Topic {
  String id;
  String title;
  String description;

  Topic({
    this.id = '',
    required this.title,
    required this.description,
  });

  factory Topic.fromJson(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
