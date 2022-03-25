import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoGroupCard extends StatelessWidget {
  const TodoGroupCard({
    Key? key,
    required this.group,
    required CollectionReference<Map<String, dynamic>> collection,
  })  : _collection = collection,
        super(key: key);

  final CollectionReference<Map<String, dynamic>> _collection;
  final group;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: group.isDone ? 0.2 : 1,
      child: Column(
        children: group.todos
            .map(
              (todo) => Dismissible(
                key: ValueKey(todo.id!),
                onDismissed: (direction) {
                  _collection.doc(todo.id).delete();
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
                          _collection.doc(todo.id).update({'isDone': value});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
