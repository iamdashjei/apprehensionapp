import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import './apprehension_total.dart';

class ViolationPage extends StatefulWidget {

  @override
  _ViolationPageState createState() => _ViolationPageState();
}

class _ViolationPageState extends State<ViolationPage> with WidgetsBindingObserver{

  final formatter = new NumberFormat("#,##0.00#", "en_US");
  TextEditingController _controller = new TextEditingController();


  List<String> addedItems = [];
  List<String> customerValueField = [];
  String token = '', deviceIdLatest = '';
  bool expandFlag = false, expandFlagB = false, expandFlagC = false, expandFlagD = false;
  bool isEditClicked = false;

  List<String> violationA = [
    "Driving w/o a valid driver's license/ conductor's permit",
    "Driving MV used in the commission of crime",
    "Commission of a crime in the course of apprehension",
    "Driving MV under the influence of alcohol, dangerous drugs",
    "Reckless Driving",
    "Submission of the fake documents in relation to application of a DL",
    "Failure to wear the prescribed seat belt device",
    "Failure to require his/her passenger to wear the prescribed seat belt device",
    "Failure to wear the standard helmet (driver/backrider)",
    "Failure to carry DL, OR/CR while driving"
  ];

  List<String> violationB = [
    "Driving an unregistered MV",
    "Unauthorized MV modification",
    "Operating a right hand drive MV",
    "MV w/o or defective / improper / unathorized accessories, devices, equipment and parts",
    "Failure to attach or improper attachment / tampering of authorized MV plate and/or 3rd plate sticker",
    "Smoke belching",
    "Fraud in relation to MV registration",
  ];

  List<String> violationC = [
    "Load extending beyond projected width without permit",
    "Axle overloading",
    "Operating a passenger bus/truck with cargo exceeding 160 kilograms"
  ];

  List<String> violationD = [
    "D. Failure to carry DL, OR/CR while driving"
  ];

