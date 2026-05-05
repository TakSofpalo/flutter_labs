import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/task.dart';

/// Сервис для работы с локальным хранилищем (shared_preferences)
class LocalStorageService {
  static const String _tasksKey = 'tasks';
  static const String _cityKey = 'selected_city';

  /// Получить все задачи из локального хранилища
  Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      
      if (tasksJson == null) {
        return [];
      }

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Сохранить задачи в локальное хранилище
  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
      return await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      return false;
    }
  }

  /// Получить выбранный город
  Future<String> getSelectedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_cityKey) ?? 'Vologda';
    } catch (e) {
      return 'Vologda';
    }
  }

  /// Сохранить выбранный город
  Future<bool> saveSelectedCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_cityKey, city);
    } catch (e) {
      return false;
    }
  }
}
