import 'package:flutter/foundation.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/utils/database_helper.dart';

class ShowsList with ChangeNotifier{
  List<Shows> showsList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();



  _init() async{
    showsList = await databaseHelper.getShowList();
    notifyListeners();
  }
  List<Shows> get showList{
    _init();
    return [...showList];
  }

  // Remove Show from database using id
  Future<void> removeFromDatabase(String showId) async{
    showsList.removeWhere((currShow) => currShow.id == showId);
    await databaseHelper.deleteShow(showId);
    notifyListeners();
  }

  Future<void> updateDatabase(Shows show,int status, int prevStatus) async {
    print("prevStatus : $prevStatus");
    if(status == 0){
      showsList.removeWhere((currShow) => currShow.id == show.id);
      await databaseHelper.deleteShow(show.id);
    }else{
      show.status = status;
      if(prevStatus == 0){
        showsList.add(show);
        await databaseHelper.insertShow(show);
      }else{
        showsList.firstWhere((sh) => sh.id == show.id).status = show.status;
        await databaseHelper.updateShow(show);
      }
    }
    notifyListeners();
  }


}