import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_maze/helper_methods.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness,
      Color uiColor, Color textColor) builder;

  ThemeBuilder({this.builder});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  // Initializing Theme as Light by Default
  CustomTheme _currentTheme = CustomTheme.light;
  Brightness brightness = Brightness.light;
  Color uiColor = Colors.white;
  Color textColor = Colors.black;

  /*
  * Read the int value Stored in SharedPreferences for theme
  *
  * THEME : Value
  * Light = 0
  * Dark = 1
  * Black = 2
  *
  */
  Future<CustomTheme> _getThemeFromSharePref() async {
    final prefs = await SharedPreferences.getInstance();
    final themeNo = prefs.getInt(baseTheme);
    if (themeNo == null || themeNo == 0) {
      return CustomTheme.light;
    }
    if (themeNo == 1) {
      return CustomTheme.dark;
    } else {
      return CustomTheme.black;
    }
  }

  @override
  void initState() {
    super.initState();
    // Changing Theme according to value stored in SharePreference
    _getThemeFromSharePref().then((theme) {
      setState(() {
        if (_currentTheme != theme) {
          print("REE");
          _currentTheme = theme;
          _setThemeColors(_currentTheme);
        }
      });
    });
  }

/*
* Setting theme Color variable for each theme like textColor
*/

  void _setThemeColors(CustomTheme theme) {
    switch (theme) {
      case CustomTheme.light:
        brightness = Brightness.light;
        uiColor = Colors.white;
        textColor = Colors.black;
        _currentTheme = CustomTheme.light;
        break;
      case CustomTheme.dark:
        brightness = Brightness.dark;
        uiColor = Color.fromRGBO(33, 33, 33, 1);
        textColor = Colors.white;
        _currentTheme = CustomTheme.dark;
        break;
      case CustomTheme.black:
        brightness = Brightness.dark;
        uiColor = Colors.black;
        textColor = Colors.white;
        _currentTheme = CustomTheme.black;
        break;
    }
  }

  void changeTheme(CustomTheme selectedTheme) {
    setState(() {
      _setThemeColors(selectedTheme);
    });
  }

  CustomTheme getCurrentTheme() {
    return _currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, brightness, uiColor, textColor);
  }
}
