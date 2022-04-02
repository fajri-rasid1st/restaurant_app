import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/provider/page_reload_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/screens/detail_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';

class ErrorScreen extends StatelessWidget {
  final String? restaurantId;

  const ErrorScreen({Key? key, this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
	  physics: const NeverScrollableScrollPhysics(),
          child: CustomInformation(
            imgPath: 'assets/svg/404_error_lost_in_space_cuate.svg',
            title: 'Terjadi Masalah Koneksi',
            subtitle: 'Periksa koneksi internet, lalu coba lagi.',
            child: Consumer4<RestaurantProvider, RestaurantDetailProvider,
                RestaurantSearchProvider, PageReloadProvider>(
              builder: (
                context,
                restaurantProvider,
                detailProvider,
                searchProvider,
                reloadProvider,
                child,
              ) {
                return searchProvider.isSearching
                    ? const SizedBox()
                    : ElevatedButton.icon(
                        onPressed: reloadProvider.isPageReload
                            ? null
                            : () {
                                if (restaurantId != null) {
                                  reloadPage(
                                    context,
                                    restaurantProvider,
                                    detailProvider,
                                    searchProvider,
                                    reloadProvider,
                                    restaurantId,
                                  );
                                } else {
                                  reloadPage(
                                    context,
                                    restaurantProvider,
                                    detailProvider,
                                    searchProvider,
                                    reloadProvider,
                                  );
                                }
                              },
                        icon: reloadProvider.isPageReload
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: secondaryTextColor,
                                ),
                              )
                            : const Icon(Icons.replay_rounded),
                        label: reloadProvider.isPageReload
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
      RestaurantDetailProvider detailProvider,
      RestaurantSearchProvider searchProvider,
      PageReloadProvider reloadProvider,
      [String? restaurantId]) async {
    reloadProvider.isPageReload = true;

    Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)),
      if (restaurantId != null) ...[
        RestaurantApi.getRestaurantDetail(restaurantId),
      ] else ...[
        RestaurantApi.getRestaurants(),
        RestaurantApi.getRestaurants(searchProvider.query),
      ]
    ]).then((value) {
      reloadProvider.isPageReload = false;

      if (restaurantId != null) {
        detailProvider.detail = value[1];
        detailProvider.state = ResultState.hasData;
      } else {
        restaurantProvider.restaurants = value[1];
        restaurantProvider.state = ResultState.hasData;

        searchProvider.restaurants = value[2];
      }

      if (restaurantId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailScreen(restaurantId: restaurantId)),
          ),
        );
      }
    }).catchError((error) {
      reloadProvider.isPageReload = false;

      Utilities.showSnackBarMessage(context: context, text: error.message);
    });
  }
}
