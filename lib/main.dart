import 'package:flutter/material.dart';
import 'package:gloify_todo/widgets/todo_group_card.dart';
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
      home: const AuthGate(),
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
                    '315374225316-u5ppm0f2vnchdbs10h6tbfh4hbq2kqsu.apps.googleusercontent.com',
              )
            ],
          );
        }
        return const MyHomePage();
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos');
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

          if (todos.isEmpty) {
            return const Center(
              child: Text(
                ' You don\'t have any todos yet',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.grey),
              ),
            );
          }

          final groups = groupTodosByDate(todos);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: TodoGroupCard(groups: groups, collection: _collection),
            ),
          );
        },
      ),
    );
  }
}
