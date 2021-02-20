import 'package:flutter/material.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initShows();
  }

  _initShows() async{
    /*Shows show = await ApiService.instance
        .searchShows(showsName: "Dexter");*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TvMaze'),
      ),
    );
  }
}

