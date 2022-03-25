import 'package:flutter/material.dart';

import '../models.dart';
import 'todo_tile.dart';

class TodoGroupCard extends StatelessWidget {
  const TodoGroupCard({
    Key? key,
    required this.onTodoDeleted,
    required this.onTodoUpdated,
    required this.groups,
  }) : super(key: key);

  final List<TodoGroup> groups;
  final void Function(Todo) onTodoDeleted;
  final void Function(Todo, bool) onTodoUpdated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: ListView(
        children: groups.map((group) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    group.heading,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: group.color,
                          width: 6,
                        ),
                      ),
                    ),
                    child: Opacity(
                      opacity: group.isDone ? 0.2 : 1,
                      child: Column(
                        children: group.todos
                            .map(
                              (todo) => TodoTile(
                                todo: todo,
                                onTodoDeleted: onTodoDeleted,
                                onTodoUpdated: onTodoUpdated,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
