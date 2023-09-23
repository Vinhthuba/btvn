import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.id, required this.title, required this.userId});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title'], userId: json['userId']);
  }
  Map toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
      };
}

void main() {
  runApp(const MyAppApi());
}

class MyAppApi extends StatefulWidget {
  const MyAppApi({super.key});

  @override
  State<MyAppApi> createState() => _MyAppApiState();
}

class _MyAppApiState extends State<MyAppApi> {
  late Future<Album> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String jsonAlbum = jsonEncode(snapshot.data);
                print('${jsonAlbum}');
                print('${snapshot.data}');
                return Text(jsonAlbum);
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