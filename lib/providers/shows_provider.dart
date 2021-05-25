import 'package:flutter/foundation.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/utils/database_helper.dart';

class ShowsList with ChangeNotifier{
  List<Shows> _showsList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();



  _init() async{
    _showsList = await databaseHelper.getShowList();
    print("ShowsList : $_showsList");
    notifyListeners();
  }
  List<Shows> get showList{
    _init();
    return [..._showsList];
  }

  // Remove Show from database using id
  Future<void> removeFromDatabase(String showId) async{
    _showsList.removeWhere((currShow) => currShow.id == showId);
    await databaseHelper.deleteShow(showId);
    notifyListeners();
  }

  Future<void> updateDatabase(Shows show,int status, int prevStatus) async {
    print("prevStatus : $prevStatus");
    if(status == 0){
      _showsList.removeWhere((currShow) => currShow.id == show.id);
      await databaseHelper.deleteShow(show.id);
    }else{
      show.status = status;
      if(prevStatus == 0){
        _showsList.add(show);
        await databaseHelper.insertShow(show);
      }else{
        _showsList.firstWhere((sh) => sh.id == show.id).status = show.status;
        await databaseHelper.updateShow(show);
      }
    }
    notifyListeners();
  }


}