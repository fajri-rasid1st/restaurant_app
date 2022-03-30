import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/pages/home_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPageReload = context.watch<RestaurantProvider>().isPageReload;

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
                onPressed: isPageReload ? null : () => reloadPage(context),
                icon: isPageReload
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: onPrimaryColor,
                        ),
                      )
                    : const Icon(Icons.replay_rounded),
                label: isPageReload
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
  Future<void> reloadPage(BuildContext context) async {
    context.read<RestaurantProvider>().isPageReload = true;

    Future.wait([
      Future.delayed(const Duration(milliseconds: 3000)),
      RestaurantApi.getRestaurants(),
    ]).then((value) {
      context.read<RestaurantProvider>().restaurants = value[1];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => const HomePage()),
        ),
      );
    }).catchError((error) {
      context.read<RestaurantProvider>().isPageReload = false;

      // create snackbar
      SnackBar snackBar = SnackBar(
        content: Text(
          error.message,
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
