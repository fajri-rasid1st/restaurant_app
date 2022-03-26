class Food {
  final String name;
  final String imgUrl;

  const Food({required this.name, required this.imgUrl});

  factory Food.fromMap(Map<String, dynamic> food) {
    return Food(
      name: food['name'] ?? '',
      imgUrl: food['imgUrl'] ?? '',
    );
  }
}
