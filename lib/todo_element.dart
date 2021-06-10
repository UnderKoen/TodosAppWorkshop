import 'package:flutter/material.dart';
import 'package:peer2peer_workshop/main.dart';

class TodoElement2 extends StatelessWidget {
  final TodoItem value;
  final void Function(bool state, TodoItem self)? changed;

  const TodoElement2({
    Key? key,
    required this.value,
    this.changed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        color: value.state ? Colors.greenAccent[100] : Colors.white,
        duration: Duration(milliseconds: 200),
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            onTap: () {},
            leading: Checkbox(
              value: value.state,
              onChanged: (bool? value) =>
                  changed?.call(value ?? false, this.value),
              shape: CircleBorder(),
              activeColor: Colors.green,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            horizontalTitleGap: 0,
            title: Text(value.name),
          ),
        ),
      ),
    );
  }
}

class TodoElement extends StatelessWidget {
  final TodoItem value;
  final void Function(bool state, TodoItem self)? changed;

  const TodoElement({
    Key? key,
    required this.value,
    this.changed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: value.state ? Colors.greenAccent[100] : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(value: value.state, onChanged: (v) {
              changed?.call(v ?? false, value);
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value.name),
          ),
        ],
      ),
    );
  }
}
