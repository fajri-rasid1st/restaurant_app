import 'package:restaurant_app/data/models/menu_item.dart';

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  /// Constructor untuk membuat objek Menu dari bentuk map (hasil parsing json)
  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      foods: List<MenuItem>.from(map['foods']?.map((food) {
        return MenuItem.fromMap(food);
      })),
      drinks: List<MenuItem>.from(map['drinks']?.map((drink) {
        return MenuItem.fromMap(drink);
      })),
    );
  }
}
