import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class CategoryList extends StatelessWidget {
  final List<RestaurantCategory> categories;
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
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Row(
          children: [
            for (var index = 0; index < categories.length; index++) ...[
              Consumer<SelectedCategoryProvider>(
                builder: (context, provider, child) {
                  final value = provider.value;

                  return ChoiceChip(
                    label: Text(categories[index].name),
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    selected: value == categories[index] ? true : false,
                    selectedColor: Palette.secondaryColor,
                    onSelected: (selected) {
                      if (selected) onCategorySelected.call(value);
                    },
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
