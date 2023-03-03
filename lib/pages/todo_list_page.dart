import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tasks/models/todo.dart';
import 'package:tasks/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> tasks = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Adicione uma tarefa",
                            hintText: 'Ex. Estudar Flutter'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        Todo newTodo =
                            Todo(title: text, dateTime: DateTime.now());
                        setState(() => {tasks.add(newTodo)});
                        todoController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo task in tasks)
                        TodoListItem(todo: task, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text("Você possui ${tasks.length} tarefas pendentes"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: showDeleteTodosConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00d7f3),
                            padding: const EdgeInsets.all(14)),
                        child: const Text('Limpar tudo'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    if (tasks.length > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Limpar tudo ?'),
          content: const Text(
              'Você tem certeza que deseja apagar todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: closeDialog,
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff00d7f3)),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: deleteAllTodos,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Limpar tudo'),
            ),
          ],
        ),
      );
    }
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  void deleteAllTodos() {
    setState(() {
      tasks.clear();
    });

    closeDialog();
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = tasks.indexOf(todo);
    setState(() {
      tasks.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            'Tarefa: ${todo.title} foi removida com sucesso',
            style: const TextStyle(color: Color(0xff060708)),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: const Color(0xff00d7f3),
            onPressed: () {
              setState(() {
                tasks.insert(deletedTodoPos!, deletedTodo!);
              });
            },
          ),
          duration: const Duration(seconds: 5)),
    );
  }
}
