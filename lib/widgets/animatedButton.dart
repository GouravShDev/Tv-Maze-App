import 'package:flutter/material.dart';

import '../theme_builder.dart';

class ZAnimatedButton extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;

  ZAnimatedButton({
    Key key,
    @required this.values,
    @required this.onToggleCallback,
  }) : super(key: key);

  @override
  _ZAnimatedButtonState createState() => _ZAnimatedButtonState();
}

class _ZAnimatedButtonState extends State<ZAnimatedButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeProvider = ThemeBuilder.of(context);
    return Container(
      width: width * .7,
      height: width * .10,
      child: Stack(
        children: [
          Container(
            width: width * .7,
            height: width * .10,
            decoration: ShapeDecoration(
                color: themeProvider.textColor.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * .1)),
                shadows: [
                  BoxShadow(
                    color: themeProvider.textColor.withOpacity(0.08),
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.values.length,
                (index) => InkWell(
                  onTap: () {
                    widget.onToggleCallback(widget.values[index]);
                  },
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: width * .06),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                          fontSize: width * .05,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
              alignment: themeProvider.isLightTheme()
                  ? Alignment.centerLeft
                  : themeProvider.isDarkTheme()
                      ? Alignment.center
                      : Alignment.centerRight,
              duration: Duration(milliseconds: 350),
              curve: Curves.ease,
              child: Container(
                alignment: Alignment.center,
                width: width * .25,
                height: width * .10,
                decoration: ShapeDecoration(
                    color: themeProvider.uiColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * .1)),
                    shadows: [BoxShadow(color: themeProvider.textColor)]),
                child: Text(
                  themeProvider.isLightTheme()
                      ? widget.values[0]
                      : themeProvider.isDarkTheme()
                          ? widget.values[1]
                          : widget.values[2],
                  style: TextStyle(
                      fontSize: width * .045, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
