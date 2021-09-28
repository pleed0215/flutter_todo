import 'package:flutter/material.dart';
import 'package:flutter_todo/components/todo_list.dart';
import 'package:flutter_todo/todo.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseApp extends StatefulWidget {
  final Future<Database> db;

  const DatabaseApp({Key? key, required this.db}) : super(key: key);

  @override
  _DatabaseAppState createState() => _DatabaseAppState();
}

class _DatabaseAppState extends State<DatabaseApp> {
  Future<List<Todo>>? todoList;

  void insertTodo(Todo todo) async {
    final Database database = await widget.db;
    int id = await database.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    var list = await todoList;
    Todo result = todo;
    result.id = id;
    setState(() {
      list?.add(result);
    });
  }

  Future<List<Todo>> getTodos() async {
    try {
      final Database db = await widget.db;
      final List<Map<String, dynamic>> maps = await db.query('todos');

      return List.generate(maps.length, (i) {
        final current = maps[i];
        int active = current['active'] == 1 ? 1 : 0;
        return Todo(
            id: current['id'],
            title: current['title'],
            content: current['content'],
            active: active);
      });
    } catch (e) {
      print(e.toString());
      return List.empty();
    }
  }

  void updateTodo(Todo todo) async {
    final Database db = await widget.db;
    await db
        .update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
    var list = await todoList;
    setState(() {
      int index = list!.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        list[index] = todo;
      }
    });
  }

  void deleteTodo(Todo todo) async {
    final Database db = await widget.db;
    await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
    var list = await todoList;
    setState(() {
      int index = list!.indexWhere((t) => t.id == todo.id);
      list.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Example'),
        actions: [
          TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/clear');
                setState(() {
                  todoList = getTodos();
                });
              },
              child: const Text('완료한 일', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Center(
          child: FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return TodoListComponent(
                          list: snapshot.data as List<Todo>,
                          deleteTodo: deleteTodo,
                          updateTodo: updateTodo);
                    } else {
                      return const Text('No data');
                    }
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  default:
                    return const CircularProgressIndicator();
                }
              },
              future: todoList)),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final todo = await Navigator.of(context).pushNamed('/add');
            if (todo != null) {
              insertTodo(todo as Todo);
            }
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
