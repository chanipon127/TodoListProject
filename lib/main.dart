import 'package:flutter/material.dart';
import 'package:flutter_application_1/TodoListScreen.dart';

// ตัวแปรที่ใช้ควบคุม Theme ของแอป (Light / Dark)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp()); // เรียกใช้งานแอป
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier, // ฟังการเปลี่ยนแปลงของ Theme
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // ปิด banner debug ที่มุมขวาบน
          title: 'To-Do App',
          theme: ThemeData.light(), // กำหนดธีมแบบสว่าง
          darkTheme: ThemeData.dark(), // กำหนดธีมแบบมืด
          themeMode: currentMode, // ใช้ Theme ตามค่าจาก ValueNotifier
          home: const TodoListScreen(), // หน้าแรกของแอป
        );
      },
    );
  }
}
