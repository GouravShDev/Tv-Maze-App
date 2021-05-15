import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_maze/models/shows.dart';
import 'package:tv_maze/providers/shows_provider.dart';
import 'package:tv_maze/status_color.dart';

class LibraryDialog extends StatefulWidget {

  final Shows _show;
  final int activeStatus;

  LibraryDialog(this._show,this.activeStatus);

  @override
  _LibraryDialogState createState() => _LibraryDialogState();
}

class _LibraryDialogState extends State<LibraryDialog> {
  List<ShowStatus> _statusList = [
    null,
    ShowStatus(statusName: "Considering", color: StatusColors.consideringColor),
    ShowStatus(statusName: "Watching", color: StatusColors.watchingColor),
    ShowStatus(statusName: "Completed", color: StatusColors.completedColor),
    ShowStatus(statusName: "Dropped", color: StatusColors.droppedColor),
  ];
  int _activeSelection ;

  _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  _buildStatusButton(int status, double sizeWidth,{double height, double width}){

    return Theme.of(context).brightness == Brightness.dark ? Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        shape: StadiumBorder(),
        // highlightColor: statusList[status].color,
        borderSide: BorderSide(
            color: _activeSelection == status
                ? _statusList[status].color
                : _statusList[status]
                .color
                .withOpacity(0.5)),
        onPressed: () {
          _tapHandler(status);
        },
        highlightedBorderColor: _statusList[status].color,
        child: Text(
          _statusList[status].statusName,
          style: TextStyle(fontSize: sizeWidth * 0.03),
        ),
        textColor: _activeSelection == status
            ? _statusList[status].color
            : _statusList[status]
            .color
            .withOpacity(0.5),
      ),
    ):Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          // elevation: 1.0,
          shadowColor: _activeSelection == status ? Theme.of(context).textTheme.bodyText2.color:_statusList[status].color,
          side: BorderSide(color: _activeSelection == status ? Theme.of(context).textTheme.bodyText2.color: _statusList[status].color,),
          backgroundColor: _activeSelection == status ? _statusList[status].color: Theme.of(context).canvasColor,
          primary: _activeSelection == status ? Theme.of(context).textTheme.bodyText2.color:_statusList[status].color,
          // backgroundColor: statusList[status].color,
        ),
        onPressed: () {
          _tapHandler(status);
        },
        child: Text(
          _statusList[status].statusName,
          style: TextStyle(fontSize: sizeWidth * 0.03),
        ),
      ),
    );
  }
  void _tapHandler(int tappedStatus) {
    print("selected Status : $tappedStatus");
    print("current Status : $_activeSelection");
    setState(() {
      if (tappedStatus == _activeSelection) {
        _activeSelection = 0;
      } else {
        _activeSelection = tappedStatus;
      }
    });
  }

  // void _applyButtonHandler(){
  //   if(_activeSelection != widget.activeStatus){
  //     widget.databaseUpdater(_activeSelection,widget.activeStatus);
  //   }
  //   Navigator.pop(context);
  // }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _activeSelection = widget.activeStatus;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showsProvider = Provider.of<ShowsList>(context);
    showsProvider.getStatusFromDatabase(widget._show.id).then((value) => _activeSelection = value);
    final size = MediaQuery.of(context).size;
    final buttonHeight = size.height * 0.06;
    final buttonWidth = size.width * 0.33;
    if(_activeSelection== null){
      _activeSelection = widget.activeStatus;
    }

    // final buttonTextSize = size.width * 0.03;
    // double buttonOpacity = 0.4;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 16,
      // backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.2),
          ),
          color: Theme.of(context).canvasColor.withOpacity(1),
        ),
        // color: Theme.of(context).canvasColor.withOpacity(0.8),
        height: size.height * 0.34,
        // width: size.width * 0.2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: Text(
                'Choose the status',
                style: TextStyle(fontSize: size.width * 0.055),
              ),
            ),
            _buildDivider(),
            SizedBox(
              height: size.height * 0.01,
            ),
            // OutlineButton(onPressed: (){},child: Text(statusList[0].statusName),textColor: statusList[0].color,),
            Expanded(
              // color: Colors.blue,
              // height: size.height * 0.2,
              // color: Colors.red,
              // padding: const EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusButton(1,size.width,width: buttonWidth,height: buttonHeight),
                        _buildStatusButton(2,size.width,width: buttonWidth,height: buttonHeight),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusButton(3,size.width,height: buttonHeight,width: buttonWidth),
                          _buildStatusButton(4,size.width,height: buttonHeight,width: buttonWidth),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: size.width * 0.08,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              size: size.width * 0.08,
                            ),
                            onPressed: (){
                              if(_activeSelection != widget.activeStatus){
                                showsProvider.updateDatabase(widget._show,_activeSelection,widget.activeStatus);
                              }
                              Navigator.pop(context);
                            },
                        ),
                      ],
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

class ShowStatus {
  String statusName;
  Color color;

  ShowStatus({this.statusName, this.color});
}
