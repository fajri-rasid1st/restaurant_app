import 'package:restaurant_app/data/models/drink.dart';
import 'package:restaurant_app/data/models/food.dart';

class Menu {
  final List<Food> foods;
  final List<Drink> drinks;
  Menu({
    required this.foods,
    required this.drinks,
  });

  // constructor untuk membuat objek Menu dari bentuk Map (hasil parsing json)
  factory Menu.fromMap(Map<String, dynamic> menus) {
    return Menu(
      foods: List<Food>.from(menus['foods']?.map((food) {
        return Food.fromMap(food);
      })),
      drinks: List<Drink>.from(menus['drinks']?.map((drink) {
        return Drink.fromMap(drink);
      })),
    );
  }
}
