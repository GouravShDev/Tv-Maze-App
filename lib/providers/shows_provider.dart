import 'package:flutter/foundation.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/utils/database_helper.dart';

class ShowsList with ChangeNotifier{
  List<Shows> showsList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();


  List<Shows> get showList{
    return [...showList];
  }



  Future<void> updateDatabase(Shows show,int status, int prevStatus) async {
    print("prevStatus : $prevStatus");
    if(status == 0){
      await databaseHelper.deleteShow(show.id);
    }else{
      show.status = status;
      if(prevStatus == 0){
        await databaseHelper.insertShow(show);
      }else{
        await databaseHelper.updateShow(show);
      }

    }
  }

  Future<int> getStatusFromDatabase(String id) async {
    var show = await databaseHelper.getShowById(id);
    return show == null ? 0 : show.status;

    // if(show == null){
    //   setState(() {
    //     _showStatus = 0;
    //   });
    // }else{
    //   if(_showStatus != show.status){
    //     setState(() {
    //       _showStatus = show.status;
    //     });
    //   }
    // }
  }
}