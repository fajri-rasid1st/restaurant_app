import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/data/models/category.dart';
import 'package:restaurant_app/data/models/customer_review.dart';
import 'package:restaurant_app/data/models/favorite.dart';
import 'package:restaurant_app/data/models/menu_item.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/provider/customer_review_provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/ui/screens/error_screen.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/screens/review_form_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/menu_item_card.dart';

class DetailScreen extends StatelessWidget {
  final String restaurantId;

  const DetailScreen({Key? key, required this.restaurantId}) : super(key: key);

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
        } else {
          if (favoriteProvider.state == ResultState.loading) {
            setFavoriteIconButton(
              restaurantId,
              databaseProvider,
              favoriteProvider,
            );

            return const LoadingScreen();
          } else {
            return _buildDetailScreen(
              context,
              detailProvider.detail,
              detailProvider,
              databaseProvider,
              favoriteProvider,
            );
          }
        }
      },
    );
  }

  /// Untuk membuat screen detail utama
  Scaffold _buildDetailScreen(
    BuildContext context,
    RestaurantDetail restaurant,
    RestaurantDetailProvider detailProvider,
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
                          removeFromFavorite(
                            context,
                            detailProvider,
                            databaseProvider,
                            favoriteProvider,
                          );
                        }
                      : () {
                          addToFavorite(
                            context,
                            detailProvider,
                            databaseProvider,
                            favoriteProvider,
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
                      tag: restaurant.id,
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
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: _buildCategoryChips(restaurant.categories),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.place_rounded,
                                size: 48,
                                color: Colors.red[400],
                              ),
                              const Spacer(),
                              Text(
                                restaurant.city,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                restaurant.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: VerticalDivider(width: 1, thickness: 1),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.star_rate_rounded,
                                size: 58,
                                color: Colors.orange[400],
                              ),
                              const Spacer(),
                              Text(
                                '${restaurant.rating}/5.0',
                                style: Theme.of(context).textTheme.headline4,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.headline5,
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
                          .bodyText2
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
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      'Makanan',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: secondaryTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: _buildMenuItems(
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
                          .subtitle1
                          ?.copyWith(color: secondaryTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: _buildMenuItems(
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
                      style: Theme.of(context).textTheme.headline5,
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

  Future<void> setFavoriteIconButton(
    String restaurantId,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) async {
    final isExist = await databaseProvider.isFavoriteAlreadyExist(restaurantId);

    if (isExist) {
      favoriteProvider.icon = Icon(
        Icons.favorite,
        color: Colors.red[400],
      );

      favoriteProvider.isFavorite = true;
    } else {
      favoriteProvider.icon = Icon(
        Icons.favorite_outline,
        color: backGroundColor,
      );

      favoriteProvider.isFavorite = false;
    }

    favoriteProvider.state = ResultState.hasData;
  }

  Future<void> addToFavorite(
    BuildContext context,
    RestaurantDetailProvider detailProvider,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) async {
    final favorite = Favorite(
      restaurantId: detailProvider.detail.id,
      name: detailProvider.detail.name,
      pictureId: detailProvider.detail.pictureId,
      city: detailProvider.detail.city,
      rating: detailProvider.detail.rating,
      createdAt: DateTime.now(),
    );

    await databaseProvider.createFavorite(favorite);

    favoriteProvider.icon = Icon(
      Icons.favorite,
      color: Colors.red[400],
    );

    favoriteProvider.isFavorite = true;

    Utilities.showSnackBarMessage(
      context: context,
      text: 'Berhasil ditambahkan ke favorite.',
    );
  }

  Future<void> removeFromFavorite(
    BuildContext context,
    RestaurantDetailProvider detailProvider,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) async {
    await databaseProvider
        .deleteFavoriteByRestaurantId(detailProvider.detail.id);

    favoriteProvider.icon = Icon(
      Icons.favorite_outline,
      color: backGroundColor,
    );

    favoriteProvider.isFavorite = false;

    Utilities.showSnackBarMessage(
      context: context,
      text: 'Berhasil dihapus dari favorite.',
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
            style: Theme.of(context).textTheme.bodyText2,
          ),
        );
      }),
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemCount: categories.length,
    );
  }

  /// Untuk membuat widget menu item dengan kustomisasi jumlah grid dan rasio
  GridView _buildMenuItems({
    required int crossAxisCount,
    required double childAspectRatio,
    List<MenuItem>? foods,
    List<MenuItem>? drinks,
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
        return MenuItemCard(food: foods?[index], drink: drinks?[index]);
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
