import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home/home_screen.dart';
import 'screens/about_screen.dart';
import 'ui/home/home_view_model.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/weather_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализация зависимостей (Dependency Injection)
    final localStorageService = LocalStorageService();
    final weatherService = WeatherService();
    final taskRepository = TaskRepository(localStorageService);
    final weatherRepository = WeatherRepository(
      weatherService,
      localStorageService,
    );
    final homeViewModel = HomeViewModel(
      taskRepository,
      weatherRepository,
    );

    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: homeViewModel),
        ],
        child: const MainShell(),
      ),
    );
  }
}

/// Оболочка приложения с BottomNavigationBar для переключения между экранами
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
