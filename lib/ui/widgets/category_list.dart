import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class CategoryList extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(40);

  final List<String> categories;

  const CategoryList({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return Consumer2<CategoryProvider, RestaurantSearchProvider>(
              builder: (context, categoryProvier, searchProvider, child) {
                return RawChip(
                  label: Text(categories[index]),
                  labelStyle: Theme.of(context).textTheme.subtitle2,
                  selected: categoryProvier.index == index ? true : false,
                  selectedColor: backGroundColor,
                  onSelected: (value) {
                    if (categoryProvier.index != index) {
                      categoryProvier.index = index;
                      categoryProvier.category = categories[index];

                      searchProvider
                          .searchRestaurants(categoryProvier.category);
                    }
                  },
                );
              },
            );
          }),
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8);
          },
          itemCount: categories.length,
        ),
      ),
    );
  }
}
