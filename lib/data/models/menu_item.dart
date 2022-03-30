class MenuItem {
  final String name;

  MenuItem({required this.name});

  /// Constructor untuk membuat objek MenuItem dari bentuk map
  /// (hasil parsing json)
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(name: map['name'] ?? '');
  }
}
