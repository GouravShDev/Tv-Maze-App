import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tv_maze/screens/show_details_screen.dart';

class ShowsTile extends StatelessWidget {
  final String id;
  final String showTitle;
  final String imageUrl;
  final String rating;
  final MediaQueryData mediaQueryData;
  ShowsTile({this.showTitle, this.imageUrl, this.id, this.rating,this.mediaQueryData});

  @override
  Widget build(BuildContext context) {
    var _containerWidth = (mediaQueryData.size.width/3) - 5;
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
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8))),
              padding: const EdgeInsets.all(8.0),
              child: Text(rating,style: TextStyle(color: Colors.white),),
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
                color: Colors.black.withOpacity(0.8),
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
              onTap: () {
                print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowDetails(id: id,title : showTitle,),
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
