import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/task.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Блок с погодой
              _buildWeatherWidget(context, viewModel),
              // Поле ввода для новой задачи
              _buildTaskInput(context, viewModel),
              const Divider(),
              // Список задач
              Expanded(
                child: _buildTasksList(context, viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: viewModel.isLoadingWeather
          ? const Center(child: CircularProgressIndicator())
          : viewModel.weatherError != null
              ? Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        viewModel.weatherError!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red.shade700,
                            ),
                      ),
                    ),
                  ],
                )
              : viewModel.weather != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.wb_cloudy,
                          size: 48,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.weather!.city,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${viewModel.weather!.temperature.toStringAsFixed(0)}°C, ${viewModel.weather!.description}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ощущается как ${viewModel.weather!.feelsLike.toStringAsFixed(0)}°C',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => viewModel.loadWeather(),
                          tooltip: 'Обновить погоду',
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildTaskInput(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: '+ Новая задача...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                viewModel.addTask(value);
                _textController.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              final text = _textController.text;
              viewModel.addTask(text);
              _textController.clear();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.tasksError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.tasksError!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red.shade700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadTasks(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (viewModel.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_rtl,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет задач',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте новую задачу',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.tasks.length,
      itemBuilder: (context, index) {
        final task = viewModel.tasks[index];
        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 32,
            ),
          ),
          confirmDismiss: (direction) async {
            return true;
          },
          onDismissed: (direction) {
            viewModel.deleteTask(task.id);
          },
          child: TaskItem(
            task: task,
            onToggle: () => viewModel.toggleTask(task.id),
          ),
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : null,
        ),
      ),
      onTap: onToggle,
    );
  }
}
