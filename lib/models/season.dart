import 'package:flutter/foundation.dart';

import '../helper_methods.dart';

class Season{
  final String id;
  final String name;
  final int episodes;
  final int seasonNumber;
  final DateTime premieredDate;
  final String imageUrl;
  final String summary;

  Season({
    @required this.id,
    @required this.name,
    @required this.summary,
    @required this.imageUrl,
    @required this.premieredDate,
    @required this.seasonNumber,
    @required this.episodes,
  });

  factory Season.fromMap(Map<String, dynamic> map){
    return Season(
      id: map['id'],
      name: map['name'],
      episodes: map['episodeOrder'],
      summary: removeHTMLTag(map['summary']),
      seasonNumber: map['number'],
      imageUrl: map['image']['original'],
      premieredDate: convertStringToDate(map['premiereDate']),
    );
  }
}