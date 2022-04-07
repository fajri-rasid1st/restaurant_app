import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'restaurant_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Fetch restaurants tesing', () {
    test(
      'Returns restaurant if the http call completes successfully',
      () async {
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get(Uri.parse('${Const.baseUrl}/search?q=kafein')))
            .thenAnswer((_) async {
          return http.Response(resultTest, 200);
        });

        expect(await getRestaurants(client, 'kafein'), isA<Restaurant>());
      },
    );

    test('Throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('${Const.baseUrl}/search?q=kafein')))
          .thenAnswer((_) async {
        return http.Response('Error', 404);
      });

      expect(getRestaurants(client, 'kafein'), throwsException);
    });
  });
}

/// Fungsi yang akan di uji
Future<Restaurant> getRestaurants(http.Client client, String query) async {
  final url = '${Const.baseUrl}/search?q=$query';

  final uri = Uri.parse(url);

  try {
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);

      final List restaurants = (results as Map<String, dynamic>)['restaurants'];

      return restaurants.map((restaurant) {
        return Restaurant.fromMap(restaurant);
      }).toList()[0];
    } else {
      throw Exception('Failed to load restaurants');
    }
  } catch (e) {
    throw Exception('Failed to load restaurants');
  }
}

// Hasil jika response berhasil
const String resultTest =
    '{"error": false, "founded": 1, "restaurants": [{"id": "uewq1zg2zlskfw1e867", "name": "Kafein", "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,", "pictureId": "15", "city": "Aceh", "rating": 4.6}]}';
