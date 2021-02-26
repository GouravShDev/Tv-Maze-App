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
    var show = await ApiService.instance.fetchShow(id: widget.id);
    setState(() {
      _show = show;
    });
  }

  @override
  void initState() {
    super.initState();

    _initShow();
  }
  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Added Center widget as placeholder for the time being
      body: 1==1 ? Center(child: Text("Work in Progress"),):Column(
        children: [
          Row(
            children: [
              Image.network(_show.imageUrl),
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
