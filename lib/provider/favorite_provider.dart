import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  Icon _favoriteIcon = const Icon(Icons.favorite_outline);
  VoidCallback _onPressed = () {};

  Icon get favoriteIcon => _favoriteIcon;
  VoidCallback get onPressed => _onPressed;

  IconButton get favoriteButton {
    return IconButton(
      onPressed: onPressed,
      icon: favoriteIcon,
      tooltip: 'Favorite',
    );
  }

  set favoriteIcon(Icon value) {
    favoriteIcon = value;
    notifyListeners();
  }

  set onPressed(VoidCallback value) {
    _onPressed = value;
    notifyListeners();
  }
}
