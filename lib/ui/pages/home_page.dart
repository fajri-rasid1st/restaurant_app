import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class HomePage extends StatelessWidget {
  final List<Restaurant>? restaurants;

  const HomePage({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
