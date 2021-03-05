import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/services/api_services.dart';

class ShowDetails extends StatefulWidget {
  final String id;
  final String title;
  ShowDetails({
    @required this.id,
    @required this.title,
  });

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  Shows _show;
  _initShow() async{
    await ApiService.instance.fetchShow(id: widget.id).then((show) {
      setState(() {
        _show = show;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _initShow();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
      // Added Center widget as placeholder for the time being
      body: _show == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  // margin: EdgeInsets.all(10),
                  height: 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _show.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.grey.withOpacity(0.1),
                            alignment: Alignment.center,
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: mediaQuery.padding.top * 0.8,
                                ),
                                child: Image.network(
                                  _show.imageUrl,
                                  height: 250,
                                )),
                          ),
                        ),
                      ),
                      Positioned(
                          top: mediaQuery.padding.top * 0.8,
                          left: 0,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Theme.of(context).canvasColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(width * .1),
                                      topRight: Radius.circular(width * .1),),),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                size: height * 0.035,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                      Positioned(bottom: 10, child: Text(_show.name)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Show Info'),
                        Text('genres : ${_show.genres}'),
                        Text('language : ${_show.language}'),
                        Text('Premiered On : ${_show.premieredOn}'),
                      ],
                    )
                  ],
                ),
                Text(_show.summary),
              ],
            ),
    );
  }
}
