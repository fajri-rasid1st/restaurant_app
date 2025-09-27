// Package imports:
import 'package:mockito/annotations.dart';

// Project imports:
import 'package:restaurant_app/services/api/restaurant_api.dart';
import 'package:restaurant_app/services/db/restaurant_database.dart';

@GenerateMocks([RestaurantApi, RestaurantDatabase])
void main() {}
