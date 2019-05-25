import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Todo>> fetchJsonTodo(int userid) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/todos?userId=${userid}');

  List<Todo> todoJson = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var todo = Todo.fromJson(body[i]);
      print(todo);
      if (todo.userid == userid) {
        todoJson.add(todo);
      }
    }
    return todoJson;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Todo {
  final int userid;
  final int id;
  final String title;
  final String completed;

  Todo({this.userid, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "Completed" : ""),
    );
  }
}

class TodoPage extends StatelessWidget {
  final int id;
  final String name;
  TodoPage({Key key, @required this.id, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text("BACK",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                ),
              ),
            ),
            FutureBuilder(
              future: fetchJsonTodo(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('Wait mins to loading !!!');
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Todo> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      (values[index].id).toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      values[index].title,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      values[index].completed,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
