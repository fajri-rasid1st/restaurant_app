class Category {
  final String name;

  Category({required this.name});

  /// Constructor untuk membuat objek Category dari bentuk map
  /// (hasil parsing json)
  factory Category.fromMap(Map<String, dynamic> category) {
    return Category(name: category['name'] ?? '');
  }
}
