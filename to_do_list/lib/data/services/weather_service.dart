import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/weather.dart';

/// Сервис для работы с Weatherstack API
/// Документация: https://weatherstack.com/documentation
class WeatherService {
  static const String _apiKey = '1c57a414430535ea4c7c2929e3fe693d';
  static const String _baseUrl = 'https://api.weatherstack.com/current';

  /// Получить данные о погоде для указанного города
  Future<Weather> getWeather(String city) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?access_key=$_apiKey&query=${Uri.encodeComponent(city)}',
      );

      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('error')) {
        throw Exception(
          data['error']['info'] as String? ?? 'Ошибка API: ${data['error']['code']}',
        );
      }

      final location = data['location'] as Map<String, dynamic>?;
      final current = data['current'] as Map<String, dynamic>?;

      if (location == null || current == null) {
        throw Exception('Неверный формат ответа API');
      }

      // В API Weatherstack опечатка: "temparature" вместо "temperature"
      final temp = current['temperature'] ?? current['temparature'];
      final feelsLike = current['feelslike'];
      final descriptions = current['weather_descriptions'] as List<dynamic>?;
      final description = descriptions != null && descriptions.isNotEmpty
          ? (descriptions[0] as String).trim()
          : '—';

      return Weather(
        city: location['name'] as String? ?? city,
        temperature: (temp as num?)?.toDouble() ?? 0.0,
        feelsLike: (feelsLike as num?)?.toDouble() ?? 0.0,
        description: description,
        icon: (current['weather_icons'] as List<dynamic>?)?.isNotEmpty == true
            ? current['weather_icons'][0] as String?
            : null,
      );
    } catch (e) {
      return Weather(
        city: city,
        temperature: 0.0,
        feelsLike: 0.0,
        description: 'Не удалось загрузить данные: $e',
      );
    }
  }
}
