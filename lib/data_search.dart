import 'package:flutter/material.dart';
import './widgets/search_result.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  /*
  * Change theme of search bar according to
  * the Current Theme
  */
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Theme
          .of(context)
          .canvasColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Theme
          .of(context)
          .textTheme
          .bodyText2
          .color),
      primaryColorBrightness: Theme
          .of(context)
          .brightness,
      textTheme: theme.textTheme.copyWith(
        headline6: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultScreen(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // PlaceHolder for the time being
    return Container();
  }
}
