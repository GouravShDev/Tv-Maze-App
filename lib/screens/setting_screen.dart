import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  _buildCustomBox(String themeName){
    return InkWell(
      onTap: (){print(themeName);},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          // color: ,
          boxShadow:[
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2.0, // soften the shadow
              // spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                4.0, // Move to right 10  horizontally
                4.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Text(themeName,style: TextStyle(fontSize: 20),),
      ),
    );
  }

  _buildDivider(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0,),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Choose Your Style",style: TextStyle(fontSize: 20),),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCustomBox('Light'),
              _buildCustomBox('Dark'),
              _buildCustomBox('Black'),
            ],
          ),
          _buildDivider(),
        ],
      ),

    );
  }
}
