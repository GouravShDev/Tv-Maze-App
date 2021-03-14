import 'package:flutter/foundation.dart';
import 'package:tv_maze/helper_methods.dart';

class Shows{
  final String id;
  final String name;
  final String language;
  final List<String> genres;
  final DateTime premieredOn;
  final String summary;
  final String rating;
  final String imageUrl;
  final String runtime;
  final String seasonNo;
  final String episodeNo;
  final List<String> casts;

  Shows({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.genres,
    @required this.language,
    @required this.premieredOn,
    @required this.summary,
    @required this.rating,
    @required this.runtime,
    @required this.seasonNo,
    @required this.episodeNo,
    @required this.casts,
});

  factory Shows.fromMap(Map<String, dynamic> show){
    // NULL CHECKS Start{
    var showId = show['id'].toString();
    var showName= show['name'];
    var showLanguage = show['language'];
    var showImageUrl;
    var showGenres = show['genres'];
    var showPremiered = show['premiered'];
    var showSummary = show['summary'];
    var showRating = show['rating']['average'];
    var showRuntime = show['runtime'];
    var showCasts;
    var showEpisodeNo;
    var showSeasonNo;

    // Finding Elements in the available response
    if(show['_embedded'] != null){
      showEpisodeNo = show['_embedded']['episodes'];
    }
    if(show['_embedded'] != null){
      showCasts = show['_embedded']['cast'];
    }
    if(show['_embedded'] != null){
      if(show['_embedded']['episodes'].length > 0) {
        showSeasonNo =
        show['_embedded']['episodes'][ show['_embedded']['episodes'].length -
            1]['season'];
      }
    }
    if(show['image'] != null){
      showImageUrl = show['image']['medium'];
    }
    // NULL CHECKS } End

    // Image PlaceHolder Url
    var placeHolderUrl = "https://static.tvmaze.com/images/no-img/no-img-portrait-text.png";
    return Shows(
      id: showId,
      name: showName,
      language: showLanguage,
      genres: showGenres == null ? [] : showGenres.cast<String>(),
      premieredOn: showPremiered != null ? convertStringToDate(showPremiered) : null,
      imageUrl: showImageUrl == null? placeHolderUrl : showImageUrl,
      rating: showRating == null ? '-' : showRating.toString(),
      summary: showSummary == null ? 'Not Available' : removeHTMLTag(showSummary),
      runtime: showRuntime == null ? 'N/A' : showRuntime.toString(),
      episodeNo: showEpisodeNo == null ? 'N/A' : showEpisodeNo.length.toString(),
      seasonNo: showSeasonNo == null ? 'N/A': showSeasonNo.toString(),
      casts: showCasts == null ? [] : getListOfImageUrl(showCasts),
    );
  }

  void displayShowData(){
    print("Shows name : $name");
    print("Shows imageUrl : $imageUrl");
    print("Shows language : $language");
    print("Shows rating : $rating");
    print("Shows premieredOn : ${premieredOn.toString()}");
    print("Shows summary : $summary");
    print("Shows runtime : $runtime");
    print("Shows season : $seasonNo");
    print("Shows episode : $episodeNo");
    // print("cast image url : $casts");
  }


}
