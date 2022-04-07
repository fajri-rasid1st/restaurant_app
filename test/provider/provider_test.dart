import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/providers/customer_review_provider.dart';
import 'package:restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/providers/restaurant_search_provider.dart';

void main() {
  group('Provider Testing', () {
    // Arrange
    late RestaurantProvider restaurantProvider;
    late RestaurantDetailProvider detailProvider;
    late RestaurantSearchProvider searchProvider;
    late CustomerReviewProvider reviewProvider;

    setUp(() {
      restaurantProvider = RestaurantProvider(restaurantApi: RestaurantApi());
      detailProvider = RestaurantDetailProvider(restaurantApi: RestaurantApi());
      searchProvider = RestaurantSearchProvider(restaurantApi: RestaurantApi());
      reviewProvider = CustomerReviewProvider(restaurantApi: RestaurantApi());
    });

    // Restaurant list test
    test('Should contain non-empty list of restaurants', () async {
      // Act
      await restaurantProvider.fetchAllRestaurants();

      // Assert
      final result = restaurantProvider.restaurants.isNotEmpty;
      expect(result, true);
    });

    test('Should contain empty restaurants', () {
      // Act
      restaurantProvider.fetchAllRestaurants();

      // Assert
      final result = restaurantProvider.restaurants.isEmpty;
      expect(result, true);
    });

    // Restaurant detail test
    test(
      'Should contain RestaurantDetail.',
      () async {
        // Act
        await detailProvider.getRestaurantDetail('rqdv5juczeskfw1e867');

        // Assert
        final result = detailProvider.detail;
        expect(result, isA<RestaurantDetail>());
      },
    );

    test(
      'Should contain non-empty message (RestaurantDetail is not initialized).',
      () async {
        // Act
        await detailProvider.getRestaurantDetail('');

        // Assert
        final result = detailProvider.message.isNotEmpty;
        expect(result, true);
      },
    );

    // Restaurant search test
    test('Should contain non-empty list of restaurants', () async {
      // Act
      await searchProvider.searchRestaurants('kafe');

      // Assert
      final result = searchProvider.restaurants.isNotEmpty;
      expect(result, true);
    });

    test('Should contain empty restaurants', () async {
      // Act
      await searchProvider.searchRestaurants('qwerty');

      // Assert
      final result = searchProvider.restaurants.isEmpty;
      expect(result, true);
    });

    // Customer review test
    test('Should contain non-empty list of customer reviews', () async {
      // Act
      await reviewProvider.sendCustomerReview(
        'rqdv5juczeskfw1e867',
        'tester',
        'test',
      );

      // Assert
      final result = reviewProvider.customerReviews.isNotEmpty;
      expect(result, true);
    });

    test('Should return false, if id doesn\'t include restaurantId', () async {
      // Act
      final result = await reviewProvider.sendCustomerReview('', '', '');

      // Assert
      expect(result, false);
    });
  });
}
