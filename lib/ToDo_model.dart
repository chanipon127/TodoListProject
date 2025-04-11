class Todo {
  final int id; //หมายเลขประจำของแต่ละรายการ
  final String title; //ข้อความหรือชื่อของรายการ
  final bool completed; //สถานะว่าเสร็จหรือยัง

  Todo(
      {required this.id,
      required this.title,
      required this.completed}); //เป็น named constructor บังคับให้ต้องใส่ทุกค่าตอนสร้าง object

  factory Todo.fromJson(Map<String, dynamic> json) {
    //รับข้อมูล JSON จาก API
    return Todo(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        //ส่งข้อมูลไปยัง API
        'title': title,
        'completed': completed,
      };
}
