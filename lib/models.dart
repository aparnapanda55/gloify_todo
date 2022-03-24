import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo {
  final String text;
  final DateTime dateTime;
  final bool isDone;
  String? id;

  Todo({
    required this.text,
    required this.dateTime,
    this.isDone = false,
    this.id,
  });

  factory Todo.fromFirestoreDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      text: data['text'] as String,
      dateTime: (data['datetime'] as Timestamp).toDate(),
      isDone: data['isDone'] as bool,
    );
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      'text': text,
      'datetime': dateTime,
      'isDone': isDone,
    };
  }

  DateTime get date => DateTime(dateTime.year, dateTime.month, dateTime.day);
  String get time => DateFormat.jm().format(dateTime);
}

class TodoGroup {
  final DateTime date;
  final List<Todo> todos;

  TodoGroup({required this.date, required this.todos});

  String get heading => DateFormat.yMMMMd('en_US').format(date);

  Color get color =>
      Colors.primaries[int.parse('${date.year}${date.month}${date.day}') %
          Colors.primaries.length];

  bool get isDone => todos.every((todo) => todo.isDone);
}

List<TodoGroup> groupTodosByDate(List<Todo> todos) {
  final result = <DateTime, List<Todo>>{};
  for (final todo in todos) {
    final key = todo.date;
    if (!result.containsKey(key)) {
      result[key] = [];
    }
    result[key]!.add(todo);
  }
  final entries = result.entries.toList();
  entries.sort((a, b) => -a.key.compareTo(b.key));
  return entries.map((e) => TodoGroup(date: e.key, todos: e.value)).toList();
}
