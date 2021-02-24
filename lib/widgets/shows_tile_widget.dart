import 'package:flutter/material.dart';

class ShowsTile extends StatelessWidget {
  final String id;
  final String showTitle;
  // final String imageUrl; TODO: uncomment
  String imageUrl;
  String rating;

  ShowsTile({this.showTitle, this.imageUrl, this.id, this.rating});

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
              imageUrl,
              height: 400,
              width: 250,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8))),
              padding: const EdgeInsets.all(8.0),
              child: Text(rating,style: TextStyle(color: Colors.white),),
            ),
          ),
          Positioned(
            bottom: 0,
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Colors.black.withOpacity(0.8),
              ),
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Text(
                        showTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),

              ),
            ),
          Positioned.fill(
              child: Material(
              color: Colors.transparent,
              child: InkWell(
              onTap: () {
                print(id);
              },
            ),
          ))
        ],
      ),
    );
  }
}
