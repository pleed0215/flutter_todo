import 'package:flutter/material.dart';
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

  void _insertTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Example')),
      body: Center(
          child: FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemBuilder: (context, index) {
                            Todo todo = (snapshot.data as List<Todo>)[index];
                            return Card(
                                child: Column(
                              children: [
                                Text(todo.title!),
                                Text(todo.content!),
                                Text(todo.active == 1 ? 'true' : 'false'),
                              ],
                            ));
                          },
                          itemCount: (snapshot.data as List<Todo>).length);
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
              _insertTodo(todo as Todo);
            }
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
