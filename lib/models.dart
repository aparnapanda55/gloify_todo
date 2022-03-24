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
