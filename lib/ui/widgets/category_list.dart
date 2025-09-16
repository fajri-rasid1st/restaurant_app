// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';

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
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          children: [
            for (var index = 0; index < categories.length; index++) ...[
              Consumer<SelectedCategoryProvider>(
                builder: (context, provider, child) {
                  return ChoiceChip(
                    label: Text(categories[index].name),
                    labelStyle: Theme.of(context).textTheme.titleSmall!.semiBold,
                    selected: provider.value == categories[index] ? true : false,
                    selectedColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: .3),
                    selectedShadowColor: Colors.transparent,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(99),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        onCategorySelected.call(categories[index]);
                      }
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
