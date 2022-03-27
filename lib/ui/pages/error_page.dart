import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/pages/home_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  List<Restaurant>? _restaurants;
  bool _isReload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/svg/No_data_cuate.svg',
                width: 300,
                fit: BoxFit.fill,
              ),
              Text(
                'Terjadi Masalah Koneksi',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Periksa sambungan internet, lalu coba lagi.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: reloadPage,
                icon: _isReload
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: onPrimaryColor,
                        ),
                      )
                    : const Icon(Icons.replay_rounded),
                label: _isReload
                    ? const Text('Memuat Data...')
                    : const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// melakukan reload halaman dan menghasilkan beberapa kondisi, yaitu:
  ///
  /// * memunculkuan peson error jika data gagal dimuat
  /// * menuju ke halaman HomePage jika data berhasil dimuat
  Future<void> reloadPage() async {
    setState(() => _isReload = !_isReload);

    Future.wait([
      Future.delayed(const Duration(milliseconds: 3000)),
      RestaurantApi.getRestaurants(),
    ]).then((value) {
      setState(() => _restaurants = value[1]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => HomePage(restaurants: _restaurants!)),
        ),
      );
    }).catchError((error) {
      setState(() => _isReload = !_isReload);

      // create snackbar
      SnackBar snackBar = SnackBar(
        content: Text(
          error.toString(),
          style: GoogleFonts.quicksand(),
        ),
      );

      // show snackbar
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }
}
