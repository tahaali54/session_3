import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:session_3/main.dart';

class MockClient extends Mock implements http.Client {}

main(){
  test('returns a WeatherDetail object if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('http://api.openweathermap.org/data/2.5/weather?q=Karachi,pk&units=metric&APPID=0154ac07e7c0fc3b2556cc8e5da8ad48'))
          .thenAnswer((_) async => http.Response('{ "weather": [ { "id": 721, "main": "Haze", "description": "haze", "icon": "50d" } ], "main": { "temp": 36, "feels_like": 37.96, "temp_min": 36, "temp_max": 36, "pressure": 1003, "humidity": 47 }, "timezone": 18000, "id": 1174872, "name": "Karachi", "cod": 200 }', 200));

      expect(await fetchWeather(client), isA<WeatherDetail>());
    });
}