import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tv_maze/screens/home_screen.dart';
import 'package:tv_maze/theme_builder.dart';

void main() {
  runApp(DevicePreview(
    builder: (context) => MyApp(),
    enabled: !kReleaseMode,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (context, _brightness, _uiColor, _textColor) {
      return MaterialApp(
        title: 'TV Maze',
        builder: DevicePreview.appBuilder,
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
    });
  }
}
