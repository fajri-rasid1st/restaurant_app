import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

import 'restaurant_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // Pada group test ini akan dibuat skenario testing mengambil data daftar restaurant
  // dari server melalui API dengan melakukan mocking saat response berhasil ataupun
  // error. Namun sesuai fungsi yang diuji, hanya akan mengembalikan restaurant
  // pada index pertama saja.
  group('Fetch Restaurant', () {
    // Arrange
    late MockClient client;

    setUp(() => client = MockClient());

    test(
      'Returns Restaurant if the http call completes successfully',
      () async {
        // Act
        when(client.get(Uri.parse('${Const.baseUrl}/search?q=kafein')))
            .thenAnswer((_) async {
          return http.Response(restaurantResultTest, 200);
        });

        // Assert
        expect(await getRestaurants(client, 'kafein'), isA<Restaurant>());
      },
    );

    test(
      'Throws an exception if the http call completes with an error',
      () {
        // Act
        when(client.get(Uri.parse('${Const.baseUrl}/search?q=kafein')))
            .thenAnswer((_) async => http.Response('Error', 404));

        // Assert
        expect(getRestaurants(client, 'kafein'), throwsException);
      },
    );
  });

  // Pada group test ini akan dibuat skenario testing mengambil data detail restaurant
  // dari server melalui API dengan melakukan mocking saat response berhasil ataupun
  // error.
  group('Fetch RestaurantDetail', () {
    // Arrange
    late MockClient client;

    setUp(() => client = MockClient());

    test(
      'Return RestaurantDetail if the http call completes successfully',
      () async {
        // Act
        when(client.get(
          Uri.parse('${Const.baseUrl}/detail/rqdv5juczeskfw1e867'),
        )).thenAnswer((_) async {
          return http.Response(restaurantDetailResultTest, 200);
        });

        // Assert
        expect(
          await getRestaurantDetail(client, 'rqdv5juczeskfw1e867'),
          isA<RestaurantDetail>(),
        );
      },
    );

    test(
      'Throws an exception if the http call completes with an error',
      () {
        // Act
        when(client.get(
          Uri.parse('${Const.baseUrl}/detail/rqdv5juczeskfw1e867'),
        )).thenAnswer((_) async => http.Response('Error', 404));

        // Assert
        expect(
          getRestaurantDetail(client, 'rqdv5juczeskfw1e867'),
          throwsException,
        );
      },
    );
  });
}

/// Fungsi pertama yang akan di uji
///
/// * mengembalikan restaurant pada index pertama jika response berhasil
/// * throw exception error jika gagal
Future<Restaurant> getRestaurants(http.Client client, String query) async {
  try {
    final response =
        await client.get(Uri.parse('${Const.baseUrl}/search?q=$query'));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);

      final List restaurants = (results as Map<String, dynamic>)['restaurants'];

      return restaurants
          .map((restaurant) => Restaurant.fromMap(restaurant))
          .toList()
          .first;
    } else {
      throw Exception();
    }
  } catch (e) {
    throw Exception();
  }
}

/// Fungsi kedua yang akan di uji
///
/// * mengembalikan restaurant detail jika response berhasil
/// * throw exception error jika gagal
Future<RestaurantDetail> getRestaurantDetail(
  http.Client client,
  String id,
) async {
  try {
    final response = await client.get(Uri.parse('${Const.baseUrl}/detail/$id'));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);

      final restaurant = (results as Map<String, dynamic>)['restaurant'];

      return RestaurantDetail.fromMap(restaurant);
    } else {
      throw Exception();
    }
  } catch (e) {
    throw Exception();
  }
}

// Hasil jika response berhasil
const String restaurantResultTest =
    '{"error": false, "founded": 1, "restaurants": [{"id": "uewq1zg2zlskfw1e867", "name": "Kafein", "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,", "pictureId": "15", "city": "Aceh", "rating": 4.6}]}';

const String restaurantDetailResultTest =
    '{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","rating":4.2,"categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"},{"name":"Bebek crepes"},{"name":"Salad lengkeng"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"},{"name":"Jus apel"},{"name":"Jus jeruk"},{"name":"Coklat panas"},{"name":"Air"},{"name":"Es kopi"},{"name":"Jus alpukat"},{"name":"Jus mangga"},{"name":"Teh manis"},{"name":"Kopi espresso"},{"name":"Minuman soda"},{"name":"Jus tomat"}]},"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"tester","review":"test","date":"10 April 2022"}]}}';
