class Food {
  final String name;
  final String imgUrl;

  const Food({required this.name, required this.imgUrl});

  // constructor untuk membuat objek Food dari bentuk Map (hasil parsing json)
  factory Food.fromMap(Map<String, dynamic> food) {
    return Food(
      name: food['name'] ?? '',
      imgUrl: food['imgUrl'] ?? '',
    );
  }
}
