import 'package:flutter/material.dart';
import 'package:flutter_todo/todo.dart';

class TodoListComponent extends StatefulWidget {
  List<Todo> list;
  Function deleteTodo;
  Function updateTodo;

  TodoListComponent({Key? key, required this.list, required this.deleteTodo, required this.updateTodo}) : super(key: key);

  @override
  _TodoListComponentState createState() => _TodoListComponentState();
}

class _TodoListComponentState extends State<TodoListComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          Todo todo = widget.list[index];
          return ListTile(
            onLongPress: () async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${todo.id}: ${todo.title}'),
                      content: const Text('삭제 하시겠습니까?'),
                      actions: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red.shade800)),
                            onPressed: () {
                              Navigator.of(context).pop(todo);
                            },
                            child: const Text('삭제하기',
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('아니오')),
                      ],
                    );
                  });
              if (result != null) {
                widget.deleteTodo(result as Todo);
              }
            },
            onTap: () async {
              TextEditingController controller =
                  TextEditingController(text: todo.content);
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${todo.id}: ${todo.title}'),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.text,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todo.active = todo.active == 0 ? 1 : 0;
                                todo.content = controller.value.text;
                              });
                              Navigator.of(context).pop(todo);
                            },
                            child: const Text('토글&수정')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('아니오')),
                      ],
                    );
                  });
              if (result != null) {
                widget.updateTodo(result as Todo);
              }
            },
            title: Text(todo.title!, style: const TextStyle(fontSize: 20.0)),
            subtitle: Column(
              children: [
                Text(todo.content!),
                Text('체크: ${todo.active == 1 ? 'true' : 'false'}'),
                Container(height: 1, color: Colors.blue)
              ],
            ),
          );
        },
        itemCount: widget.list.length);
    ;
  }
}
