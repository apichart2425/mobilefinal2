import 'package:flutter/material.dart';
import '../../model/userDB_SQL.dart';
import 'package:toast/toast.dart';
import '../../model/stateuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  UserProvider user = UserProvider();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isValid = false;
  int formState = 0;
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    checkUserPassword(String check_user, String check_password) async {
      await user.open("user.db");
      Future<List<User>> allUser = user.getAllUser();
      Future isUserValid(String userid, String password) async {
        var alluser = await allUser;
        for (var i = 0; i < alluser.length; i++) {
          if (check_user == alluser[i].userid &&
              check_password == alluser[i].password) {
            StateUserLogin.id = alluser[i].id;
            StateUserLogin.userid = alluser[i].userid;
            StateUserLogin.name = alluser[i].name;
            StateUserLogin.age = alluser[i].age;
            StateUserLogin.password = alluser[i].password;
            StateUserLogin.quote = alluser[i].quote;
            this.isValid = true;
            sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("username", alluser[i].userid);
            sharedPreferences.setString("password", alluser[i].password);
            sharedPreferences.setString("name", alluser[i].name);
            break;
          }
        }
      }

      isUserValid(check_user, check_password);
      print(this.isValid);
      if (this.isValid == true) {
        return Navigator.pushReplacementNamed(context, '/home');
      }
    }

    getCredential() async {
      sharedPreferences = await SharedPreferences.getInstance();
      String check_user = sharedPreferences.getString('username');
      String check_password = sharedPreferences.getString('password');
      if (check_user != "" && check_user != null) {
        checkUserPassword(check_user, check_password);
      }
      print(check_user);
    }

    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      checkUserPassword(String check_user, String check_password) async {
        await user.open("user.db");
        Future<List<User>> allUser = user.getAllUser();
        Future isUserValid(String userid, String password) async {
          var alluser = await allUser;
          for (var i = 0; i < alluser.length; i++) {
            print(
                '${userid} == ${alluser[i].userid} ${password} == ${alluser[i].password}');
            if (userid == alluser[i].userid &&
                password == alluser[i].password) {
              StateUserLogin.id = alluser[i].id;
              StateUserLogin.userid = alluser[i].userid;
              StateUserLogin.name = alluser[i].name;
              StateUserLogin.age = alluser[i].age;
              StateUserLogin.password = alluser[i].password;
              StateUserLogin.quote = alluser[i].quote;
              this.isValid = true;
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("username", alluser[i].userid);
              sharedPreferences.setString("password", alluser[i].password);
              sharedPreferences.setString("password", alluser[i].name);
              return Navigator.pushReplacementNamed(context, '/home');
              break;
            }
          }
        }

        isUserValid(check_user, check_password);
      }

      getCredential() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String check_user = sharedPreferences.getString('username');
        String check_password = sharedPreferences.getString('password');
        String name = sharedPreferences.getString('name');

        if (check_user != "" && check_user != null) {
          checkUserPassword(check_user, check_password);
        }
        print(check_user);
        print("name : --- ${name}");
      }

      getCredential();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Image.asset(
              "resource/lock.jpg",
              width: 150,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "User Id",
                    labelStyle: new TextStyle(
                      fontSize: 18.0,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                  ),
                  controller: userid,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isNotEmpty) {
                      this.formState += 1;
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: new TextStyle(
                      fontSize: 18.0,
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 30,
                    ),
                  ),
                  controller: password,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isNotEmpty) {
                      this.formState += 1;
                    }
                  }),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            RaisedButton(
              child: Text("LOGIN"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var alluser = await allUser;
                  for (var i = 0; i < alluser.length; i++) {
                    if (userid == alluser[i].userid &&
                        password == alluser[i].password) {
                      StateUserLogin.id = alluser[i].id;
                      StateUserLogin.userid = alluser[i].userid;
                      StateUserLogin.name = alluser[i].name;
                      StateUserLogin.age = alluser[i].age;
                      StateUserLogin.password = alluser[i].password;
                      StateUserLogin.quote = alluser[i].quote;
                      this.isValid = true;
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "username", alluser[i].userid);
                      sharedPreferences.setString(
                          "password", alluser[i].password);
                      break;
                    }
                  }
                }

                if (this.formState != 2) {
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;
                } else {
                  this.formState = 0;
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }

                Future showAllUser() async {
                  var alluser = await allUser;
                  for (var i = 0; i < alluser.length; i++) {}
                }

                showAllUser();
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register New Account", textAlign: TextAlign.right),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 180.0),
            ),
          ],
        ),
      ),
    );
  }
}
