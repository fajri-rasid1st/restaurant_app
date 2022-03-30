import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/common/const.dart';
import 'package:restaurant_app/data/models/menu_item.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';
import 'package:restaurant_app/ui/widgets/favorite_button.dart';
import 'package:restaurant_app/ui/widgets/menu_item_view.dart';

class DetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const DetailPage({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              actions: const <Widget>[FavoriteButton()],
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                restaurant.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.place_rounded,
                        size: 18,
                        color: Colors.red[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.city,
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('●'),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.star_rate_rounded,
                        size: 22,
                        color: Colors.orange[400],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.rating}',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              ReadMoreText(
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Menu',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Makanan',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: secondaryTextColor),
                ),
              ),
              // _buildMenuItems(
              //   foods: restaurant.menus.foods,
              //   crossAxisCount: 2,
              //   childAspectRatio: 5 / 4,
              // ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Minuman',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: secondaryTextColor),
                ),
              ),
              // _buildMenuItems(
              //   drinks: restaurant.menus.drinks,
              //   crossAxisCount: 3,
              //   childAspectRatio: 2 / 3,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// untuk membuat menu item foods dan/atau drinks dengan kustomisasi jumlah grid dan rasio
  GridView _buildMenuItems({
    List<MenuItem>? foods,
    List<MenuItem>? drinks,
    required int crossAxisCount,
    required double childAspectRatio,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return MenuItemView(food: foods?[index], drink: drinks?[index]);
      },
      itemCount: foods != null ? foods.length : drinks!.length,
      shrinkWrap: true,
    );
  }
}
