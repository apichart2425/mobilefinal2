import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/stateuser.dart';

SharedPreferences sharedPreferences;

class HomePagescreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePagescreen> {
  String data = '';
  String nameSP = StateUserLogin.name;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readfile() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      this.data = contents;
      if (data != StateUserLogin.quote) {
        await file.writeAsString(StateUserLogin.quote);
        String contents = await file.readAsString();
        this.data = contents;
        print('${data} ----------- testing');
      }
      return this.data;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  getname() async {
    sharedPreferences = await SharedPreferences.getInstance();
    this.nameSP = sharedPreferences.getString('name');
    print(nameSP);
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    readfile();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      readfile();
    });
    getname();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: <Widget>[
            ListTile(
              title: Text(
                'Hello ${nameSP}' ,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    'this is my quote "${StateUserLogin.quote != null ? StateUserLogin.quote == '' ? 'No data quote' : data == '' ? StateUserLogin.quote : data : 'No data quote'}"',
                    style: TextStyle(fontSize: 18.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("PROFILE SETUP"),
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("MY FRIENDS"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/friend');
                  // Navigator.of(context).pushNamed('/friend');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("SIGN OUT"),
                onPressed: () {
                  check() async {
                    sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.setString('username', '');
                    sharedPreferences.setString('password', '');
                  }

                  check();
                  StateUserLogin.userid = null;
                  StateUserLogin.name = null;
                  StateUserLogin.age = null;
                  StateUserLogin.password = null;
                  StateUserLogin.quote = null;
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
