
import 'package:flutter/material.dart';


void main() => runApp(
  MaterialApp(
    home: TodoApp(),
    // routes: buildAppRoutes(),
    theme: ThemeData(primaryColor: Color(0xFF1F3C88),
  ))
);

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('xd'),
    );
  }
}
