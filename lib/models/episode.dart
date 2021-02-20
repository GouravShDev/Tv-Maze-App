import 'package:flutter/foundation.dart';
import 'package:tv_maze/models/shows.dart';

class Episode{
  final String id;
  final String name;
  final int season;
  final int epNumber;
  final DateTime airDate;
  final String imageUrl;
  final String summary;

  Episode({
    @required this.id,
    @required this.name,
    @required this.summary,
    @required this.imageUrl,
    @required this.airDate,
    @required this.epNumber,
    @required this.season,
});

  factory Episode.fromMap(Map<String, dynamic> map){
    return Episode(
      id: map['id'],
      name: map['name'],
      season: map['season'],
      summary: map['summary'],
      epNumber: map['number'],
      imageUrl: map['image']['original'],
      airDate: convertStringToDate(map['airdate']),
    );
  }
}