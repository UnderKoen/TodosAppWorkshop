import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peer2peer_workshop/todo_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodosPage(),
    );
  }
}

class TodosPage extends StatefulWidget {
  TodosPage({Key? key}) : super(key: key);

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  List<TodoItem> items = [];

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    this.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taken"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: items
                .map((e) => TodoElement(
                      value: e,
                      changed: (state, self) => setState(() {
                        self.state = state;
                        save();
                      }),
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDialog(
              context: context,
              builder: (context) => AddTodoItemDialog(
                itemAdded: (name) => setState(() {
                  items.add(new TodoItem(name));
                  save();
                }),
              ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void save() {
    prefs?.setStringList("items",
        items.map((item) => item.toJson()).map((j) => jsonEncode(j)).toList());
  }

  void load() async {
    prefs = await SharedPreferences.getInstance();
    this.items = (prefs?.getStringList("items") ?? [])
        .map((s) => jsonDecode(s))
        .map((j) => TodoItem.fromJson(j))
        .toList();
  }
}

class AddTodoItemDialog extends StatefulWidget {
  final void Function(String name)? itemAdded;

  const AddTodoItemDialog({
    Key? key,
    this.itemAdded,
  }) : super(key: key);

  @override
  _AddTodoItemDialogState createState() => _AddTodoItemDialogState();
}

class _AddTodoItemDialogState extends State<AddTodoItemDialog> {
  final GlobalKey<FormFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Voeg taak toe"),
      content: TextFormField(
        key: key,
        decoration: InputDecoration(
          labelText: "Taak",
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
      ),
      actions: [
        TextButton(
          child: const Text('Annuleren'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Voeg toe'),
          onPressed: () {
            widget.itemAdded?.call(key.currentState?.value ?? "");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class TodoItem {
  String name;
  bool state;

  TodoItem(this.name, {this.state = false});

  factory TodoItem.fromJson(Map<String, dynamic> parsedJson) {
    return new TodoItem(
      parsedJson['name'] ?? "",
      state: parsedJson['state'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "state": this.state,
    };
  }
}
