import 'dart:developer';

import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/create_todo_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

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
      home: MyHomePage(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              GoogleProviderConfiguration(
                clientId:
                    '470642559463-b76b7f5uo0l53g8fkelohopsbmk0vrg6.apps.googleusercontent.com',
              )
            ],
          );
        }
        return MyHomePage();
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final _collection = FirebaseFirestore.instance.collection('todos');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'.toUpperCase()),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: const [
                    Text('Sign out'),
                    Spacer(),
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ],
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = await showDialog<Todo?>(
            context: context,
            builder: (context) => const CreateTodoDialog(),
          );
          if (todo != null) {
            _collection.add(todo.toFirestoreDoc());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _collection.orderBy('datetime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final todos = snapshot.data!.docs
              .map((doc) => Todo.fromFirestoreDoc(doc))
              .toList();

          final grouped = groupTodosByDate(todos);

          return ListView(
            children: grouped.map((entry) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(entry.key),
                    Column(
                      children:
                          entry.value.map((todo) => Text('$todo')).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}


// ListTile(
//                   title: Text(todo.text),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(todo.time),
//                       Checkbox(
//                         value: todo.isDone,
//                         onChanged: (value) {
//                           _collection.doc(todo.id).update({'isDone': value});
//                         },
//                       ),
//                     ],
//                   ),
//                 )