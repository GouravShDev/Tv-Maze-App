import 'package:flutter/material.dart';
import 'package:tv_maze/constants.dart' as Constants;

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final headingTextStyle = TextStyle(
        color: Theme.of(context).colorScheme.secondaryVariant,
        fontSize: 22,
        fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).textTheme.bodyText2.color.withOpacity(0.1)
                    : Colors.white,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: width * 0.4,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                    Text(
                      'TV MAZE',
                      style: headingTextStyle,
                    ),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        child: const Text(
                          Constants.APP_DESCRIPTION,
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).textTheme.bodyText2.color.withOpacity(0.1)
                    : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Text(
                        "Credits",
                        style: headingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'Developer : '),
                              TextSpan(
                                  text: Constants.DEVELOPER,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'UI design Ideas : '),
                              TextSpan(
                                  text: Constants.CREDITS_UI,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'Testers : '),
                              TextSpan(
                                  text: Constants.TESTERS,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'Special Thanks to '),
                              TextSpan(
                                  text: Constants.THANKS_MSG,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' for API.'),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).textTheme.bodyText2.color.withOpacity(0.1)
                    : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Text(
                        "Info",
                        style: headingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'Source : '),
                              TextSpan(
                                  text: Constants.SOURCE_LINK,
                                  style: TextStyle(fontWeight: FontWeight.bold)),

                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                            children: [
                              TextSpan(text: 'Version : '),
                              TextSpan(
                                  text: 'v1.0',
                                  style: TextStyle(fontWeight: FontWeight.bold)),

                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
