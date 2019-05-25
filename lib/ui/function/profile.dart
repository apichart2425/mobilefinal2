import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/stateuser.dart';
import '../../model/userDB_SQL.dart';
import '../../ui/function/home.dart';

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

  int spaceInName(String name) {
    int space = 0;
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ') {
        space += 1;
      }
    }
    return space;
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
                      icon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (user_state) {
                        return "Please UserId length 6 - 12";
                      } else if (value.length < 6 || value.length > 12) {
                        return "This Username is same daabase";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Example. 'Apichart Pack'",
                      icon: Icon(
                        Icons.account_circle,
                        size: 30,
                      ),
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (spaceInName(value) != 1) {
                        return "Please have only one space in your name. \nExample. 'Apichart Pack'";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Please fill Age Between 10 to 80",
                      icon: Icon(
                        Icons.event_note,
                        size: 30,
                      ),
                    ),
                    controller: age,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill in the information Age";
                        ;
                      } else if (!isNumeric(value) ||
                          int.parse(value) < 10 ||
                          int.parse(value) > 80) {
                        return "Please check Age Between 10 to 80 ? \nExample. '15'";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password must be longer than 6",
                      icon: Icon(
                        Icons.lock,
                        size: 30,
                      ),
                    ),
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 6) {
                        return "Please check Password loger 6";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quote",
                      hintText: "Quote",
                      icon: Icon(
                        Icons.textsms,
                        size: 30,
                      ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePagescreen(),
                            ),
                          );
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
                    }),
              ]),
        ));
  }
}
