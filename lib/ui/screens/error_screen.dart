import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/provider/page_reload_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/screens/detail_screen.dart';
import 'package:restaurant_app/ui/screens/home_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';

class ErrorScreen extends StatelessWidget {
  final String? restaurantId;

  const ErrorScreen({Key? key, this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomInformation(
        imgPath: 'assets/svg/No_data_cuate.svg',
        title: 'Terjadi Masalah Koneksi',
        subtitle: 'Periksa koneksi internet, lalu coba lagi.',
        child: Consumer3<RestaurantProvider, RestaurantDetailProvider,
            PageReloadProvider>(
          builder: (
            context,
            restaurantProvider,
            restaurantDetailProvider,
            pageReloadProvider,
            child,
          ) {
            return ElevatedButton.icon(
              onPressed: pageReloadProvider.isPageReload
                  ? null
                  : () {
                      if (restaurantId != null) {
                        reloadPage(
                          context,
                          restaurantProvider,
                          restaurantDetailProvider,
                          pageReloadProvider,
                          restaurantId,
                        );
                      } else {
                        reloadPage(
                          context,
                          restaurantProvider,
                          restaurantDetailProvider,
                          pageReloadProvider,
                        );
                      }
                    },
              icon: pageReloadProvider.isPageReload
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: secondaryTextColor,
                      ),
                    )
                  : const Icon(Icons.replay_rounded),
              label: pageReloadProvider.isPageReload
                  ? const Text('Memuat Data...')
                  : const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// melakukan reload halaman dan menghasilkan beberapa kondisi, yaitu:
  ///
  /// * memunculkuan peson error jika data gagal dimuat
  /// * menuju ke halaman tertentu jika data berhasil dimuat
  Future<void> reloadPage(
      BuildContext context,
      RestaurantProvider restaurantProvider,
      RestaurantDetailProvider restaurantDetailProvider,
      PageReloadProvider pageReloadProvider,
      [String? restaurantId]) async {
    pageReloadProvider.isPageReload = true;

    Future.wait([
      Future.delayed(const Duration(milliseconds: 3000)),
      if (restaurantId != null) ...[
        RestaurantApi.getRestaurantDetail(restaurantId),
      ] else ...[
        RestaurantApi.getRestaurants(),
      ]
    ]).then((value) {
      pageReloadProvider.isPageReload = false;

      if (restaurantId != null) {
        restaurantDetailProvider.detail = value[1];
        restaurantDetailProvider.state = ResultState.hasData;
      } else {
        restaurantProvider.restaurants = value[1];
        restaurantProvider.state = ResultState.hasData;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) {
            return restaurantId != null
                ? DetailScreen(restaurantId: restaurantId)
                : const HomeScreen();
          }),
        ),
      );
    }).catchError((error) {
      pageReloadProvider.isPageReload = false;

      Utilities.showSnackBarMessage(context: context, text: error.message);
    });
  }
}