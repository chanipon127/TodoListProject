import 'package:flutter/material.dart';
import 'package:flutter_application_1/ToDo_model.dart';
import 'package:flutter_application_1/api.dart';
import 'package:flutter_application_1/main.dart';

class TodoListScreen extends StatefulWidget {
  //หน้าจอหลักที่ใช้แสดงรายการ To-Do
  const TodoListScreen({super.key});
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> futureTodos; //เก็บข้อมูลรายการ To-Do ที่ดึงจาก API
  final TextEditingController _controller =
      TextEditingController(); //ใช้ควบคุม TextField สำหรับรับชื่อรายการใหม่

  @override
  void initState() {
    //เมื่อ widget ถูกสร้าง จะโหลดข้อมูล To-Do จาก API
    super.initState();
    futureTodos = fetchTodos();
  }

  void _addTodo() async {
    //เพิ่ม To-Do
    if (_controller.text.isNotEmpty) {
      await addTodo(_controller.text); // เรียก API เพิ่มงานใหม่
      setState(() {
        futureTodos = fetchTodos(); // โหลดข้อมูลใหม่
      });
      _controller.clear(); // ล้างช่อง input
    }
  }

  void _deleteTodo(int id) async {
    //ลบ To-Do จะลบรายการตาม id แล้วโหลดใหม่
    await deleteTodo(id);
    setState(() {
      futureTodos = fetchTodos();
    });
  }

  void _toggleComplete(Todo todo) async {
    //อัปเดตสถานะงาน
    await updateTodo(todo.id, !todo.completed); // สลับสถานะ
    setState(() {
      futureTodos = fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌓 To-Do List"),
        centerTitle: true,
        backgroundColor:
            isDark ? Colors.black : const Color.fromARGB(255, 110, 186, 240),
        actions: [
          IconButton(
            ////ปุ่มสลับธีม (dark/light) โดยใช้ตัวแปร global themeNotifier
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // ป้อนชื่อรายการ
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      prefixIcon: Icon(Icons.edit, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 82, 134, 198),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add, size: 28),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              //ใช้ FutureBuilder รอข้อมูลจาก API
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Card(
                          elevation: 4, //ความสูงของเงา
                          shape: RoundedRectangleBorder(
                              //ทำให้มุมของ Card โค้งมน
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.white, //สีพื้นหลังของ Card เป็น สีขาว
                          child: CheckboxListTile(
                            //ใช้แสดงรายการแบบมี checkbox + ข้อความ + widget เสริมด้านขวา
                            value: todo
                                .completed, //กำหนดว่าช่อง checkbox ถูกติ๊กหรือยัง
                            onChanged: (_) => _toggleComplete(
                                todo), //ถ้ามีการเปลี่ยนสถานะ (ติ๊กหรือยกเลิกติ๊ก) จะเรียกฟังก์ชัน _toggleComplete(todo)
                            title: Text(
                              //แสดงชื่อของ To-Do
                              todo.title,
                              style: TextStyle(
                                decoration: todo.completed
                                    ? TextDecoration
                                        .lineThrough //ถ้าทำเสร็จ (completed == true) ให้ขีดฆ่าข้อความ
                                    : TextDecoration.none,
                                fontSize: 16,
                                color: todo.completed
                                    ? Colors.grey
                                    : Colors
                                        .black, //ถ้าทำเสร็จ ให้ข้อความเป็นสีเทา
                              ),
                            ),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete, //เป็นปุ่มถังขยะ
                                  color: Colors.redAccent),
                              onPressed: () => _deleteTodo(todo
                                  .id), //ถ้ากดปุ่มลบ จะเรียก _deleteTodo() เพื่อลบ To-Do ออก
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
