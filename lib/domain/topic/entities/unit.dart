class Unit {
  String id;
  String title;
  String description;
  List<String> playlist;

  Unit({
    this.id = '',
    required this.title,
    required this.description,
    this.playlist = const [],
  });

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      playlist: List<String>.from(map['playlist']),
    );
  }
}
