import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tv_maze/models/shows.dart';

class ApiService{
  ApiService._instantiate();

  static final ApiService instance = ApiService._instantiate();

  final String _baseUrl = 'api.tvmaze.com';
  // String _nextPageToken = '';

  /*
  * This Method search name and return List of Shows Object
  */
  Future<List<Shows>> searchShows({String showsName}) async{
    List<Shows> showList = [];
    Map<String, String> parameters = {
      'q' : showsName,
    };
    // Example Url : api.tvmaze.com/search/shows?q=dexter
    Uri uri = Uri.https(
      _baseUrl,
      '/search/shows',
      parameters,
    );
    var response = await http.get(uri);
    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      data.forEach((showData) {
        print(showData);
        Shows show = Shows.fromMap(showData['show']);
        showList.add(show);
        show.displayShowData();
      });

      return showList;
    }else{
      return null;
    }
  }

  /*
  * This Method fetch show by id and return Shows Object
  */
  Future<Shows> fetchShow({String id}) async{
    // Example Url : http://api.tvmaze.com/shows/1231?embed[]=episodes&embed[]=cast
    // Uri uri = Uri.https(
    //   _baseUrl,
    //   '/shows/'+ id,
    //   {'embed[]': 'episodes'},
    // );
    // Converting String to URI
    Uri uri = Uri.parse("https://"+_baseUrl+"/shows/"+id+"?embed[]=episodes&embed[]=cast");
    print(uri);
    var response = await http.get(uri);
    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      Shows show = Shows.fromMap(data);
      show.displayShowData();
      return show;
    }else{
      return null;
    }
  }

}