// Базовый виджет-тест приложения To-Do List.

import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/main.dart';

void main() {
  testWidgets('Главный экран отображает заголовок и вкладки', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    // Даём время на рендеринг UI (не ждём завершения всех асинхронных операций)
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Проверяем заголовок главного экрана
    expect(find.text('Мои задачи'), findsOneWidget);

    // Проверяем подпись вкладки в нижней навигации
    expect(find.text('Задачи'), findsOneWidget);
    expect(find.text('О прил.'), findsOneWidget);
  });
}
