// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import '../helpers/dummies.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockRestaurantApi api;
  late MockRestaurantDatabase db;
  late RestaurantsProvider provider;

  setUp(() {
    api = MockRestaurantApi();
    db = MockRestaurantDatabase();
    provider = RestaurantsProvider(
      apiService: api,
      databaseService: db,
    );
  });

  group('RestaurantsProvider', () {
    test('state awal loading dan properti terdefinisi namun masih kosong', () {
      expect(provider.state, ResultState.loading);
      expect(provider.message, allOf(isA<String>(), isEmpty));
      expect(provider.restaurants, allOf(isA<List<Restaurant>>(), isEmpty));
    });

    test('fetch daftar restoran sukses → state data, list diperbarui', () async {
      // Stub API: getRestaurants
      when(api.getRestaurants(any)).thenAnswer((_) async => dummyRestaurants);

      // Stub DB: check if restaurant is exist on database
      when(db.isExist(any)).thenAnswer((_) async => false);

      // fetch provider.getRestaurants()
      await provider.getRestaurants();

      expect(provider.state, ResultState.data);
      expect(provider.restaurants, isNotEmpty);
      expect(provider.restaurants.length, dummyRestaurants.length);

      // Verify getRestaurants function only called once
      verify(api.getRestaurants()).called(1);

      // Verify isExist function called as many as item length
      verify(db.isExist(any)).called(dummyRestaurants.length);

      // verify no more services is running
      verifyNoMoreInteractions(api);
      verifyNoMoreInteractions(db);
    });

    test('fetch daftar restoran gagal → state error, message mengandung kata "gagal"', () async {
      when(api.getRestaurants(any)).thenThrow(Exception('Server error'));

      await provider.getRestaurants();

      expect(provider.state, ResultState.error);
      expect(provider.message.toLowerCase(), contains('gagal'));
      expect(provider.restaurants, isEmpty);

      verify(api.getRestaurants()).called(1);

      verifyNoMoreInteractions(api);
    });

    test('query ditemukan → state data, list berisi hasil pencarian', () async {
      when(api.getRestaurants('sede')).thenAnswer((_) async => dummyRestaurantsSearchResult);
      when(db.isExist(any)).thenAnswer((_) async => false);

      await provider.getRestaurants('sede');

      expect(provider.state, ResultState.data);
      expect(provider.restaurants, isNotEmpty);
      expect(provider.restaurants.length, dummyRestaurantsSearchResult.length);
      expect(provider.restaurants.first.name.toLowerCase(), contains('sede'));

      verify(api.getRestaurants('sede')).called(1);
      verify(db.isExist(any)).called(dummyRestaurantsSearchResult.length);

      verifyNoMoreInteractions(api);
      verifyNoMoreInteractions(db);
    });

    test('query tidak ditemukan → state data, list kosong', () async {
      when(api.getRestaurants('xxx')).thenAnswer((_) async => []);
      when(db.isExist(any)).thenAnswer((_) async => false);

      await provider.getRestaurants('xxx');

      expect(provider.state, ResultState.data);
      expect(provider.restaurants, isEmpty);

      verify(api.getRestaurants('xxx')).called(1);

      verifyNoMoreInteractions(api);
    });
  });
}
