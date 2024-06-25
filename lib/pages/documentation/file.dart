class File {
  final int? id;
  final String category;
  final String title;
  final DateTime date;
  final int price;

  const File(
      {required this.category,
      required this.title,
      required this.date,
      required this.price,
      this.id});

  factory File.fromMap(Map map) => File(
        id: map['id'],
        category: map['category'],
        title: map['title'],
        date: DateTime.parse(map['date']),
        price: map['price'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'title': title,
        'date': date.toIso8601String(),
        'price': price,
      };
}
