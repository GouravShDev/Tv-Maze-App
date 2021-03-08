import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
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
  Image _showImage;
  _initShow() async {
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

  /*
  * Make _showImage singleton by initialize it only one time
  * to prevent downloading image multiple times
  */
  Image _getImage(String imageUrl) {
    if (_showImage == null) {
      _showImage = Image.network(imageUrl);
    }
    return _showImage;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
      // appBar: AppBar(),
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
                SizedBox(
                  height: height * 0.38,
                  child: Stack(
                    children: [
                      SizedBox(
                        // margin: EdgeInsets.all(10),
                        height: height * 0.25,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: _getImage(_show.imageUrl),
                              ),
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ),
                            ),

                            Positioned(
                              top: mediaQuery.padding.top,
                              child: Container(
                                // padding: EdgeInsets.only(left: 8),
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).canvasColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(width * .1),
                                      topRight: Radius.circular(width * .1),
                                    ),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_outlined,
                                    size: height * 0.03,
                                    color:
                                        Theme.of(context).textTheme.headline6.color,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8.0),
                            //     decoration: BoxDecoration(
                            //       color: Theme.of(context).canvasColor,
                            //       border: Border.all(color: Colors.black,width: 1),
                            //       borderRadius: BorderRadius.circular(8.0)
                            //     ),
                            //       child: Text(
                            //     _show.name,
                            //     style: TextStyle(fontSize: width * 0.05,fontWeight: FontWeight.bold),
                            //   )),
                            // ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 8.0,
                        top: (height * 0.22) / 2 ,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: height * 0.25,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _getImage(_show.imageUrl),
                                Container(

                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(_show.genres.toString(),style: TextStyle(fontSize: width * 0.035),),
                                          Flexible(
                                            child: SizedBox(
                                              width: width * 0.5,
                                              child: AutoSizeText(
                                                  _show.name,
                                                  style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(fontSize: width * 0.05),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text("test"),

              ],
            ),
    );
  }
}
