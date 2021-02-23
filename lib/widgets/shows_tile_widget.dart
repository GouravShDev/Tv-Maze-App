import 'package:flutter/material.dart';

class ShowsTile extends StatelessWidget {
  final String showTitle;
  // final String imageUrl; TODO: uncomment
  String imageUrl;
  final String rating;

  ShowsTile({this.showTitle, this.imageUrl, this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            child: Image.network(
              "https:" + imageUrl, // TODO: Remove https
              height: 400,
              width: 250,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            // right: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Colors.black.withOpacity(0.8),
              ),
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: Text(
                showTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          )
        ],
      ),
    );
  }
}
