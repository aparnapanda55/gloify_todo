class NewTodo {
  final String text;
  final DateTime date;

  NewTodo({required this.text, required this.date});

  @override
  String toString() {
    return 'Todo("$text", "$date")';
  }
}
