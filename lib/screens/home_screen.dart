import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tv_maze/data_search.dart';
import 'package:tv_maze/models/shows_data.dart';
import 'package:tv_maze/widgets/app_drawer.dart';

import 'package:tv_maze/widgets/shows_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _offline = false;
  ShowsData _showsData;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    print("page is " + _page.toString());
    _initShows();
  }

  /*
  * This method initialize _showData with data from web
  */

  _initShows() {
    _getDataFromWeb(_page).then((data) {
      if(data!=null){
        List<String> ids = [];
        List<String> imageUrls = [];
        List<String> ratings = [];
        List<String> titles = [];
        data.forEach((element) {
          ids.add(element['id']);
          titles.add(element['title']);
          ratings.add(element['rating']);
          imageUrls.add(element['imageUrl']);
        });
        ShowsData showsData = ShowsData(
            ids: ids, imageUrls: imageUrls, ratings: ratings, titles: titles);
        setState(() {
          _showsData = showsData;
        });
        _page++;
      }

    });
  }

  /*
  * This method scrap the tvMaze popular shows page
  * and extract id, title, imageUrl and convert them to
  * Map and return List of those Map
  */
  Future<List<Map<String, String>>> _getDataFromWeb(int page) async {
    List<int> noImageTitleIndex = [];
    http.Response response;
    try {
      response = await http
          .get("https://www.tvmaze.com/shows?page=" + page.toString());
    } on SocketException catch (_) {
      print("No internet");
      setState(() {
        _offline = true;
      });
      return null;
    }
    print("response " + response.statusCode.toString());
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName("column column-block");
    List<Map<String, String>> listOfShowData = elements
        .asMap()
        .map((i, element) {
          var id = element.attributes['data-key'];
          var title = element.getElementsByTagName('img')[0].attributes['alt'];
          // Checking if show doesn't have image
          // if it doesn't, record it index
          if (title == 'No image (yet).') {
            noImageTitleIndex.add(i);
          }
          var rating = element
              .getElementsByClassName('dropdown-action')[0]
              .getElementsByTagName('span')[0]
              .innerHtml;
          // Changing relative url to absolute
          var imageUrl =
              element.getElementsByTagName('img')[0].attributes['src'];
          imageUrl = "https:" + imageUrl;

          return MapEntry(i, {
            'id': id,
            'title': title,
            'imageUrl': imageUrl,
            'rating': rating
          });
        })
        .values
        .toList();
    for (int i = noImageTitleIndex.length - 1; i >= 0; i--) {
      listOfShowData.removeAt(noImageTitleIndex[i]);
    }
    return listOfShowData;
  }

  /*
  * This Method load more shows when user reaches at last show in the List
  */
  _loadMoreShows(int page) {
    _isLoading = true;
    _getDataFromWeb(page).then((value) {
      List<String> ids = [];
      List<String> titles = [];
      List<String> ratings = [];
      List<String> imageUrls = [];
      value.forEach((element) {
        ids.add(element['id']);
        titles.add(element['title']);
        ratings.add(element['rating']);
        imageUrls.add(element['imageUrl']);
      });
      setState(() {
        _showsData.addData(
            titles: titles, ratings: ratings, imageUrls: imageUrls, ids: ids);
      });
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              }),
        ],
        // title: Text(
        //   'TvMaze',
        //   style: TextStyle(
        //       color: Theme.of(context).primaryColorDark, fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        title: SizedBox(
          width: width * 0.3,
          child: Image.asset('assets/images/appTitle.png',fit: BoxFit.fitWidth,),
        )
      ),
      drawer: AppDrawer(),
      body: (_showsData == null)
          ? (_offline == false)
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor, // Green
                    ),
                  ),
                )
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Something went wrong !!'),
                      Text('Check your Internet Connection'),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          setState(() {
                            _offline = false;
                          });
                            _initShows();
                        },
                        child: Text(
                          'Try Again', style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant,),
                        ),
                      ),
                    ],
                  ),
                ])
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
                mainAxisSpacing: 6,
                childAspectRatio: 6 / 9,
                padding: EdgeInsets.all(4),
                crossAxisCount: 3,
                children: List.generate(_showsData.getLength(), (index) {
                  return ShowsTile(
                    showTitle: _showsData.titles[index],
                    imageUrl: _showsData.imageUrls[index],
                    id: _showsData.ids[index],
                    rating: _showsData.ratings[index],
                    status: 0,
                    mediaQueryData: MediaQuery.of(context),
                  );
                }),
              ),
            ),
    );
  }
}
