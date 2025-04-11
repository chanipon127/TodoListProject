import 'package:flutter/material.dart';
import 'package:flutter_application_1/TodoListScreen.dart';

// ควบคุม Theme ของแอป (Light / Dark)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  //เป็น widget หลักของแอป ที่จัดการเรื่อง Theme และนำไปยัง TodoListScreen
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To-Do App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: const TodoListScreen(), //หน้าจอแสดง To-Do เป็นหน้าแรกของแอป
        );
      },
    );
  }
}
