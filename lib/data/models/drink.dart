class Drink {
  final String name;
  final String imgUrl;

  const Drink({required this.name, required this.imgUrl});

  /// constructor untuk membuat objek Drink dari bentuk Map (hasil parsing json)
  factory Drink.fromMap(Map<String, dynamic> drink) {
    return Drink(
      name: drink['name'] ?? '',
      imgUrl: drink['imgUrl'] ?? '',
    );
  }
}
