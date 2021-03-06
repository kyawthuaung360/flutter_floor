import 'package:flutter/material.dart';
import 'package:flutterfloor/dao/person_dao.dart';
import 'package:flutterfloor/db/database.dart';

import 'entity/person.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
  .databaseBuilder('my_database.db')
  .build();
  final dao = database.personDao;
  runApp(MyApp(dao));
}

class MyApp extends StatelessWidget {
  final PersonDao personDao;
  const MyApp(this.personDao);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TasksWidget(
          title: 'Flutter Demo Home Page',
          dao: personDao),
    );
  }
}

class TasksWidget extends StatelessWidget {
  final String title;
  final PersonDao dao;

  const TasksWidget({
    Key key,
    @required this.title,
    @required this.dao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TasksListView(dao: dao),
            TasksTextField(dao: dao),
          ],
        ),
      ),
    );
  }
}

class TasksListView extends StatelessWidget {
  final PersonDao dao;

  const TasksListView({
    Key key,
    @required this.dao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Person>>(
        stream: dao.findAllPersons(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Container();

          final tasks = snapshot.data;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              return TaskListCell(
                task: tasks[index],
                dao: dao,
              );
            },
          );
        },
      ),
    );
  }
}

class TaskListCell extends StatelessWidget {
  final Person task;
  final PersonDao dao;

  const TaskListCell({
    Key key,
    @required this.task,
    @required this.dao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${task.hashCode}'),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Text(task.name),
      ),
      onDismissed: (_) async {
        await dao.deleteTask(task);

        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text('Removed task')),
        );
      },
    );
  }
}

class TasksTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final PersonDao dao;

  TasksTextField({
    Key key,
    @required this.dao,
  })
      : _textEditingController = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: 'Type task here',
              ),
              onSubmitted: (_) async {
                await _persistMessage();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlineButton(
              textColor: Colors.blueGrey,
              child: const Text('Save'),
              onPressed: () async {
                await _persistMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _persistMessage() async {
    final message = _textEditingController.text;
    if (message
        .trim()
        .isEmpty) {
      _textEditingController.clear();
    } else {
      final task = Person(null, message);
      await dao.insertPerson(task);
      _textEditingController.clear();
    }
  }
}


