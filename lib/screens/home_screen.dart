import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/services/api_services.dart';
import 'package:tv_maze/widgets/shows_tile_widget.dart';

import 'about_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<String> _ids;
  List<String> _titles;
  List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _getDataFromWeb();
    _initShows();
  }

  _initShows() async {

    /*Shows show =
    await ApiService.instance.searchShows(showsName: "Game of Thrones");
    setState(() {
      _show = show;
    });*/
  }

  /*
  This method scrap the tvMaze popular shows page
  and extract ids, titles, imageUrl list
  */
  void _getDataFromWeb() async {
    final response = await http.get("https://www.tvmaze.com/shows");
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName("column column-block");
    _ids = elements.map((element) => element.attributes['data-key']).toList();
    _titles = elements
        .map((element) =>
    element.getElementsByTagName('img')[0].attributes['alt'])
        .toList();
    setState(() {
    _imageUrls = elements
        .map((element) =>
    element.getElementsByTagName('img')[0].attributes['src'])
        .toList();
    });
    print(_imageUrls[1]);
    // print(elements[1]);
  }

  _buildDrawer() {
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
                  backgroundColor: Colors.white,
                  radius: 10,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                fit: BoxFit.fitHeight,
              )),
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AboutScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Contact us',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TvMaze',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: _buildDrawer(),
      body: (_imageUrls == null)
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme
                .of(context)
                .primaryColor, // Red
          ),
        ),
      )
          : GridView.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        children: List.generate(_titles.length, (index) {
          return InkWell(
            // splashColor: , To be added
            borderRadius: BorderRadius.circular(8),
            onTap: () {},
            child: ShowsTile(showTitle: _titles[index],
              imageUrl: _imageUrls[index],
              rating: '-',),
          );
        }),
      ),
    );
  }
}
