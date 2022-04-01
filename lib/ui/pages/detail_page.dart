import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/models/menu_item.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/pages/review_form_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/menu_item_view.dart';

class DetailPage extends StatelessWidget {
  final String restaurantId;

  const DetailPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return const LoadingPage();
        } else if (provider.state == ResultState.error) {
          return ErrorPage(restaurantId: restaurantId);
        }

        return _buildDetailScreen(context, provider.detail);
      },
    );
  }

  Scaffold _buildDetailScreen(
    BuildContext context,
    RestaurantDetail restaurant,
  ) {
    return Scaffold(
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
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Hero(
                      tag: restaurant.id,
                      child: CustomNetworkImage(
                        imgUrl: '${Const.imgUrl}/${restaurant.pictureId}',
                        width: double.infinity,
                        height: 240,
                        placeHolderSize: 240,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black87,
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
                              Colors.black38,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  restaurant.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              SizedBox(
                height: 40,
                child: _buildBannerChip(restaurant),
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
                child: _buildMenuItem(
                  foods: restaurant.menus.foods,
                  crossAxisCount: 1,
                  childAspectRatio: 2 / 3,
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
                child: _buildMenuItem(
                  drinks: restaurant.menus.drinks,
                  crossAxisCount: 1,
                  childAspectRatio: 5 / 4,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  'Ulasan Ringkas',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              _buildReviewList(restaurant),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return ReviewFormPage(
                              id: restaurant.id,
                              name: restaurant.name,
                            );
                          }),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Tambah Ulasan'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Untuk membuat widget list review restaurant
  ListView _buildReviewList(RestaurantDetail restaurant) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final restaurantReview = restaurant.customerReviews[index];

        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: backGroundColor,
            child: Image.asset(
              'assets/img/user_pict.png',
              fit: BoxFit.fill,
            ),
          ),
          title: Text('"${restaurantReview.review}"'),
          subtitle: Text(restaurantReview.name),
        );
      },
      itemCount: restaurant.customerReviews.length,
    );
  }

  /// Untuk membuat widget banner chip kategori restaurant
  ListView _buildBannerChip(RestaurantDetail restaurant) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return Chip(
          label: Text(
            restaurant.categories[index].name,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        );
      }),
      separatorBuilder: (context, index) {
        return const SizedBox(width: 8);
      },
      itemCount: restaurant.categories.length,
    );
  }

  /// Untuk membuat widget menu item dengan kustomisasi jumlah grid dan rasio
  GridView _buildMenuItem({
    List<MenuItem>? foods,
    List<MenuItem>? drinks,
    required int crossAxisCount,
    required double childAspectRatio,
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
        return MenuItemView(food: foods?[index], drink: drinks?[index]);
      },
      itemCount: foods != null ? foods.length : drinks!.length,
    );
  }
}
