import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка приложения
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.checklist_rtl,
                  size: 60,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 32),
              // Название приложения
              Text(
                'To-Do List v1.0',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              // Описание приложения
              Text(
                'Приложение для\nуправления задачами\nс функцией погоды.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              // Информация о разработчике
              Text(
                'Разработано: [Имя]',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutDetailsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Подробнее'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Экран с подробной информацией (демонстрация Navigator.push)
class AboutDetailsScreen extends StatelessWidget {
  const AboutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подробнее'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Приложение To-Do List позволяет управлять задачами, '
          'отмечать выполненные и удалять ненужные. '
          'На главном экране отображается погода для выбранного города.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

