import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;


import 'package:tv_maze/widgets/shows_tile_widget.dart';

import 'about_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool _isLoading = false;
  List<String> _ids;
  List<String> _titles;
  List<String> _imageUrls;
  List<String> _ratings;

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
    _ratings = elements
        .map((element) {
          // Replacing '-' rating to N/A
          var rating = element.getElementsByClassName('dropdown-action')[0].getElementsByTagName('span')[0].innerHtml;
          if(rating == '-'){
            rating = 'N/A';
          }
          return rating;}).toList();
    setState(() {
      _imageUrls = elements
          .map((element) {
            // Changing relative url to absolute
            var relUrl = element.getElementsByTagName('img')[0].attributes['src'];
            return "https:" + relUrl;
          })
          .toList();
    });
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
          SizedBox(height: 18,),
          ListTile(
            leading: Icon(Icons.settings),
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
            leading: Icon(Icons.info),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TvMaze',
          // style: TextStyle(
          //     color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: _buildDrawer(),
      body: (_imageUrls == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            )
          : GridView.count(
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              children: List.generate(_titles.length, (index) {
                return ShowsTile(
                  showTitle: _titles[index],
                  imageUrl: _imageUrls[index],
                  id: _ids[index],
                  rating: _ratings[index],
                );
              }),
            ),
    );
  }
}
