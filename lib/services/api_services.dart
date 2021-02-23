import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tv_maze/models/shows.dart';

class ApiService{
  ApiService._instantiate();

  static final ApiService instance = ApiService._instantiate();

  final String _baseUrl = 'api.tvmaze.com';
  String _nextPageToken = '';

  /*
  This Method search name and return Shows Object
  */
  Future<Shows> searchShows({String showsName}) async{
    Map<String, String> parameters = {
      'q' : showsName,
    };
    // Example Url : api.tvmaze.com/singlesearch/shows?q=dexter
    Uri uri = Uri.https(
      _baseUrl,
      '/search/shows',
      parameters,
    );
    var response = await http.get(uri);
    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body)[0]['show'];
      Shows show = Shows.fromMap(data);
      show.displayShowData();
      return show;
    }else{
      return null;
    }
  }

}