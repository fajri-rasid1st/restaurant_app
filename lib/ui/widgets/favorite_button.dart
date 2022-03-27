import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final String _favoriteAdded = 'Liked';
  final String _favoriteRemoved = 'Unliked';

  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => _isFavorite = !_isFavorite);

        // create snackbar
        SnackBar snackBar = SnackBar(
          content: Text(
            _isFavorite ? _favoriteAdded : _favoriteRemoved,
            style: GoogleFonts.quicksand(),
          ),
        );

        // show snackbar
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      },
      icon: Icon(
        _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      ),
      color: _isFavorite ? Colors.red[400] : secondaryColor,
      tooltip: 'Favorite',
    );
  }
}
