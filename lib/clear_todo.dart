import 'package:flutter/material.dart';
import 'package:flutter_todo/todo.dart';
import 'package:sqflite/sqlite_api.dart';

class ClearedPage extends StatefulWidget {
  Future<Database> db;
  ClearedPage({Key? key, required this.db}) : super(key: key);

  @override
  _ClearedPageState createState() => _ClearedPageState();
}

class _ClearedPageState extends State<ClearedPage> {
  Future<List<Todo>>? todoList;

  Future<List<Todo>> getClearedList() async {
    try {
      final Database db = await widget.db;
      List<Map<String, dynamic>> list;
      list = await db.rawQuery('SELECT * FROM todos WHERE active=1');

      return List.generate(
          list.length,
          (i) => Todo(
              id: list[i]['id'],
              title: list[i]['title'],
              content: list[i]['content'],
              active: list[i]['active']));
    } catch (e) {
      print(e.toString());
      return List.empty();
    }
  }

  void _clearAll() async {
    final Database db = await widget.db;
    await db.rawDelete("DELETE FROM todos where active=1");
    var list = await todoList;
    setState(() {
      list!.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    todoList = getClearedList();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('완료된 목록')),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("전체 삭제"),
                      content: const Text("정말로 완료 한 일들을 삭제하시겠습니까?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('예',
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('아니오'))
                      ],
                    );
                  });

              if ((result as bool)) {
                _clearAll();
              }
            },
            child: const Icon(Icons.delete_forever)),
        body: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];
                        return ListTile(
                            title: Text(todo.title!,
                                style: const TextStyle(fontSize: 20.0)),
                            subtitle: Column(
                              children: [
                                Text(todo.content!),
                                Text(
                                    '체크: ${todo.active == 1 ? 'true' : 'false'}'),
                                Container(height: 1, color: Colors.blue)
                              ],
                            ));
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
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
            future: todoList));
  }
}
