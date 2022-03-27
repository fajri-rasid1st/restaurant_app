import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/pages/detail_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: restaurant.id,
                    child: CachedNetworkImage(
                      imageUrl: restaurant.pictureId,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 100,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      placeholder: (context, url) {
                        return Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: SpinKitPulse(color: primaryColor),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.motion_photos_off_outlined,
                              color: secondaryTextColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          restaurant.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.place_rounded,
                              size: 16,
                              color: Colors.red[400],
                            ),
                            const SizedBox(width: 4),
                            Text(restaurant.city)
                          ],
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star_rate_rounded,
                              size: 20,
                              color: Colors.orange[400],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${restaurant.rating}',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return DetailPage(restaurant: restaurant);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
