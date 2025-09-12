import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/restaurant_category.dart';

/// Provider untuk mengatur state reload halaman
final isPageReload = ValueNotifier<bool>(false);

/// Provider untuk mengatur state kategori restoran yang dipilih
final selectedCategory = ValueNotifier<RestaurantCategory>(RestaurantCategory.all);

/// Provider untuk mengatur state pencarian
final isSearching = ValueNotifier<bool>(false);

/// Provider untuk mengatur state query pencarian
final searchQuery = ValueNotifier<String>('');
