import 'package:flutter/foundation.dart';

class Shows{
  final String id;
  final String name;
  final String language;
  final List<String> genres;
  final DateTime premieredOn;
  final String rating;
  final String imageUrl;

  Shows({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.genres,
    @required this.language,
    @required this.premieredOn,
    @required this.rating,
});

  factory Shows.fromMap(Map<String, dynamic> show){
    return Shows(
      id: show['id'].toString(),
      name: show['name'],
      language: show['language'],
      genres: show['genres'].cast<String>(),
      premieredOn: convertStringToDate(show['premiered']),
      imageUrl: show['image']['original'],
      rating: show['rating']['average'].toString(),
    );
  }
  void displayShowData(){
    print("Shows name : $name");
    print("Shows imageUrl : $imageUrl");
    print("Shows language : $language");
    print("Shows rating : $rating");
    print("Shows premieredOn : ${premieredOn.toString()}");
  }


}
DateTime convertStringToDate(String dateString){
  // Date in Format yyyy-mm-dd
  return DateTime.parse(dateString + " 00:00:00.000");
}