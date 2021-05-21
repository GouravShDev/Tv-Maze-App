import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_maze/providers/shows_provider.dart';
import 'package:tv_maze/screens/about_screen.dart';
import 'package:tv_maze/screens/home_screen.dart';
import 'package:tv_maze/screens/libaray_screen.dart';
import 'package:tv_maze/screens/setting_screen.dart';
import 'package:tv_maze/theme_builder.dart';

void main() {
  runApp(DevicePreview(
    builder: (context) => ChangeNotifierProvider(
      create: (context) => ShowsList(),
      child: MyApp(),
    ),
    enabled: !kReleaseMode,
  ));
}

class MyApp extends StatelessWidget {
  final materialColor = createMaterialColor(Color.fromRGBO(0,223,213,1));
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (context, _brightness, _uiColor, _textColor) {
      return MaterialApp(
        title: 'TV Maze',
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          primarySwatch: materialColor,
          brightness: _brightness,
          canvasColor: _uiColor,
          fontFamily: 'Lato',
          appBarTheme: AppBarTheme(
            color: _uiColor,
            elevation: 0,
            iconTheme: IconThemeData(
              // color: materialColor.shade800,
              color: _textColor, // Using text for icon colors
            ),
            textTheme: TextTheme(
              headline6: TextStyle(
                  // color: materialColor.shade800,
                  color: _textColor,
                  fontFamily: 'AlegreyaSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
        routes: {
          LibraryScreen.routeName: (context) => LibraryScreen(),
          Settings.routeName: (context) => Settings(),
          AboutScreen.routeName: (context) => AboutScreen(),
        },
        home: HomeScreen(),
      );
    });
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}