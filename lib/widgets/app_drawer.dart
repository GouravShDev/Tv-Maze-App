import 'package:flutter/material.dart';
import 'package:tv_maze/screens/about_screen.dart';
import 'package:tv_maze/screens/libaray_screen.dart';
import 'package:tv_maze/screens/setting_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(colors: <Color>[
            //       Colors.red.shade400,
            //       Colors.yellowAccent.shade400,
            //     ],)
            // ),
              child: FittedBox(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).canvasColor,
                  radius: 10,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                fit: BoxFit.fitHeight,
              )),
          SizedBox(
            height: 18,
          ),
          ListTile(
            leading: Icon(Icons.live_tv),
            title: Text(
              'Explore',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.collections_bookmark_rounded),
            title: Text(
              'Library',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, LibraryScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, Settings.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, AboutScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.mail_rounded),
            title: Text(
              'Contact',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}