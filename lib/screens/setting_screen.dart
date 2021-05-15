import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_maze/widgets/animatedButton.dart';

import '../helper_methods.dart';
import '../theme_builder.dart';

class Settings extends StatelessWidget {
  static const routeName = '/setting';
  /*
  * This method change according to user selection
  */

  void _changeTheme({String themeName, BuildContext context}) async {
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

  // /*
  // * Logic for getting different Box border
  // * Color according to current theme
  // */
  //
  // Color getBoxColor(String theme, dynamic themeBuilderState) {
  //   if (themeBuilderState.getCurrentTheme().toString().contains(theme)) {
  //     return Colors.red;
  //   } else if (themeBuilderState
  //       .getCurrentTheme()
  //       .toString()
  //       .contains('light')) {
  //     return Colors.black;
  //   } else {
  //     return Colors.white;
  //   }
  // }

  /*
  * Logic for getting different Icon
  * according to current theme
  */
  IconData getIcon(String theme) {
    if (theme == 'light') {
      return Icons.wb_sunny;
    } else if (theme == 'dark') {
      return Icons.nights_stay_outlined;
    } else {
      return Icons.nightlight_round;
    }
  }

  /*_buildCustomBox(
      {String themeName, BuildContext ctx, dynamic themeBuilderState}) {
    return InkWell(
      onTap: () {
        _changeTheme(context: ctx, themeName: themeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeBuilderState.uiColor,
          border: Border.all(
              color: getBoxColor(themeName, themeBuilderState), width: 3),
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
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              themeName,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              width: 6,
            ),
            Icon(getIcon(themeName)),
          ],
        ),
      ),
    );
  }
*/
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

  _buildThemeIcon(double height,dynamic theme){
    if(theme.isLightTheme()){
      return Icon(Icons.wb_sunny_sharp,size: height * 0.10,);
    }else if(theme.isDarkTheme()){
      return Icon(Icons.nights_stay_outlined,size: height * 0.10,);
    }else{
      return Icon(Icons.nights_stay,size: height * 0.10,);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = ThemeBuilder.of(context);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: _height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose Your Style",
                style: TextStyle(fontSize: _width * 0.045),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildThemeIcon(_height,_theme),
          ),
          ZAnimatedButton(values: ['light','dark','black'],onToggleCallback: (theme){_changeTheme(themeName: theme,context: context);},),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _buildCustomBox(
          //         themeName: 'light', ctx: context, themeBuilderState: _theme),
          //     _buildCustomBox(
          //         themeName: 'dark', ctx: context, themeBuilderState: _theme),
          //     _buildCustomBox(
          //         themeName: 'black', ctx: context, themeBuilderState: _theme),
          //   ],
          // ),
          SizedBox(
            height: _height * 0.025,
          ),
          _buildDivider(),
        ],
      ),
    );
  }
}
