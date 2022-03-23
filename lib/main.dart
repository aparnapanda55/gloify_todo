import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/create_todo_dialog.dart';

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
