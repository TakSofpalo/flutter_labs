import '../../domain/models/weather.dart';
import '../services/weather_service.dart';
import '../services/local_storage_service.dart';

/// Репозиторий для управления данными о погоде
class WeatherRepository {
  final WeatherService _weatherService;
  final LocalStorageService _storageService;

  WeatherRepository(this._weatherService, this._storageService);

  /// Получить данные о погоде для текущего города
  Future<Weather> getWeather() async {
    final city = await _storageService.getSelectedCity();
    return await _weatherService.getWeather(city);
  }

  /// Получить данные о погоде для указанного города
  Future<Weather> getWeatherForCity(String city) async {
    final weather = await _weatherService.getWeather(city);
    // Сохраняем выбранный город
    await _storageService.saveSelectedCity(city);
    return weather;
  }

  /// Получить сохраненный город
  Future<String> getSelectedCity() async {
    return await _storageService.getSelectedCity();
  }
}
