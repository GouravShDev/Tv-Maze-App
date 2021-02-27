class ShowsData {
  List<String> ids;
  List<String> titles;
  List<String> imageUrls;
  List<String> ratings;

  ShowsData({this.ids, this.titles, this.imageUrls, this.ratings});

  void addData(
      {List<String> ids,
      List<String> titles,
      List<String> imageUrls,
      List<String> ratings}) {
    this.ids..addAll(ids);
    this.titles..addAll(titles);
    this.imageUrls.addAll(imageUrls);
    this.ratings..addAll(ratings);
  }

  int getLength(){
    return ids.length;
  }
}
