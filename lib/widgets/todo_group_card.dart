import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class TodoGroupCard extends StatelessWidget {
  const TodoGroupCard({
    Key? key,
    required this.groups,
    required CollectionReference<Map<String, dynamic>> collection,
  })  : _collection = collection,
        super(key: key);

  final List<TodoGroup> groups;
  final CollectionReference<Map<String, dynamic>> _collection;

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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        value: todo.isDone,
                                        onChanged: (value) {
                                          _collection
                                              .doc(todo.id)
                                              .update({'isDone': value});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
