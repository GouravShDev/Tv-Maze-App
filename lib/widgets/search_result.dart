import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/services/api_services.dart';

import '../screens/show_details_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchedShow;

  SearchResultScreen(this.searchedShow);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<Shows> _searchResultList = [];
  bool searched = false;

  _initSearchResult() async {
    List<Shows> list = await ApiService.instance
        .searchShows(showsName: widget.searchedShow);
    setState(() {
      _searchResultList = list;
      searched = true;
    });
  }

  @override
  void initState() {
    _initSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    // final height = mediaQuery.size.height;
    return (_searchResultList.isEmpty)
        ? (searched)
            ? Center(
                child: Text("Nothing Found, huh try something else"),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor, // Red
                  ),
                ),
              )
        : ListView.builder(
            itemCount: _searchResultList.length,
            itemBuilder: (context, index) {
              var show = _searchResultList[index];
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowDetails(
                        id: show.id,
                        title: show.name,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(0.1) : Colors.white,
                  margin: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: Image.network(
                              show.imageUrl,
                              // height: 600,
                              width: width * 0.22,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: width * 0.5,
                                  child: AutoSizeText(
                                    show.name,
                                    style: Theme.of(context)
                                        .appBarTheme
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontSize: width * 0.05,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 1, left: 10),
                                child: Text(show.genres.join(","),style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.7),fontSize: width * 0.025),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
