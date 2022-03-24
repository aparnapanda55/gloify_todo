import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Todo {
  final String text;
  final DateTime dateTime;
  final bool isDone;
  final String? id;

  Todo({
    required this.text,
    required this.dateTime,
    this.isDone = false,
    this.id = null,
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

  String get date => dateTime.toString().split(' ')[0];
  String get time => DateFormat.jm().format(dateTime);
}

List<MapEntry<String, List<Todo>>> groupTodosByDate(List<Todo> todos) {
  final result = <String, List<Todo>>{};
  for (final todo in todos) {
    if (!result.containsKey(todo.date)) {
      result[todo.date] = [];
    }
    result[todo.date]!.add(todo);
  }
  final entries = result.entries.toList();
  entries.sort((a, b) => -a.key.compareTo(b.key));
  return entries;
}
