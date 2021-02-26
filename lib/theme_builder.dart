import 'package:flutter/material.dart';
import 'package:tv_maze/helper_methods.dart';

class ThemeBuilder extends StatefulWidget {

  final Widget Function(BuildContext context, Brightness brightness, Color uiColor, Color textColor) builder;
  final CustomTheme defaultTheme;


  ThemeBuilder({this.builder,this.defaultTheme});
  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context){
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {

  CustomTheme _currentTheme;
  Brightness brightness;
  Color uiColor;
  Color textColor;

  @override
  void initState(){
    super.initState();
    // Initiating theme to light
    _currentTheme = widget.defaultTheme;
    setThemeColors(_currentTheme);
  }

/*
* Setting theme Color variable for each theme like textColor
*/

void setThemeColors(CustomTheme theme){
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

  void changeTheme(CustomTheme selectedTheme){
    setState(() {
      setThemeColors(selectedTheme);
    });
  }

  CustomTheme getCurrentTheme(){
    return _currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, brightness,uiColor,textColor);
  }
}
