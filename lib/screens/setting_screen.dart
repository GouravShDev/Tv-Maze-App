import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper_methods.dart';
import '../theme_builder.dart';

class Settings extends StatelessWidget {



  /*
  * This method change according to user selection
  */

  _changeTheme({String themeName, BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    if (themeName == 'light') {
      ThemeBuilder.of(context).changeTheme(CustomTheme.light);
      // Storing Selection in sharePref
      await prefs.setInt(baseTheme, 0);
    } else if (themeName == 'dark') {
      ThemeBuilder.of(context).changeTheme(CustomTheme.dark);
      // Storing Selection in sharePref
      await prefs.setInt(baseTheme, 1);
    } else {
      ThemeBuilder.of(context).changeTheme(CustomTheme.black);
      // Storing Selection in sharePref
      await prefs.setInt(baseTheme, 2);
    }
  }

  /*
  * Logic for getting different Box border
  * Color according to current theme
  */

  Color getBoxColor(String theme,dynamic themeBuilderState){
    if(themeBuilderState.getCurrentTheme().toString().contains(theme)){
      return Colors.red;
    }else if(themeBuilderState.getCurrentTheme().toString().contains('light')){
      return Colors.black;
    }else{
      return Colors.white;
    }
  }

  IconData getIcon(String theme){
    if (theme == 'light') {
      return Icons.wb_sunny;
    } else if (theme == 'dark') {
      return Icons.nights_stay_outlined;
    } else {
      return Icons.nightlight_round;
    }
  }
  _buildCustomBox(
      {String themeName, BuildContext ctx, dynamic themeBuilderState}) {
    return InkWell(
      onTap: () {
        _changeTheme(context: ctx, themeName: themeName);
      },
      child: Container(
            decoration: BoxDecoration(
              color: themeBuilderState.uiColor,
              border: Border.all(color: getBoxColor(themeName, themeBuilderState), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2.0, // soften the shadow
                  // spreadRadius: 5.0, //extend the shadow
                  offset: Offset(
                    4.0, // Move to right 10  horizontally
                    4.0, // Move to bottom 10 Vertically
                  ),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  themeName,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 8,),
                Icon(getIcon(themeName)),
              ],
            ),
          ),
    );
  }

  _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeBuilder.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose Your Style",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCustomBox(
                  themeName: 'light', ctx: context, themeBuilderState: _theme),
              _buildCustomBox(
                  themeName: 'dark', ctx: context, themeBuilderState: _theme),
              _buildCustomBox(
                  themeName: 'black', ctx: context, themeBuilderState: _theme),
            ],
          ),
          _buildDivider(),
        ],
      ),
    );
  }
}
