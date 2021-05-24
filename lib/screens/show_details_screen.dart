import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/services/api_services.dart';
import 'package:tv_maze/constants.dart';
import 'package:tv_maze/utils/custom_icon_icons.dart';
import 'package:tv_maze/utils/database_helper.dart';
import 'package:tv_maze/widgets/library_add_dialog.dart';

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
  String _firstHalfSummary = "";
  String _secondHalfSummary = "";
  bool _offline = false;
  int _showStatus = 0;

  bool _showFullSummary = false;
  bool _summaryUnder = false;

  _initShow() {
    ApiService.instance.fetchShow(id: widget.id).then((show) {
      if (show != null) {
        _show = show;
        // Checking if summary is too long
        // if it has length more that 200 characters divide into two half
        // User can choose to read full summary by tapping on "Show more" button
        if (_show.summary.length > 201) {
          // find next space in summary String
          int index = 200;
          while (_show.summary[index] != " ") {
            index++;
          }
          print(index);
          _firstHalfSummary = _show.summary.substring(0, index);
          _secondHalfSummary =
              _show.summary.substring(index, _show.summary.length);
        } else {
          _firstHalfSummary = _show.summary;
          _summaryUnder = true;
          // secondHalfSummary = "";
        }
        _getStatusFromDatabase();
      } else {
        setState(() {
          _offline = true;
        });
      }
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

/*
* This method retrieve value of status variable From Database
*/
  _getStatusFromDatabase() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    var show = await databaseHelper.getShowById(widget.id);
    // If show not found in database so getShowId returns null
    if (show == null) {
      setState(() {
        _showStatus = 0;
      });
    } else {
      if (_showStatus != show.status) {
        setState(() {
          _showStatus = show.status;
        });
      }
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return StatusColors.consideringColor;
      case 2:
        return StatusColors.watchingColor;
      case 3:
        return StatusColors.completedColor;
      case 4:
        return StatusColors.droppedColor;
      default:
        return Theme.of(context).textTheme.bodyText2.color;
    }
  }

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
      body: (_show == null)
          ? (!_offline)
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor,
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
                          _initShow();
                        },
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ])
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
                                  // Create Image Fading Effect
                                  return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black, Colors.transparent],
                                  ).createShader(Rect.fromLTRB(0, height * 0.03,
                                      rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                // Create Image blur effect
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
                              Positioned(
                                top: mediaQuery.padding.top,
                                child: Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _getImage(_show.imageUrl),
                                  Container(
                                    child: Container(
                                      height: height * 0.25,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                          Text(
                                            _show.genres.join(', '),
                                            style: headingTextStyle,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 8.0),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  // color: Colors.grey
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .color
                                                      .withOpacity(0.08),
                                                  spreadRadius: 0,
                                                  blurRadius: 10,
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .color
                                                        .withOpacity(0.3),
                                                    width: 1),
                                              ),
                                              // color: Theme.of(context).textTheme.bodyText2.color,
                                              color:
                                                  Theme.of(context).canvasColor,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _showStatus > 0
                                                        ? "Remove "
                                                        : "Add ",
                                                    style: TextStyle(
                                                      color: _getStatusColor(
                                                          _showStatus),
                                                      // color: Theme.of(context).canvasColor,
                                                      fontSize: width * 0.035,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    CustomIcon.popcorn,
                                                    color: _getStatusColor(
                                                        _showStatus),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return LibraryDialog(
                                                              _show,
                                                              _showStatus);
                                                        })
                                                    .then((_) =>
                                                        _getStatusFromDatabase());
                                              },
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
                  Container(
                    padding: EdgeInsets.only(
                      top: height * 0.015,
                      bottom: height * 0.015,
                    ),
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
                              _show.runtime == 'N/A'
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
                    child: (_summaryUnder)
                        ? Text(
                            _firstHalfSummary,
                            style: bodyTextStyle,
                          )
                        : Text(
                            (_showFullSummary
                                ? (_firstHalfSummary + _secondHalfSummary)
                                : (_firstHalfSummary + "...")),
                            style: bodyTextStyle,
                          ),
                  ),
                  if (!_summaryUnder)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Text(
                              _showFullSummary ? "show less" : "show more",
                              style: TextStyle(
                                color: headingTextStyle.color.withOpacity(0.5),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _showFullSummary = !_showFullSummary;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  if (_show.casts.length > 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 14, left: 10, bottom: 4),
                      child: Text(
                        'Cast:',
                        style: headingTextStyle,
                      ),
                    ),
                  if (_show.casts.length > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            size: width * 0.08,
                          ),
                          onPressed: () {
                            // Scroll the cast images to left
                            _scrollController.animateTo(
                              _scrollController.offset - width,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        ),
                        Container(
                          height: height * 0.06,
                          width: width * (0.9 - 0.26),
                          child: ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _show.casts.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3.0,
                                    horizontal: 6.0,
                                  ),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        NetworkImage(_show.casts[i]),
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                              }),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            size: width * 0.08,
                          ),
                          onPressed: () {
                            // Scroll the cast images to right
                            _scrollController.animateTo(
                              _scrollController.offset + width,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
