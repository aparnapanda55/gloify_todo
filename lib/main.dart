import 'package:flutter/material.dart';

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
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const TextField(
                    decoration: InputDecoration(hintText: 'Enter task'),
                  ),
                  actions: [
                    ElevatedButton(onPressed: () {}, child: const Text('Save'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: const DayWiseTask(),
    );
  }
}

class DayWiseTask extends StatelessWidget {
  const DayWiseTask({
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
