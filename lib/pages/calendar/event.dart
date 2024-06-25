class Event {
  final int? id;
  final String category;
  final String title;
  final DateTime date;

  const Event(
      {required this.category,
      required this.title,
      required this.date,
      this.id});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        category: json['category'],
        title: json['title'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'date': date.toIso8601String(),
      };
}
