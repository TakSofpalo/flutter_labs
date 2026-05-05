import 'package:flutter/foundation.dart';
import '../../domain/models/task.dart';
import '../../domain/models/weather.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/weather_repository.dart';

/// ViewModel для экрана Home (MVVM паттерн)
class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final WeatherRepository _weatherRepository;

  HomeViewModel(this._taskRepository, this._weatherRepository) {
    _loadData();
  }

  // Состояние задач
  List<Task> _tasks = [];
  bool _isLoadingTasks = false;
  String? _tasksError;

  // Состояние погоды
  Weather? _weather;
  bool _isLoadingWeather = false;
  String? _weatherError;

  // Геттеры
  List<Task> get tasks => _tasks;
  bool get isLoadingTasks => _isLoadingTasks;
  String? get tasksError => _tasksError;

  Weather? get weather => _weather;
  bool get isLoadingWeather => _isLoadingWeather;
  String? get weatherError => _weatherError;

  /// Загрузить все данные (задачи и погоду)
  Future<void> _loadData() async {
    await Future.wait([
      loadTasks(),
      loadWeather(),
    ]);
  }

  /// Загрузить задачи из репозитория
  Future<void> loadTasks() async {
    _isLoadingTasks = true;
    _tasksError = null;
    notifyListeners();

    try {
      _tasks = await _taskRepository.getTasks();
      _tasksError = null;
    } catch (e) {
      _tasksError = 'Ошибка загрузки задач: $e';
    } finally {
      _isLoadingTasks = false;
      notifyListeners();
    }
  }

  /// Загрузить данные о погоде
  Future<void> loadWeather() async {
    _isLoadingWeather = true;
    _weatherError = null;
    notifyListeners();

    try {
      _weather = await _weatherRepository.getWeather();
      _weatherError = null;
    } catch (e) {
      _weatherError = 'Ошибка загрузки погоды: $e';
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  /// Добавить новую задачу
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      isCompleted: false,
    );

    try {
      final success = await _taskRepository.addTask(newTask);
      if (success) {
        await loadTasks();
      }
    } catch (e) {
      _tasksError = 'Ошибка добавления задачи: $e';
      notifyListeners();
    }
  }

  /// Переключить статус выполнения задачи
  Future<void> toggleTask(String taskId) async {
    try {
      final success = await _taskRepository.toggleTask(taskId);
      if (success) {
        await loadTasks();
      }
    } catch (e) {
      _tasksError = 'Ошибка обновления задачи: $e';
      notifyListeners();
    }
  }

  /// Удалить задачу
  Future<void> deleteTask(String taskId) async {
    try {
      final success = await _taskRepository.deleteTask(taskId);
      if (success) {
        await loadTasks();
      }
    } catch (e) {
      _tasksError = 'Ошибка удаления задачи: $e';
      notifyListeners();
    }
  }

  /// Обновить погоду для указанного города
  Future<void> updateWeatherForCity(String city) async {
    _isLoadingWeather = true;
    _weatherError = null;
    notifyListeners();

    try {
      _weather = await _weatherRepository.getWeatherForCity(city);
      _weatherError = null;
    } catch (e) {
      _weatherError = 'Ошибка загрузки погоды: $e';
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }
}
