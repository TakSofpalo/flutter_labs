/// Модель данных о погоде
class Weather {
  final String city;
  final double temperature;
  final double feelsLike;
  final String description;
  final String? icon;

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'description': description,
      'icon': icon,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String?,
    );
  }
}
