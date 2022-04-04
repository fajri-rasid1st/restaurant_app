import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/data/models/favorite.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/ui/screens/detail_screen.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant? restaurant;
  final Favorite? favorite;

  const RestaurantCard({
    Key? key,
    this.restaurant,
    this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = restaurant?.id ?? favorite!.restaurantId;
    final pictureId = restaurant?.pictureId ?? favorite!.pictureId;
    final name = restaurant?.name ?? favorite!.name;
    final city = restaurant?.city ?? favorite!.city;
    final rating = restaurant?.rating ?? favorite!.rating;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: id,
                    child: CustomNetworkImage(
                      imgUrl: '${Const.imgUrl}/$pictureId',
                      width: double.infinity,
                      height: 120,
                      placeHolderSize: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place_rounded,
                            size: 20,
                            color: Colors.red[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            city,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star_rate_rounded,
                            size: 22,
                            color: Colors.orange[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context
                    .read<RestaurantDetailProvider>()
                    .getRestaurantDetail(id);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => DetailScreen(restaurantId: id)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
