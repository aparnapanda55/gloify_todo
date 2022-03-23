import 'package:flutter/material.dart';
import 'capture_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class NewTodo {
  final String text;
  final DateTime date;

  NewTodo({required this.text, required this.date});

  @override
  String toString() {
    return 'Todo("$text", "$date")';
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'.toUpperCase()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              size: 35,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = await showDialog<NewTodo?>(
            context: context,
            builder: (context) => const CreateTodoDialog(),
          );
          print(todo);
        },
        child: const Icon(Icons.add),
      ),
      body: const TaskLists(),
    );
  }
}

class CreateTodoDialog extends StatefulWidget {
  const CreateTodoDialog({Key? key}) : super(key: key);

  @override
  State<CreateTodoDialog> createState() => _CreateTodoDialogState();
}

class _CreateTodoDialogState extends State<CreateTodoDialog> {
  late final TextEditingController controller;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    controller = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter task'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
                  setState(() {
                    if (date != null) {
                      selectedDate = date;
                    }
                  });
                },
                child: Text('$selectedDate'.split(' ')[0]),
              ),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  setState(() {
                    if (time != null) {
                      selectedTime = time;
                    }
                  });
                },
                child: Text('$selectedTime'),
              ),
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isEmpty) return;

            final date = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            Navigator.of(context).pop(NewTodo(text: text, date: date));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class TaskLists extends StatelessWidget {
  const TaskLists({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Feb 10 2016'),
          OneDaysTasks(),
          Text('Jan 18 2016'),
          OneDaysTasks(),
        ],
      ),
    );
  }
}

class OneDaysTasks extends StatelessWidget {
  const OneDaysTasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Card(
        elevation: 5,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => const ListTile(
            title: Text('Interview at Google'),
            trailing: Text('12:90'),
          ),
        ),
      ),
    );
  }
}
