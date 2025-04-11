import 'dart:convert';
import 'package:flutter_application_1/ToDo_model.dart';
import 'package:http/http.dart' as http;

const String apiUrl =
    'https://67f933f8094de2fe6ea0ce8b.mockapi.io/todos'; // ฐานข้อมูล MockAPI นี้เก็บข้อมูล To-Do ทั้งหมดที่จะเรียกใช้

Future<List<Todo>> fetchTodos() async {
  //ดึงรายการทั้งหมด: fetchTodos()
  final response =
      await http.get(Uri.parse(apiUrl)); //ส่ง HTTP GET ไปยัง URL เพื่อดึง To-Do
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body); //แปลงข้อมูล JSON เป็น List
    return jsonResponse
        .map((todo) => Todo.fromJson(todo))
        .toList(); //แปลงแต่ละ JSON object เป็น Todo model
  } else {
    throw Exception('Failed to load todos');
  }
}

Future<void> addTodo(String title) async {
  //เพิ่มงานใหม่
  await http.post(
    //ส่ง HTTP POST เพื่อเพิ่มรายการ
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': title,
      'completed': false
    }), //เพิ่มใหม่จะยังไม่เสร็จโดยอัตโนมัติ
  );
}

Future<void> deleteTodo(int id) async {
  //ลบงาน
  await http.delete(Uri.parse(
      '$apiUrl/$id')); //ส่ง DELETE request ไปยัง /todos/{id} → API จะลบรายการนั้นออก
}

Future<void> updateTodo(int id, bool completed) async {
  //เปลี่ยนสถานะ (เสร็จ / ไม่เสร็จ)
  await http.put(
    //ส่ง HTTP PUT ไปที่ ID
    Uri.parse('$apiUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'completed': completed}),
  );
}
