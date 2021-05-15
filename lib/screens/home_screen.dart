import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:tv_maze/data_search.dart';
import 'package:tv_maze/models/shows_data.dart';
import 'package:tv_maze/screens/libaray_screen.dart';
import 'package:tv_maze/widgets/app_drawer.dart';

import 'package:tv_maze/widgets/shows_tile_widget.dart';


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
  * This method initialize _showData with data from web
  */

  _initShows() {
    _getDataFromWeb(_page++).then((data) {
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
    });
  }

  /*
  * This method scrap the tvMaze popular shows page
  * and extract id, title, imageUrl and convert them to
  * Map and return List of those Map
  */
  Future<List<Map<String, String>>> _getDataFromWeb(int page) async {
    List<int> noImageTitleIndex = [];
    final response =
        await http.get("https://www.tvmaze.com/shows?page=" + page.toString());
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          }),
        ],
        title: Text(
          'TvMaze',
          // style: TextStyle(
          //     color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
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
