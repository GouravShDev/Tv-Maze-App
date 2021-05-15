import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/utils/database_helper.dart';
import 'package:tv_maze/widgets/shows_tile_widget.dart';

import '../helper_methods.dart';
import 'show_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = '/library';
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Shows> _showList;
  int count = 0;

  _getDatabaseList() async {
    var list = await databaseHelper.getShowList();
    setState(() {
      _showList = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getDatabaseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (_showList == null) {
      _showList = List<Shows>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: _showList.length <= 0
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            )
          : GridView.count(
        crossAxisSpacing: 4,
        mainAxisSpacing: 6,
        childAspectRatio: 6 / 9,
        padding: EdgeInsets.all(4),
        crossAxisCount: 3,
        children: List.generate(_showList.length, (index) {
          var show = _showList[index];
          return ShowsTile(
            showTitle: show.name,
            imageUrl: show.imageUrl,
            id: show.id,
            rating: show.rating,
            status: show.status,
            mediaQueryData: MediaQuery.of(context),
          );
        }),
      ),
    );
  }


}
