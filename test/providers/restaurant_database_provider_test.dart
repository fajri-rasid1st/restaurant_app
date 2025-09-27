// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:restaurant_app/models/restaurant_favorite.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import '../helpers/dummies.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockRestaurantDatabase db;
  late RestaurantDatabaseProvider provider;

  setUp(() {
    db = MockRestaurantDatabase();
    provider = RestaurantDatabaseProvider(db);
  });

  group('RestaurantDatabaseProvider', () {
    test('state awal: favorites=[] dan message=""', () {
      expect(provider.favorites, allOf(isA<List<RestaurantFavorite>>(), isEmpty));
      expect(provider.message, equals(''));
    });

    test('getAllFavorites() → memuat daftar favorit dari DB', () async {
      when(db.all()).thenAnswer((_) async => dummyRestaurantFavoriteList);

      await provider.getAllFavorites();

      expect(provider.favorites, hasLength(2));
      expect(provider.favorites.first.restaurantId, equals('r2'));

      verify(db.all()).called(1);

      verifyNoMoreInteractions(db);
    });

    group('addToFavorites()', () {
      test('berhasil insert → message terisi, getAllFavorites() dipanggil', () async {
        when(db.insert(any)).thenAnswer((_) async => 1);

        when(db.all()).thenAnswer((_) async => [dummyRestaurantFavorite1]);

        await provider.addToFavorites(dummyRestaurantFavorite1);

        // karena addToFavorites() memanggil getAllFavorites(),
        // pastikan interaksi all() benar-benar terjadi.
        await untilCalled(db.all());

        expect(provider.message, equals('Restoran ditambahkan ke favorit'));
        expect(provider.favorites, hasLength(1));
        expect(provider.favorites.single.restaurantId, 'r1');

        verify(db.insert(dummyRestaurantFavorite1)).called(1);
        verify(db.all()).called(1);

        verifyNoMoreInteractions(db);
      });
    });

    group('removeFromFavorites()', () {
      test('berhasil delete → message terisi, getAllFavorites() dipanggil', () async {
        when(db.delete('r1')).thenAnswer((_) async => 1);
        when(db.all()).thenAnswer((_) async => []);

        await provider.removeFromFavorites('r1');

        await untilCalled(db.all());

        expect(provider.message, equals('Restoran dihapus dari favorit'));
        expect(provider.favorites, isEmpty);

        verify(db.delete('r1')).called(1);
        verify(db.all()).called(1);

        verifyNoMoreInteractions(db);
      });
    });
  });
}
