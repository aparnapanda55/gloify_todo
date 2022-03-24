import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Todo {
  final String text;
  final DateTime dateTime;
  final bool isDone;

  Todo({
    required this.text,
    required this.dateTime,
    this.isDone = false,
  });

  factory Todo.fromFirestoreDoc(Map<String, dynamic> doc) {
    return Todo(
      text: doc['text'] as String,
      dateTime: (doc['datetime'] as Timestamp).toDate(),
      isDone: doc['isDone'] as bool,
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
