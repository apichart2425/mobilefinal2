import 'package:flutter/material.dart';
import './ui/login/register.dart';
import './ui/login/login.dart';
import './ui/function/home.dart';
import './ui/function/profile.dart';
import './ui/function/friend.dart';

void main() => runApp(MyApp());
const PrimaryColor = const Color(0xffb71c1c);
const MaterialColor colors = const MaterialColor(
  0xffb71c1c,
  const <int, Color>{
    50: const Color(0xffb71c1c),
    100: const Color(0xffb71c1c),
    200: const Color(0xffb71c1c),
    300: const Color(0xffb71c1c),
    400: const Color(0xffb71c1c),
    500: const Color(0xffb71c1c),
    600: const Color(0xffb71c1c),
    700: const Color(0xffb71c1c),
    800: const Color(0xffb71c1c),
    900: const Color(0xffb71c1c),
  },
);
class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Prepared',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColor: PrimaryColor,
        primarySwatch:colors
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePagescreen(),
        "/profile": (context) => ProfilePage(),
        "/friend": (context) => FriendPage(),
      },
    );
  }
}