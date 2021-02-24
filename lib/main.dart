import 'package:flutter/material.dart';
import 'package:tv_maze/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Maze',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // brightness: Brightness.dark,
        // iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black,),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: 24)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
