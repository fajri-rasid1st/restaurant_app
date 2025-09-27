// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/models/restaurant_detail.dart';
import 'package:restaurant_app/providers/api_providers/restaurant_detail_provider.dart';
import '../helpers/dummies.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockRestaurantApi api;
  late MockRestaurantDatabase db;
  late RestaurantDetailProvider provider;

  setUp(() {
    api = MockRestaurantApi();
    db = MockRestaurantDatabase();
    provider = RestaurantDetailProvider(
      apiService: api,
      databaseService: db,
    );
  });

  group('RestaurantDetailProvider', () {
    test('state awal loading dan properti terdefinisi namun masih kosong', () {
      expect(provider.state, ResultState.loading);
      expect(provider.message, allOf(isA<String>(), isEmpty));
      expect(provider.restaurantDetail, allOf(isA<RestaurantDetail?>(), isNull));
    });

    group('getRestaurantDetail', () {
      test('fetch detail restoran sukses → state data, detail terisi', () async {
        when(api.getRestaurantDetail('r1')).thenAnswer((_) async => dummyRestaurantDetail);
        when(db.isExist(any)).thenAnswer((_) async => false);

        await provider.getRestaurantDetail('r1');

        expect(provider.state, ResultState.data);
        expect(provider.restaurantDetail, isNotNull);
        expect(provider.restaurantDetail!.id, 'r1');

        verify(api.getRestaurantDetail('r1')).called(1);
        verify(db.isExist(any)).called(1);

        verifyNoMoreInteractions(api);
        verifyNoMoreInteractions(db);
      });

      test('fetch detail restoran gagal → state error, message mengandung kata "gagal"', () async {
        when(api.getRestaurantDetail('r1')).thenThrow(Exception('Server error'));

        await provider.getRestaurantDetail('r1');

        expect(provider.state, ResultState.error);
        expect(provider.message.toLowerCase(), contains('gagal'));
        expect(provider.restaurantDetail, isNull);

        verify(api.getRestaurantDetail('r1')).called(1);

        verifyNoMoreInteractions(api);
      });
    });

    group('sendCustomerReview', () {
      test('sukses mengirim review → message sukses, daftar review bertambah', () async {
        // Arrange
        when(api.getRestaurantDetail('r1')).thenAnswer((_) async => dummyRestaurantDetail);
        when(db.isExist(any)).thenAnswer((_) async => false);

        await provider.getRestaurantDetail('r1');

        verify(api.getRestaurantDetail('r1')).called(1);
        verify(db.isExist(any)).called(1);

        // Act
        when(
          api.sendCustomerReview(
            id: 'r1',
            name: 'Ani',
            review: 'Enak bgt',
          ),
        ).thenAnswer((_) async => dummyReviewsAfterPost);

        await provider.sendCustomerReview(
          id: 'r1',
          name: 'Ani',
          review: 'Enak bgt',
        );

        // Assert
        expect(provider.restaurantDetail, isNotNull);
        expect(provider.restaurantDetail!.customerReviews.length, dummyReviewsAfterPost.length);
        expect(provider.restaurantDetail!.customerReviews.last.review, 'Enak bgt');
        expect(provider.message.toLowerCase(), contains('berhasil'));

        verify(
          api.sendCustomerReview(
            id: 'r1',
            name: 'Ani',
            review: 'Enak bgt',
          ),
        ).called(1);

        verifyNoMoreInteractions(api);
        verifyNoMoreInteractions(db);
      });

      test('gagal mengirim review → message gagal, daftar review tidak diperbarui', () async {
        // Arrange
        when(api.getRestaurantDetail('r1')).thenAnswer((_) async => dummyRestaurantDetail);
        when(db.isExist(any)).thenAnswer((_) async => false);

        await provider.getRestaurantDetail('r1');

        verify(api.getRestaurantDetail('r1')).called(1);
        verify(db.isExist(any)).called(1);

        // Act
        when(
          api.sendCustomerReview(
            id: 'r1',
            name: 'Ani',
            review: 'Enak bgt',
          ),
        ).thenThrow(Exception('Bad Request'));

        await provider.sendCustomerReview(
          id: 'r1',
          name: 'Ani',
          review: 'Enak bgt',
        );

        // Assert
        expect(provider.restaurantDetail, isNotNull);
        expect(provider.restaurantDetail!.customerReviews.length, isNot(dummyReviewsAfterPost.length));
        expect(provider.message.toLowerCase(), contains('gagal'));

        verify(
          api.sendCustomerReview(
            id: 'r1',
            name: 'Ani',
            review: 'Enak bgt',
          ),
        ).called(1);

        verifyNoMoreInteractions(api);
        verifyNoMoreInteractions(db);
      });
    });
  });
}
