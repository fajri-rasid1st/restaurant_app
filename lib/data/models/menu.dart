import 'package:restaurant_app/data/models/menu_item.dart';

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  /// Constructor untuk membuat objek Menu dari bentuk map (hasil parsing json)
  factory Menu.fromMap(Map<String, dynamic> menu) {
    return Menu(
      foods: List<MenuItem>.from(menu['foods']?.map((food) {
        return MenuItem.fromMap(food);
      })),
      drinks: List<MenuItem>.from(menu['drinks']?.map((drink) {
        return MenuItem.fromMap(drink);
      })),
    );
  }
}
