import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/providers/app_provider/app_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<RestaurantCategory> onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        key: PageStorageKey('category_list'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Row(
          children: [
            for (var index = 0; index < categories.length; index++) ...[
              ValueListenableBuilder(
                valueListenable: selectedCategory,
                builder: (context, value, _) {
                  return Provider.value(
                    value: value,
                    child: ChoiceChip(
                      label: Text(value.name),
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      selected: selectedCategory.value.index == value.index ? true : false,
                      selectedColor: Palette.secondaryColor,
                      onSelected: (selected) {
                        if (selected) {
                          onCategorySelected.call(value);

                          // selectedCategory.value = value;

                          // final query = selectedCategory.value == RestaurantCategory.all
                          //     ? null
                          //     : selectedCategory.value.name;

                          // context.read<RestaurantProvider>().getRestaurants(query);
                        }
                      },
                    ),
                  );
                },
              ),
              if (index < categories.length - 1) SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
