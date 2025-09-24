// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

// Project imports:
import 'package:restaurant_app/common/const/const.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/providers/api_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/pages/review_form_page.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/item_menu_card.dart';
import 'package:restaurant_app/ui/widgets/scaffold_safe_area.dart';

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
            return SizedBox.shrink();
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
    return ScaffoldSafeArea(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverLayoutBuilder(
              builder: (context, constraints) {
                const expanded = 240.0; // expandedHeight
                final collapsed = constraints.scrollOffset > (expanded - kToolbarHeight);

                final scheme = Theme.of(context).colorScheme;
                final onImage = scheme.surface; // sebelum scroll (di atas gambar)
                final onAppBar = scheme.onSurface; // setelah scroll (di appbar)

                return SliverAppBar(
                  pinned: true,
                  expandedHeight: expanded,
                  foregroundColor: collapsed ? onAppBar : onImage,
                  title: Text(restaurantDetail.name),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!.bold.copyWith(
                    color: collapsed ? onAppBar : onImage,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        restaurantDetail.isFavorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      ),
                      tooltip: restaurantDetail.isFavorited ? 'Hapus dari Favorite' : 'Tambah ke Favorite',
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: heroTag,
                          child: CustomNetworkImage(
                            imageUrl: '${Const.imgUrl}${restaurantDetail.pictureId}',
                            width: double.infinity,
                            height: 280,
                            placeHolderSize: 100,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [.0, .4],
                              colors: [
                                Theme.of(context).colorScheme.onSurface,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [.0, .45],
                              colors: [
                                Theme.of(context).colorScheme.onSurface,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ];
        },
        body: ClipRRect(
          borderRadius: BorderRadiusGeometry.vertical(
            top: Radius.circular(24),
          ),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      restaurantDetail.name,
                      style: Theme.of(context).textTheme.headlineMedium!.semiBold,
                    ),
                  ),
                  SizedBox(height: 8),
                  buildCategoryChipsWidget(
                    context: context,
                    categories: restaurantDetail.categories,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.place_rounded,
                                size: 48,
                                color: Colors.red[400],
                              ),
                              Text(
                                restaurantDetail.city,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium!.bold,
                              ),
                              Text(
                                restaurantDetail.address,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall!.semiBold.colorOutline(context),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rate_rounded,
                                size: 58,
                                color: Colors.orange[400],
                              ),
                              Text(
                                '${restaurantDetail.rating}/5.0',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.headlineSmall!.semiBold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ReadMoreText(
                      restaurantDetail.description,
                      trimLines: 4,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Lihat selengkapnya',
                      trimExpandedText: 'Lihat lebih sedikit',
                      delimiter: "... ",
                      colorClickableText: Theme.of(context).colorScheme.primary,
                      style: Theme.of(context).textTheme.bodyMedium,
                      lessStyle: Theme.of(context).textTheme.titleSmall!.bold.colorPrimary(context),
                      moreStyle: Theme.of(context).textTheme.titleSmall!.bold.colorPrimary(context),
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Menu',
                      style: Theme.of(context).textTheme.headlineSmall!.semiBold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Makanan',
                      style: Theme.of(context).textTheme.bodyMedium!.semiBold.colorOutline(context),
                    ),
                  ),
                  SizedBox(height: 8),
                  buildMenuItemsWidget(
                    items: restaurantDetail.menus.foods,
                    isFood: true,
                    aspectRatio: 16 / 10,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Minuman',
                      style: Theme.of(context).textTheme.bodyMedium!.semiBold.colorOutline(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  buildMenuItemsWidget(
                    items: restaurantDetail.menus.drinks,
                    isFood: false,
                    aspectRatio: 5 / 7,
                  ),
                  SizedBox(height: 24),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Ulasan',
                      style: Theme.of(context).textTheme.headlineSmall!.semiBold,
                    ),
                  ),
                  SizedBox(height: 4),
                  buildReviewsWidget(
                    context: context,
                    reviews: restaurantDetail.customerReviews,
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: OutlinedButton.icon(
                      label: Text('Tambah Ulasan'),
                      icon: Icon(Icons.add_rounded),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewFormPage(
                            restaurantId: restaurantDetail.id,
                            restaurantName: restaurantDetail.name,
                          ),
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
    required BuildContext context,
    required List<Category> categories,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var index = 0; index < categories.length; index++) ...[
            Chip(
              label: Text(categories[index].name),
              labelStyle: Theme.of(context).textTheme.titleSmall!.semiBold,
              backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: .3),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(99),
              ),
            ),

            if (index < categories.length - 1) SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  /// Widget function untuk membuat menu item
  Widget buildMenuItemsWidget({
    required List<ItemMenu> items,
    required bool isFood,
    required double aspectRatio,
  }) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemMenuCard(
            item: items[index],
            isFood: isFood,
            aspectRatio: aspectRatio,
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  /// Widget function untuk membuat list review restaurant
  Widget buildReviewsWidget({
    required BuildContext context,
    required List<CustomerReview> reviews,
  }) {
    return Column(
      children: [
        for (var index = 0; index < reviews.length; index++) ...[
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Image.asset(
                AssetPath.getIcon('ic_profile.png'),
                fit: BoxFit.cover,
              ),
            ),
            title: Text('"${reviews[index].review}"'),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium!.semiBold.colorOnSurface(context),
            subtitle: Text(reviews[index].name),
            subtitleTextStyle: Theme.of(context).textTheme.bodySmall!.colorOutline(context),
          ),
        ],
      ],
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
        });
  }
}
