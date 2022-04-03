import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/screens/detail_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';

class ErrorScreen extends StatefulWidget {
  final String? restaurantId;

  const ErrorScreen({Key? key, this.restaurantId}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _isPageReload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: CustomInformation(
          imgPath: 'assets/svg/404_error_lost_in_space_cuate.svg',
          title: 'Anda Sedang Offline',
          subtitle: 'Periksa koneksi internet, lalu coba lagi.',
          child: Consumer3<RestaurantProvider, RestaurantDetailProvider,
              RestaurantSearchProvider>(
            builder: (
              context,
              restaurantProvider,
              detailProvider,
              searchProvider,
              child,
            ) {
              return searchProvider.isSearching
                  ? const SizedBox()
                  : ElevatedButton.icon(
                      onPressed: _isPageReload
                          ? null
                          : () {
                              if (widget.restaurantId != null) {
                                reloadPage(
                                  restaurantProvider: restaurantProvider,
                                  detailProvider: detailProvider,
                                  searchProvider: searchProvider,
                                  restaurantId: widget.restaurantId,
                                );
                              } else {
                                reloadPage(
                                  restaurantProvider: restaurantProvider,
                                  detailProvider: detailProvider,
                                  searchProvider: searchProvider,
                                );
                              }
                            },
                      icon: _isPageReload
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: secondaryTextColor,
                              ),
                            )
                          : const Icon(Icons.replay_rounded),
                      label: _isPageReload
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
    );
  }

  /// melakukan reload halaman dan menghasilkan beberapa kondisi, yaitu:
  ///
  /// * memunculkuan peson error jika data gagal dimuat
  /// * menuju ke halaman tertentu jika data berhasil dimuat
  Future<void> reloadPage({
    required RestaurantProvider restaurantProvider,
    required RestaurantDetailProvider detailProvider,
    required RestaurantSearchProvider searchProvider,
    String? restaurantId,
  }) async {
    setState(() => _isPageReload = true);

    var message = '';

    Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)),
      if (restaurantId != null) ...[
        detailProvider.getRestaurantDetail(restaurantId),
      ] else ...[
        restaurantProvider.fetchAllRestaurants(),
        searchProvider.searchRestaurants(searchProvider.query),
      ]
    ]).then((value) {
      setState(() => _isPageReload = false);

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
    }).catchError((_) {
      setState(() => _isPageReload = false);

      if (restaurantId != null) {
        message = detailProvider.message;
      } else {
        message = restaurantProvider.message;
      }

      if (mounted) {
        Utilities.showSnackBarMessage(context: context, text: message);
      }
    });
  }
}