  @override
  void initState() {
    super.initState();
    getMyBusinessInfo();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  void getMyBusinessInfo() async {
    customerValueField = await Session.getListDriverDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor("#0B1043"),
        centerTitle: true,
        title: Text(" "),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            new Flexible(
              child: detailList(),
            ),

            // new Divider(height: 1.0),

            new Container(
              height: 60,
              child: _buildTextComposer(context),
            ),


          ],
        ),
      ),
    );
    // onWillPop: _onWillPop,

  }

  Widget _buildTextComposer(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 75),
      width: 300,
      height: 200,
      child: Row(
        children: [
          SizedBox(width: 10),
          FlatButton(
            color: HexColor("#FF0000"),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: HexColor("#FF0000"))
            ),
            child: Text("Cancel"),
            onPressed: () {
              print("Testing Cancel");
            },
          ),
          SizedBox(width: 20),
          FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.green)
            ),
            child: Text("Confirm"),
            onPressed: () {
             // print("Testing Confirm");
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UserTotalDetailPage(violations: addedItems, customerDetails: customerValueField),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget detailList(){
    return Column(
      children: <Widget>[
        new Container(
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 5),
                color: Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      "A. Licensed-Related Violations",
                      style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    new IconButton(
                        icon: new Container(
                          height: 50.0,
                          width: 50.0,
                          child: new Center(
                            child: new Icon(
                              expandFlag ? Icons.keyboard_arrow_down_sharp : Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlag = !expandFlag;
                            expandFlagB = false;
                            expandFlagC = false;
                            expandFlagD = false;
                          });
                        }),
                  ],
                ),
              ),
              new ExpandableContainer(
                  expanded: expandFlag,
                  child: new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        decoration:
                        new BoxDecoration(border: new Border.all(width: 1.0, color: addedItems.contains(violationA[index]) ?  HexColor("#0B1043") : Colors.white), color: addedItems.contains(violationA[index]) ?  HexColor("#0B1043") :  Colors.white),
                        child: new ListTile(
                          title: new Text(
                            violationA[index],
                            style: new TextStyle(fontWeight: FontWeight.bold, color: addedItems.contains(violationA[index]) ? Colors.white   : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              if(addedItems.length > 0){
                                if(addedItems.contains(violationA[index])){
                                  addedItems.remove(violationA[index]);
                                } else {
                                  addedItems.add(violationA[index]);
                                }
                              } else {
                                addedItems.add(violationA[index]);
                              }
                            });


                          },
                          // leading: new Icon(
                          //   Icons.local_pizza,
                          //   color: Colors.white,
                          // ),
                        ),
                      );
                    },
                    itemCount: violationA.length,
                  ))
            ],
          ),
        ),
        new Container(
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 5),
                color: Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      "B. MV Registration Violations",
                      style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    new IconButton(
                        icon: new Container(
                          height: 50.0,
                          width: 50.0,
                          child: new Center(
                            child: new Icon(
                              expandFlagB ? Icons.keyboard_arrow_down_sharp : Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlag = false;
                            expandFlagB = !expandFlagB;
                            expandFlagC = false;
                            expandFlagD = false;
                          });
                        }),
                  ],
                ),
              ),
              new ExpandableContainer(
                  expanded: expandFlagB,
                  child: new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        decoration:
                        new BoxDecoration(border: new Border.all(width: 1.0, color: addedItems.contains(violationB[index]) ? HexColor("#0B1043") :  Colors.white), color: addedItems.contains(violationB[index]) ? HexColor("#0B1043") : Colors.white),
                        child: new ListTile(
                          title: new Text(
                            violationB[index],
                            style: new TextStyle(fontWeight: FontWeight.bold, color: addedItems.contains(violationB[index]) ? Colors.white : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              if(addedItems.length > 0){
                                if(addedItems.contains(violationB[index])){
                                  addedItems.remove(violationB[index]);
                                } else {
                                  addedItems.add(violationB[index]);
                                }
                              } else {
                                addedItems.add(violationB[index]);
                              }
                            });


                          },
                          // leading: new Icon(
                          //   Icons.local_pizza,
                          //   color: Colors.white,
                          // ),
                        ),
                      );
                    },
                    itemCount: violationB.length,
                  ))
            ],
          ),
        ),
        new Container(
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 5),
                color: Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 280,
                      child: new Text(
                        "C. Violation in connection with dimension, specifications, weight, and load limit",
                        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),

                    new IconButton(
                        icon: new Container(
                          height: 50.0,
                          width: 50.0,
                          child: new Center(
                            child: new Icon(
                              expandFlagC ? Icons.keyboard_arrow_down_sharp : Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlagC = !expandFlagC;
                            expandFlag = false;
                            expandFlagB = false;
                            expandFlagD = false;
                          });
                        }),
                  ],
                ),
              ),
              new ExpandableContainer(
                  expanded: expandFlagC,
                  child: new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        decoration:
                        new BoxDecoration(border: new Border.all(width: 1.0, color: addedItems.contains(violationC[index]) ? HexColor("#0B1043") : Colors.white), color: addedItems.contains(violationC[index]) ? HexColor("#0B1043") : Colors.white),
                        child: new ListTile(
                          title: new Text(
                            violationC[index],
                            style: new TextStyle(fontWeight: FontWeight.bold, color: addedItems.contains(violationC[index]) ? Colors.white : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              if(addedItems.length > 0){
                                if(addedItems.contains(violationC[index])){
                                  addedItems.remove(violationC[index]);
                                } else {
                                  addedItems.add(violationC[index]);
                                }
                              } else {
                                addedItems.add(violationC[index]);
                              }
                            });


                          },
                          // leading: new Icon(
                          //   Icons.local_pizza,
                          //   color: Colors.white,
                          // ),
                        ),
                      );
                    },
                    itemCount: violationC.length,
                  ))
            ],
          ),
        ),
        new Container(
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 5),
                color: Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      "D. Other Violations/s (Please Specify)",
                      style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    new IconButton(
                        icon: new Container(
                          height: 50.0,
                          width: 50.0,
                          child: new Center(
                            child: new Icon(
                              expandFlagD ? Icons.keyboard_arrow_down_sharp : Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            expandFlagD = !expandFlagD;
                            expandFlagB = false;
                            expandFlagC = false;
                            expandFlag = false;
                          });
                        }),
                  ],
                ),
              ),
              new ExpandableContainer(
                  expanded: expandFlagD,
                  child: new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        decoration:
                        new BoxDecoration(border: new Border.all(width: 1.0, color: addedItems.contains(violationD[index]) ? HexColor("#0B1043") : Colors.white),
                            color: addedItems.contains(violationD[index]) ? HexColor("#0B1043") : Colors.white),
                        child: new ListTile(
                          title: new Text(
                            violationD[index],
                            style: new TextStyle(fontWeight: FontWeight.bold, color: addedItems.contains(violationD[index]) ? Colors.white : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              if(addedItems.length > 0){
                                if(addedItems.contains(violationD[index])){
                                  addedItems.remove(violationD[index]);
                                } else {
                                  addedItems.add(violationD[index]);
                                }
                              } else {
                                addedItems.add(violationD[index]);
                              }
                            });


                          },
                          // leading: new Icon(
                          //   Icons.local_pizza,
                          //   color: Colors.white,
                          // ),
                        ),
                      );
                    },
                    itemCount: violationD.length,
                  ))
            ],
          ),
        ),
      ],
    );
  }



}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(border: new Border.all(width: 1.0, color: Colors.white)),
      ),
    );
  }
}