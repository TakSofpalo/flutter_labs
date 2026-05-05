import '../../domain/models/task.dart';
import '../services/local_storage_service.dart';

/// Репозиторий для управления задачами
class TaskRepository {
  final LocalStorageService _storageService;

  TaskRepository(this._storageService);

  /// Получить все задачи
  Future<List<Task>> getTasks() async {
    return await _storageService.getTasks();
  }

  /// Добавить новую задачу
  Future<bool> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    return await _storageService.saveTasks(tasks);
  }

  /// Обновить задачу
  Future<bool> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    
    if (index != -1) {
      tasks[index] = task;
      return await _storageService.saveTasks(tasks);
    }
    
    return false;
  }

  /// Удалить задачу
  Future<bool> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    return await _storageService.saveTasks(tasks);
  }

  /// Переключить статус выполнения задачи
  Future<bool> toggleTask(String taskId) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == taskId);
    
    if (index != -1) {
      tasks[index] = tasks[index].copyWith(
        isCompleted: !tasks[index].isCompleted,
      );
      return await _storageService.saveTasks(tasks);
    }
    
    return false;
  }
}
