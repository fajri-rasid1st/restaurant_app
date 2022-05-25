class ItemMenu {
  final String name;

  ItemMenu({required this.name});

  /// Constructor untuk membuat objek ItemMenu dari bentuk map
  /// (hasil parsing json)
  factory ItemMenu.fromMap(Map<String, dynamic> itemMenu) {
    return ItemMenu(name: itemMenu['name'] ?? '');
  }
}
