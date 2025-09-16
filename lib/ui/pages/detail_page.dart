// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

// Project imports:
import 'package:restaurant_app/common/const/const.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/pages/review_form_page.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/item_menu_card.dart';

class DetailPage extends StatelessWidget {
  final String restaurantId;
  final String heroTag;

  const DetailPage({
    super.key,
    required this.restaurantId,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case ResultState.initial:
            return Scaffold(
              body: SizedBox.shrink(),
            );
          case ResultState.loading:
            return LoadingPage();
          case ResultState.error:
            return ErrorPage(
              message: provider.message,
              onRefresh: () => refreshPage(context, restaurantId),
            );
          case ResultState.data:
            return buildDetailPage(
              context: context,
              restaurantDetail: provider.restaurantDetail!,
            );
        }
      },
    );
  }

  /// Widget function untuk membuat halaman detail utama
  Widget buildDetailPage({
    required BuildContext context,
    required RestaurantDetail restaurantDetail,
  }) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 240,
              title: Text(restaurantDetail.name),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Hero(
                      tag: heroTag,
                      child: CustomNetworkImage(
                        imageUrl: '${Const.imgUrl}${restaurantDetail.pictureId}',
                        width: double.infinity,
                        height: 264,
                        placeHolderSize: 120,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black12,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text(
                      restaurantDetail.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: buildCategoryChipsWidget(
                      categories: restaurantDetail.categories,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      height: 112,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.place_rounded,
                                    size: 48,
                                    color: Colors.red[400],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          restaurantDetail.city,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          restaurantDetail.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: VerticalDivider(
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    size: 58,
                                    color: Colors.orange[400],
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${restaurantDetail.rating}/5.0',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: ReadMoreText(
                      restaurantDetail.description,
                      trimLines: 4,
                      colorClickableText: Theme.of(context).colorScheme.primary,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show More',
                      trimExpandedText: 'Show Less',
                      style: Theme.of(context).textTheme.bodyMedium,
                      lessStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      moreStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Menu',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      'Makanan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: buildMenuItemsWidget(
                      crossAxisCount: 1,
                      childAspectRatio: 2 / 3,
                      items: restaurantDetail.menus.foods,
                      isFood: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Minuman',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: buildMenuItemsWidget(
                      crossAxisCount: 1,
                      childAspectRatio: 5 / 4,
                      items: restaurantDetail.menus.drinks,
                      isFood: false,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Ulasan',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  buildReviewsWidget(
                    reviews: restaurantDetail.customerReviews,
                  ),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return ReviewFormPage(
                                restaurantId: restaurantDetail.id,
                                restaurantName: restaurantDetail.name,
                              );
                            }),
                          ),
                        );
                      },
                      label: Text('Tambah Ulasan'),
                      icon: Icon(Icons.add_rounded),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget function untuk membuat chips kategori
  Widget buildCategoryChipsWidget({
    required List<Category> categories,
  }) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Chip(
        label: Text(
          categories[index].name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(width: 8),
      itemCount: categories.length,
    );
  }

  /// Widget function untuk membuat menu item dengan kustomisasi jumlah grid dan rasio
  Widget buildMenuItemsWidget({
    required int crossAxisCount,
    required double childAspectRatio,
    required List<ItemMenu> items,
    required bool isFood,
  }) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return ItemMenuCard(
          item: items[index],
          isFood: isFood,
        );
      },
      itemCount: items.length,
    );
  }

  /// Widget function untuk membuat list review restaurant
  Widget buildReviewsWidget({
    required List<CustomerReview> reviews,
  }) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            child: Image.asset(
              AssetPath.getImage("user_pict.png"),
              fit: BoxFit.fill,
            ),
          ),
          title: Text('"${reviews[index].review}"'),
          subtitle: Text(reviews[index].name),
        );
      },
      itemCount: reviews.length,
    );
  }

  /// Fungsi untuk reload halaman saat data gagal di-fetch
  Future<void> refreshPage(
    BuildContext context,
    String restaurantId,
  ) async {
    context.read<IsReloadProvider>().value = true;

    Future.wait([
          Future.delayed(Duration(milliseconds: 500)),
          context.read<RestaurantDetailProvider>().getRestaurantDetail(restaurantId),
        ])
        .then((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;
        })
        .catchError((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;

          Utilities.showSnackBarMessage(
            context: context,
            text: 'Gagal memuat detail restoran',
          );
        });
  }
}
