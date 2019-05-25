import 'package:flutter/material.dart';
import '../../model/userDB_SQL.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  UserProvider user = UserProvider();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();

  bool user_state = false;

//https://stackoverflow.com/questions/24085385/checking-if-string-is-numeric-in-dart
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
        space ++;
      }
    }
    return space;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        // automaticallyImplyLeading: false,
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
                  icon: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (value.length < 6 || value.length > 12) {
                    return "Please UserId length 6 - 12";
                  } else if (this.user_state) {
                    return "This Username is same daabase";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Example. 'Apichart Pack'",
                  icon:
                      Icon(Icons.account_circle, size: 40, color: Colors.grey),
                ),
                controller: name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  if (spaceInName(value) != 1) {
                    return "Please have only one space in your name. \nExample. 'Apichart Pack'";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Age Between 10 to 80",
                  icon: Icon(Icons.event, size: 40, color: Colors.grey),
                ),
                controller: age,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill in the information Age";
                  } else if (!isNumeric(value) ||
                      int.parse(value) < 10 ||
                      int.parse(value) > 80) {
                    return "Please check Age Between 10 to 80 ? \nExample. '15'";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password must longer than 6",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty || value.length <= 6) {
                    return "Please check Password loger 6";
                  }
                }),
            Padding(padding: EdgeInsets.all(15)),
            RaisedButton(
                child: Text("REGISTER NEW ACCOUNT"),
                onPressed: () async {
                  await user.open("user.db");
                  Future<List<User>> allUser = user.getAllUser();
                  User user_Data = User();
                  user_Data.userid = userid.text;
                  user_Data.name = name.text;
                  user_Data.age = age.text;
                  user_Data.password = password.text;

                  //function to check if user in
                  Future isNewUserIn(User user) async {
                    var userList = await allUser;
                    for (var i = 0; i < userList.length; i++) {
                      if (user.userid == userList[i].userid) {
                        this.user_state = true;
                        break;
                      }
                    }
                  }

                  //call function
                  await isNewUserIn(user_Data);
                  print(this.user_state);

                  //validate form
                  if (_formKey.currentState.validate()) {
                    //if user not exist
                    if (await !this.user_state) {
                      userid.text = "";
                      name.text = "";
                      age.text = "";
                      password.text = "";
                      repassword.text = "";
                      await user.insertUser(user_Data);
                      Navigator.pop(context);
                    }
                  }

                  this.user_state = false;

                  Future showAllUser() async {
                    var userList = await allUser;
                    for (var i = 0; i < userList.length; i++) {
                      print(userList[i]);
                    }
                  }

                  showAllUser();
                }),
          ],
        ),
      ),
    );
  }
}
