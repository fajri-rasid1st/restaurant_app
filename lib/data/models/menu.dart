import 'package:restaurant_app/data/models/item_menu.dart';

class Menu {
  final List<ItemMenu> foods;
  final List<ItemMenu> drinks;

  Menu({required this.foods, required this.drinks});

  /// Constructor untuk membuat objek Menu dari bentuk map (hasil parsing json)
  factory Menu.fromMap(Map<String, dynamic> menu) {
    return Menu(
      foods: List<ItemMenu>.from(menu['foods']?.map((food) {
        return ItemMenu.fromMap(food);
      })),
      drinks: List<ItemMenu>.from(menu['drinks']?.map((drink) {
        return ItemMenu.fromMap(drink);
      })),
    );
  }
}
