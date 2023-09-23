import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlbumTodo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const AlbumTodo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory AlbumTodo.fromJson(Map<String, dynamic> json) {
    return AlbumTodo(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        completed: json['completed']);
  }
  Map toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'completed': completed,
      };
}

Future<AlbumTodo> fetchAlbumTodo() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
  if (response.statusCode == 200) {
    return AlbumTodo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class MyAppTodo extends StatefulWidget {
  const MyAppTodo({super.key});
  @override
  State<MyAppTodo> createState() => _MyAppTodoState();
}

class _MyAppTodoState extends State<MyAppTodo> {
  late Future<AlbumTodo> futureAlbumToDo;
  @override
  void initState() {
    super.initState();
    futureAlbumToDo = fetchAlbumTodo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<AlbumTodo>(
            future: futureAlbumToDo,
            builder: (context, snapshot) {
              String data = jsonEncode(snapshot.data);
              if (snapshot.hasData) {
                return Text('${data}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyAppTodo());
}