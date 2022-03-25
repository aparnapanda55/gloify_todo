import 'package:flutter/material.dart';
import '../models.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    Key? key,
    required this.todo,
    required this.onTodoDeleted,
    required this.onTodoUpdated,
  }) : super(key: key);

  final Todo todo;
  final void Function(Todo p1) onTodoDeleted;
  final void Function(Todo p1, bool p2) onTodoUpdated;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id!),
      onDismissed: (direction) {
        onTodoDeleted(todo);
      },
      child: ListTile(
        title: Text(
          todo.text,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              todo.time,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Checkbox(
              hoverColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              value: todo.isDone,
              onChanged: (value) {
                onTodoUpdated(todo, value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
