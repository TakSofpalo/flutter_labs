import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
      ),
      body: Column(
        children: [
          // Блок с погодой
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                // Иконка погоды
                Icon(
                  Icons.wb_cloudy,
                  size: 48,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 16),
                // Информация о погоде
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Москва',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+15°C, облачно',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ощущается как +13°C',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Поле ввода для новой задачи
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '+ Новая задача...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    // Пока без логики обработки ввода
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: null, // Пока без логики
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const Divider(),
          // Список задач
          Expanded(
            child: ListView(
              children: const [
                // Выполненная задача
                TaskItem(
                  title: 'Сделать ЛР по Flutter',
                  isCompleted: true,
                ),
                // Активные задачи
                TaskItem(
                  title: 'Купить молоко',
                  isCompleted: false,
                ),
                TaskItem(
                  title: 'Записаться к врачу',
                  isCompleted: false,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: null, // Пока без логики
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'О прил.',
          ),
        ],
      ),
    );
  }
}

// Виджет для элемента задачи
class TaskItem extends StatelessWidget {
  final String title;
  final bool isCompleted;

  const TaskItem({
    super.key,
    required this.title,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: null, // Пока без логики
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : null,
        ),
      ),
      onTap: null, // Пока без логики
    );
  }
}

