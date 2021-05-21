

/*
* This method removes Html tags like <br> from the string
*/

String removeHTMLTag(String string){
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );
  string = string.replaceAll(exp, "");
  return string;
}

enum CustomTheme{
  light,
  dark,
  black,
}

/*
* This method convert String to DateTime format
*/
DateTime convertStringToDate(String dateString){
  // Date in Format yyyy-mm-dd
  return DateTime.parse(dateString + " 00:00:00.000");
}

/*
* Constants to be used throughout the app
*/
String baseTheme = 'theme';

/*
* This method Extract cast image url from cast
* data received from api
*/
List<String> getListOfImageUrl(List<dynamic> list){
  List<String> urlList = [];
  print(list);
  list.forEach((element) {
    if(element['person']['image'] != null){
      urlList.add(element['person']['image']['medium']);
    }
  });
  return urlList;
}