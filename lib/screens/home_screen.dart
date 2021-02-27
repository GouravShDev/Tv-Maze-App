import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tv_maze/models/shows_data.dart';

import 'package:tv_maze/widgets/shows_tile_widget.dart';

import 'about_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  ShowsData _showsData;
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _initShows();
  }

  /*
  * This method scrap the tvMaze popular shows page
  * and extract ids, titles, imageUrl list and return Map
  * containing these List
  */
  Future<Map<String, List<String>>> _getDataFromWeb(int page) async {
    List<int> noImageTitleIndex = [];
    final response =
        await http.get("https://www.tvmaze.com/shows?page=" + page.toString());
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName("column column-block");
    List<String> ids =
        elements.map((element) => element.attributes['data-key']).toList();
    List<String> titles = elements.asMap()
        .map((i,element) {
            var title = element.getElementsByTagName('img')[0].attributes['alt'];
            // Checking if show doesn't have image
            // if it doesn't, record it index
            if(title == 'No image (yet).'){
              noImageTitleIndex.add(i);
            }
            return MapEntry(i, title);
        }).values
        .toList();
    List<String> ratings = elements.map((element) {
      // Replacing '-' rating to N/A
      var rating = element
          .getElementsByClassName('dropdown-action')[0]
          .getElementsByTagName('span')[0]
          .innerHtml;
      if (rating == '-') {
        rating = 'N/A';
      }
      return rating;
    }).toList();
    List<String> imageUrls = elements.map((element) {
      // Changing relative url to absolute
      var relUrl = element.getElementsByTagName('img')[0].attributes['src'];
      return "https:" + relUrl;
    }).toList();
    // Removing shows which doesn't contain image
    // Loop is traversing in reverse to prevent deleting initial elements
    for(int i = noImageTitleIndex.length-1; i >= 0; i--){
      ids.removeAt(noImageTitleIndex[i]);
      titles.removeAt(noImageTitleIndex[i]);
      ratings.removeAt(noImageTitleIndex[i]);
      imageUrls.removeAt(noImageTitleIndex[i]);
    }
    return {
      'ids': ids,
      'titles': titles,
      'imageUrls': imageUrls,
      'ratings': ratings
    };
  }

  /*
  * This method initialize _showData with data from web
  */
  _initShows() {
    Map<String, List<String>> data;
    _getDataFromWeb(_page++).then((value) {
      data = value;
      var ids = data['ids'];
      var imageUrls = data['imageUrls'];
      var ratings = data['ratings'];
      var titles = data['titles'];
      ShowsData showsData = ShowsData(
          ids: ids, imageUrls: imageUrls, ratings: ratings, titles: titles);
      setState(() {
        _showsData = showsData;
      });
    });
  }

  /*
  * This Method load more shows when user reaches at last show in the List
  */
  _loadMoreShows(int page){
    _isLoading = true;
    Map<String, List<String>> data;
    _getDataFromWeb(page).then((value) {
      data = value;
      var ids = data['ids'];
      var imageUrls = data['imageUrls'];
      var ratings = data['ratings'];
      var titles = data['titles'];
      setState(() {
        _showsData.addData(titles: titles,ratings: ratings,imageUrls: imageUrls,ids: ids);
      });
      _isLoading = false;
    });
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
          SizedBox(
            height: 18,
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
      body: (_showsData == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreShows(_page++);
                }
                return false;
              },
              child: GridView.count(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 5 / 7,
                padding: EdgeInsets.all(4),
                crossAxisCount: 3,
                children: List.generate(_showsData.getLength(), (index) {
                  return ShowsTile(
                    showTitle: _showsData.titles[index],
                    imageUrl: _showsData.imageUrls[index],
                    id: _showsData.ids[index],
                    rating: _showsData.ratings[index],
                    mediaQueryData: MediaQuery.of(context),
                  );
                }),
              ),
            ),
    );
  }
}
