import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/pages/review_form_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/item_menu_card.dart';

class DetailScreen extends StatelessWidget {
  final String restaurantId;
  final String heroTag;

  const DetailScreen({
    Key? key,
    required this.restaurantId,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer4<RestaurantDetailProvider, CustomerReviewProvider,
        DatabaseProvider, FavoriteProvider>(
      builder: (
        context,
        detailProvider,
        reviewProvider,
        databaseProvider,
        favoriteProvider,
        child,
      ) {
        if (detailProvider.state == ResultState.loading) {
          return const LoadingScreen();
        } else if (detailProvider.state == ResultState.error) {
          return ErrorScreen(restaurantId: restaurantId);
        }

        return _buildDetailScreen(
          context,
          detailProvider.detail,
          databaseProvider,
          favoriteProvider,
        );
      },
    );
  }

  /// Untuk membuat screen detail utama
  Scaffold _buildDetailScreen(
    BuildContext context,
    RestaurantDetail restaurant,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 240,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
              ),
              title: Text(restaurant.name),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  onPressed: favoriteProvider.isFavorite
                      ? () {
                          Utilities.removeFromFavorite(
                            context: context,
                            databaseProvider: databaseProvider,
                            favoriteProvider: favoriteProvider,
                            restaurantDetail: restaurant,
                          );
                        }
                      : () {
                          Utilities.addToFavorite(
                            context: context,
                            databaseProvider: databaseProvider,
                            favoriteProvider: favoriteProvider,
                            restaurantDetail: restaurant,
                          );
                        },
                  icon: favoriteProvider.icon,
                  tooltip: 'Favorite',
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Hero(
                      tag: heroTag,
                      child: CustomNetworkImage(
                        imgUrl: '${Const.imgUrl}/${restaurant.pictureId}',
                        width: double.infinity,
                        height: 264,
                        placeHolderSize: 264,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
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
                        decoration: const BoxDecoration(
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text(
                      restaurant.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: _buildCategoryChips(restaurant.categories),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 112,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.place_rounded,
                                    size: 48,
                                    color: Colors.red[400],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    children: <Flexible>[
                                      Flexible(
                                        child: Text(
                                          restaurant.city,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          restaurant.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: VerticalDivider(width: 1, thickness: 1),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    size: 58,
                                    color: Colors.orange[400],
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${restaurant.rating}/5.0',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: ReadMoreText(
                      restaurant.description,
                      trimLines: 4,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show More',
                      trimExpandedText: 'Show Less',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: secondaryTextColor),
                      lessStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      moreStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Menu',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      'Makanan',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: secondaryTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: _buildItemMenu(
                      crossAxisCount: 1,
                      childAspectRatio: 2 / 3,
                      foods: restaurant.menus.foods,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Minuman',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: secondaryTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: _buildItemMenu(
                      crossAxisCount: 1,
                      childAspectRatio: 5 / 4,
                      drinks: restaurant.menus.drinks,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Ulasan',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  _buildReviews(restaurant.customerReviews),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return ReviewFormScreen(
                                id: restaurant.id,
                                name: restaurant.name,
                              );
                            }),
                          ),
                        );
                      },
                      label: const Text('Tambah Ulasan'),
                      icon: const Icon(Icons.add_rounded),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
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

  /// Untuk membuat widget chip kategori restaurant
  ListView _buildCategoryChips(List<Category> categories) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return Chip(
          label: Text(
            categories[index].name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }),
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemCount: categories.length,
    );
  }

  /// Untuk membuat widget item menu dengan kustomisasi jumlah grid dan rasio
  GridView _buildItemMenu({
    required int crossAxisCount,
    required double childAspectRatio,
    List<ItemMenu>? foods,
    List<ItemMenu>? drinks,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return ItemMenuCard(food: foods?[index], drink: drinks?[index]);
      },
      itemCount: foods?.length ?? drinks!.length,
    );
  }

  /// Untuk membuat widget list review restaurant
  ListView _buildReviews(List<CustomerReview> reviews) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: backGroundColor,
            child: Image.asset(
              'assets/img/user_pict.png',
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
}
