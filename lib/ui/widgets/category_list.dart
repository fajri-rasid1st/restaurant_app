import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class CategoryList extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(64);

  final List<String> categories;

  const CategoryList({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        key: const PageStorageKey<String>('category_list'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return Consumer2<CategoryProvider, RestaurantSearchProvider>(
            builder: (context, categoryProvider, searchProvider, child) {
              return RawChip(
                label: Text(categories[index]),
                labelStyle: Theme.of(context).textTheme.subtitle2,
                selected: categoryProvider.index == index ? true : false,
                selectedColor: secondaryColor,
                onSelected: (value) {
                  if (categoryProvider.index != index) {
                    categoryProvider.index = index;
                    categoryProvider.category = categories[index];

                    searchProvider.searchRestaurants(categoryProvider.category);
                  }
                },
              );
            },
          );
        }),
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}
