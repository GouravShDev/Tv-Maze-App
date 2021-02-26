
import 'package:flutter/material.dart';
import 'package:tv_maze/helper_methods.dart';
import 'package:tv_maze/screens/home_screen.dart';
import 'package:tv_maze/theme_builder.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultTheme: CustomTheme.light,
      builder: (context,_brightness,_uiColor,_textColor)
    {
      return MaterialApp(
        title: 'TV Maze',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: _brightness,
          canvasColor: _uiColor,
          appBarTheme: AppBarTheme(
            color: _uiColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: _textColor, // Using text for icon colors
            ),
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: _textColor,
                    // fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
        ),
        home: HomeScreen(),
      );
    }
    );
  }
}
