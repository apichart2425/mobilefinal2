import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../model/stateuser.dart';
import '../model/userDB_SQL.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localPathFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await _localPathFile;
    file.writeAsString('${data}');
  }

  final _formKey = GlobalKey<FormState>();

  UserProvider user = UserProvider();
  final userid = TextEditingController(text: StateUserLogin.userid);
  final name = TextEditingController(text: StateUserLogin.name);
  final age = TextEditingController(text: StateUserLogin.age);
  final password = TextEditingController();
  final quote = TextEditingController(text: StateUserLogin.quote);

  bool user_state = false;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "User Id",
                      hintText: "User Id must be between 6 to 12",
                      icon:
                          Icon(Icons.account_box, size: 40, color: Colors.grey),
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (user_state) {
                        print("hey");
                        return "This Username is taken";
                      } else if (value.length < 6 || value.length > 12) {
                        return "Please fill UserId Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "ex. 'John Snow'",
                      icon: Icon(Icons.account_circle,
                          size: 40, color: Colors.grey),
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (countSpace(value) != 1) {
                        return "Please fill Name Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Please fill Age Between 10 to 80",
                      icon:
                          Icon(Icons.event_note, size: 40, color: Colors.grey),
                    ),
                    controller: age,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill Age";
                      } else if (!isNumeric(value) ||
                          int.parse(value) < 10 ||
                          int.parse(value) > 80) {
                        return "Please fill Age correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password must be longer than 6",
                      icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                    ),
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 6) {
                        return "Please fill Password Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quote",
                      hintText: "Explain you self!",
                      icon: Icon(Icons.settings_system_daydream,
                          size: 40, color: Colors.grey),
                    ),
                    controller: quote,
                    keyboardType: TextInputType.text,
                    maxLines: 5),
                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                RaisedButton(
                    child: Text("SAVE"),
                    onPressed: () async {
                      await user.open("user.db");
                      Future<List<User>> allUser = user.getAllUser();
                      User user_Data = User();
                      user_Data.id = StateUserLogin.id;
                      user_Data.userid = userid.text;
                      user_Data.name = name.text;
                      user_Data.age = age.text;
                      user_Data.password = password.text;
                      user_Data.quote = quote.text;
                      writeContent(quote.text);
                      //function to check if user in
                      Future isUserTaken(User user) async {
                        var alluser = await allUser;
                        for (var i = 0; i < alluser.length; i++) {
                          if (user.userid == alluser[i].userid &&
                              StateUserLogin.id != alluser[i].id) {
                            print('Taken');
                            this.user_state = true;
                            break;
                          }
                        }
                      }

                      //validate form
                      if (_formKey.currentState.validate()) {
                        await isUserTaken(user_Data);
                        print(this.user_state);
                        //if user not exist
                        if (!this.user_state) {
                          await user.updateUser(user_Data);
                          StateUserLogin.userid = user_Data.userid;
                          StateUserLogin.name = user_Data.name;
                          StateUserLogin.age = user_Data.age;
                          StateUserLogin.password = user_Data.password;
                          StateUserLogin.quote = user_Data.quote;
                          Navigator.pop(context);
                          print('insert complete');
                        }
                      }

                      this.user_state = false;
                      Future showAllUser() async {
                        var alluser = await allUser;
                        for (var i = 0; i < alluser.length; i++) {
                          print(alluser[i]);
                        }
                      }

                      showAllUser();
                      print(StateUserLogin.whoCurrent());
                    }),
              ]),
        ));
  }
}
