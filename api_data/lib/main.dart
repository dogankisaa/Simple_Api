import 'package:api_data/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as connect;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder<Post>(
        future: getGetApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int? userId = snapshot.data?.userId;
            int? id = snapshot.data?.id;
            String? body = snapshot.data?.body;
            String? title = snapshot.data?.title;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("User Id = $userId"),
                Text("Id = $id"),
                Text("Body  = $body"),
                Text("title = $title"),
              ],
            );
          } else if(snapshot.hasError){
            return Text("Oluşan Hata ${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    ));
  }
}
class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"],
    );
  }
}


Future<Post> getGetApi() async {
  final answer = await connect.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));

  if(answer.statusCode == 200){
    return Post.fromJson(json.decode(answer.body));
  } else {
    throw Exception("Veri Alınamadı. Hata kodu: ${answer.statusCode}");
  }
}

