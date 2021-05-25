import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_maze/providers/shows_provider.dart';
import 'package:tv_maze/screens/show_details_screen.dart';
import 'package:tv_maze/constants.dart';
import 'package:tv_maze/utils/custom_icon_icons.dart';

class ShowsTile extends StatelessWidget {
  final String id;
  final String showTitle;
  final String imageUrl;
  final String rating;
  final int status;
  final MediaQueryData mediaQueryData;

  ShowsTile(
      {this.showTitle,
      this.imageUrl,
      this.id,
      this.rating,
      this.status,
      this.mediaQueryData});

// This method returns Color for Add Icon Depending on Status variable
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
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _containerWidth = (mediaQueryData.size.width / 3) - 5;
    return Container(
      // height: 800,
      width: _containerWidth,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              // height: 600,
              width: _containerWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(8))),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                rating,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if(status > 0 ) Positioned(
            top: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  // topRight: Radius.circular(8),
                ),
                color: Colors.black.withOpacity(0.75),
              ),
              // width: _containerWidth,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Icon(CustomIcon.popcorn,color: _getStatusColor(status),size: 20,),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: _containerWidth,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Colors.black.withOpacity(0.95),
              ),
              width: _containerWidth,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: AutoSizeText(
                  showTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: (){
                  if(status > 0 ) showAlertDialog(context,id);
                },
                onTap: () {
                  print(id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowDetails(
                        id: id,
                        title: showTitle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
* Display dialog to remove show from library
* when long press on any show in Library
* (Only called on Library Screen)
* */
showAlertDialog(BuildContext context, String showId) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Ok"),
    onPressed:  () {
      // Remove Show from Database
      final showProvider = Provider.of<ShowsList>(context,listen: false);
      showProvider.removeFromDatabase(showId);
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: Text("Remove from Library"),
    content: Text("Do you want to remove this show from library?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
