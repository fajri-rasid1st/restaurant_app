import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class DetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const DetailPage({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(restaurant.toString()),
    );
  }
}
