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
  String firstHalfSummary = "";
  String secondHalfSummary = "";

  bool showFullSummary = false;
  _initShow() async {
    await ApiService.instance.fetchShow(id: widget.id).then((show) {
      setState(() {
        _show = show;
        // Checking if summary is too long
        // if it has length more that 200 characters divide into two half
        // User can choose to read full summary by tapping on "Show more" button
        if (_show.summary.length > 200) {
          // find next space in summary String
          int index = 200;
          while(_show.summary[index] != " "){
            index++;
          }
          print(index);
          firstHalfSummary = _show.summary.substring(0, index);
          secondHalfSummary = _show.summary.substring(index, _show.summary.length);
        } else {
          firstHalfSummary = _show.summary;
          secondHalfSummary = "";
        }
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

  // _buildDivider() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(
  //       horizontal: 8.0,
  //     ),
  //     width: double.infinity,
  //     height: 1.0,
  //     color: Colors.grey.shade400,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final headingTextStyle = TextStyle(
        fontSize: width * 0.031,
        color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.7));
    final bodyTextStyle = TextStyle(
      fontSize: width * 0.036,
    );
    final _scrollController = ScrollController();
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
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black, Colors.transparent],
                                  ).createShader(Rect.fromLTRB(0, height * 0.03,
                                      rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: _getImage(_show.imageUrl),
                                    ),
                                    ClipRRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // FittedBox(
                              //     fit: BoxFit.fitWidth,
                              //     child: _getImage(_show.imageUrl),
                              //   ),
                              // ClipRRect(
                              //   child: BackdropFilter(
                              //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              //     child: Container(
                              //       color: Colors.grey.withOpacity(0.1),
                              //     ),
                              //   ),
                              // ),
                              Positioned(
                                top: mediaQuery.padding.top,
                                child: Container(
                                  // padding: EdgeInsets.only(left: 8),
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context).canvasColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(width * .1),
                                        topRight: Radius.circular(width * .1),
                                      ),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_outlined,
                                      size: height * 0.03,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 8.0,
                          top: (height * 0.22) / 2,
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
                                          Text(
                                            _show.genres.join(', '),
                                            style: headingTextStyle,
                                          ),
                                          Flexible(
                                            child: SizedBox(
                                              width: width * 0.5,
                                              child: AutoSizeText(
                                                _show.name,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                      fontSize: width * 0.06,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  // _buildDivider(),
                  // SizedBox(height: height * 0.015,),
                  Container(
                    padding: EdgeInsets.only(
                      top: height * 0.015,
                      bottom: height * 0.015,
                    ),
                    // margin: EdgeInsets.only(left: 8.0,right: 8.0),
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .color
                        .withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star),
                                SizedBox(
                                  width: width * 0.007,
                                ),
                                Text(
                                  'Rating:',
                                  style: headingTextStyle,
                                ),
                              ],
                            ),
                            Text(
                              _show.rating,
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.slideshow_outlined),
                                SizedBox(
                                  width: width * 0.007,
                                ),
                                Text(
                                  'Season:',
                                  style: headingTextStyle,
                                ),
                              ],
                            ),
                            Text(
                              _show.seasonNo,
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tv),
                                SizedBox(
                                  width: width * 0.007,
                                ),
                                Text(
                                  'Episode:',
                                  style: headingTextStyle,
                                ),
                              ],
                            ),
                            Text(
                              _show.episodeNo,
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time_outlined),
                                SizedBox(
                                  width: width * 0.007,
                                ),
                                Text(
                                  'Time:',
                                  style: headingTextStyle,
                                ),
                              ],
                            ),
                            Text(
                              _show.runtime == 'null'
                                  ? '-'
                                  : _show.runtime + " min",
                              style: bodyTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: height * 0.015,),
                  // _buildDivider(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 10, bottom: 4),
                    child: Text(
                      'Overview:',
                      style: headingTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, top: 1),
                    child: Text(
                      (showFullSummary ? (firstHalfSummary+secondHalfSummary) : (firstHalfSummary +"...")),
                      style: bodyTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Text(
                            showFullSummary ? "show less" : "show more",
                            style: TextStyle(color: headingTextStyle.color.withOpacity(0.5),),
                          ),
                          onTap: (){
                            setState(() {
                              showFullSummary = !showFullSummary;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 10, bottom: 4),
                    child: Text(
                      'Cast:',
                      style: headingTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left,size: width * 0.08,),
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset - width,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,

                            );
                          },
                        ),
                        Container(
                          height: height * 0.06,
                          width: width * (1 - 0.26),
                          child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _show.casts.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  width: width * 0.1,
                                  height: width * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    image: DecorationImage(
                                      image: NetworkImage(_show.casts[i]),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color
                                          .withOpacity(0.6),
                                      width: 1.0,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right,size: width * 0.08,),
                          onPressed: () {
                            _scrollController.animateTo(
                                _scrollController.offset + width,
                                duration: Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,

                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
