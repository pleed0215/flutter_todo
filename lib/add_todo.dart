import 'package:flutter/material.dart';
import 'package:flutter_todo/todo.dart';
import 'package:sqflite/sqlite_api.dart';

class AddTodoPage extends StatefulWidget {
  final Future<Database> db;
  const AddTodoPage({Key? key, required this.db}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController? titleController;
  TextEditingController? contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('할 일 추가하기')),
        body: Center(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "제목"))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: contentController,
                    decoration: const InputDecoration(labelText: "내용"))),
            ElevatedButton(
                onPressed: () {
                  Todo todo = Todo(
                      title: titleController!.value.text,
                      content: contentController!.value.text,
                      active: 0);
                  Navigator.of(context).pop(todo);
                },
                child: const Text('할일 저장'))
          ],
        )));
  }
}
