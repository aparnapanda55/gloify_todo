import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/create_todo_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final _collection = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _collection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final todos =
              snapshot.data!.docs.map((doc) => Todo.fromFirestoreDoc(doc));

          return ListView(
            children: todos.map((todo) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(todo.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(todo.time),
                      Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          _collection.doc(todo.id).update({'isDone': value});
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
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
          final todo = await showDialog<Todo?>(
            context: context,
            builder: (context) => const CreateTodoDialog(),
          );
          print(todo);
        },
        child: const Icon(Icons.add),
      ),
      body: Data(),
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
