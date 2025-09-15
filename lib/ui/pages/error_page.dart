import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/ui/pages/detail_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';

class ErrorPage extends StatefulWidget {
  final VoidCallback onRefresh;

  const ErrorPage({
    super.key,
    required this.onRefresh,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: CustomInformation(
          assetName: AssetPath.getVector('404_error_lost_in_space_cuate.svg'),
          title: 'Gagal Memuat Data',
          subtitle: 'Pastikan Anda terhubung ke internet, lalu coba lagi.',
          child:
              Consumer5<
                RestaurantProvider,
                RestaurantDetailProvider,
                RestaurantSearchProvider,
                PageReloadProvider,
                FavoriteProvider
              >(
                builder:
                    (
                      context,
                      restaurantProvider,
                      detailProvider,
                      searchProvider,
                      reloadProvider,
                      favoriteProvider,
                      child,
                    ) {
                      return searchProvider.isSearching
                          ? const SizedBox()
                          : ElevatedButton.icon(
                              onPressed: reloadProvider.isReload
                                  ? null
                                  : () {
                                      if (widget.restaurantId != null) {
                                        reloadPage(
                                          restaurantProvider: restaurantProvider,
                                          detailProvider: detailProvider,
                                          searchProvider: searchProvider,
                                          favoriteProvider: favoriteProvider,
                                          reloadProvider: reloadProvider,
                                          restaurantId: widget.restaurantId,
                                        );
                                      } else {
                                        reloadPage(
                                          restaurantProvider: restaurantProvider,
                                          detailProvider: detailProvider,
                                          searchProvider: searchProvider,
                                          favoriteProvider: favoriteProvider,
                                          reloadProvider: reloadProvider,
                                        );
                                      }
                                    },
                              icon: reloadProvider.isReload
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: secondaryTextColor,
                                      ),
                                    )
                                  : const Icon(Icons.replay_rounded),
                              label: reloadProvider.isReload ? const Text('Memuat Data...') : const Text('Coba Lagi'),
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

  /// Melakukan reload halaman dan menghasilkan beberapa kondisi, yaitu:
  ///
  /// * Memunculkuan peson error jika data gagal dimuat
  /// * Menuju ke halaman tertentu jika data berhasil dimuat
  Future<void> reloadPage({
    required RestaurantProvider restaurantProvider,
    required RestaurantDetailProvider detailProvider,
    required RestaurantSearchProvider searchProvider,
    required FavoriteProvider favoriteProvider,
    required PageReloadProvider reloadProvider,
    String? restaurantId,
  }) async {
    reloadProvider.isReload = true;

    var message = '';

    Future.wait([
          Future.delayed(const Duration(milliseconds: 1000)),
          if (restaurantId != null) ...[
            detailProvider.getRestaurantDetail(restaurantId),
            favoriteProvider.setFavoriteIconButton(restaurantId),
          ] else ...[
            restaurantProvider.fetchAllRestaurants(),
            searchProvider.searchRestaurants(searchProvider.query),
          ],
        ])
        .then((value) {
          reloadProvider.isReload = false;

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
                builder: ((context) {
                  return DetailPage(restaurantId: restaurantId, heroTag: '');
                }),
              ),
            );
          }
        })
        .catchError((_) {
          reloadProvider.isReload = false;

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
