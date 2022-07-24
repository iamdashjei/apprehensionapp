import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnpdict/src/pages/main_dashboard_page.dart';
import 'package:pnpdict/src/printer/PrinterFunctions.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import './violation_Page.dart';

class UserTotalDetailPage extends StatefulWidget {
  final List<String> violations;
  final List<String> customerDetails;

  const UserTotalDetailPage({Key key, this.violations, this.customerDetails}) : super(key: key);

  @override
  _UserTotalDetailPageState createState() => _UserTotalDetailPageState();
}

class _UserTotalDetailPageState extends State<UserTotalDetailPage> with WidgetsBindingObserver{

  final formatter = new NumberFormat("#,##0.00#", "en_US");
  TextEditingController _controller = new TextEditingController();

  List<String> customerFields = [
    "Driver's Name",
    "Address",
    "Driver's License No.",
    "Type",
    "Expiration Date",
    "Restrictions",
    "Plate No."
  ];
  List<String> customerValueField = [];

  List<String> listViolations = [
    "Driving w/o valid driver's license/conductor's permit",
    "Reckless Driving"
  ];

  bool isEditClicked = false;

  @override
  void initState() {
    super.initState();
    customerValueField = widget.customerDetails;
    //getMyBusinessInfo();
    listViolations = widget.violations;

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
            SizedBox(height: 10),
            new Container(
              child: detailList(),
            ),

            new Flexible(
              child: violationList(context),
            ),

            new Divider(height: 1.0),

            new Container(
              height: 60,
              decoration:
              new BoxDecoration(color: HexColor("#0B1043")),
              child: _buildTextComposer(context),
            ),


          ],
        ),
      ),
    );
    // onWillPop: _onWillPop,

  }

  Widget _buildTextComposer(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        showAlertDialog(context);
      },
      child: new IconTheme(
          data: new IconThemeData(
              color:Theme.of(context).accentColor
          ),
          child: new Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
          )),
    );
  }

  Widget detailList(){
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        itemCount: customerFields.length,
        itemBuilder: (context, index){
          //print(listPayments[index].paymentType.toLowerCase());
          if(customerFields.length > 0){
            return Padding(
              padding: EdgeInsets.only(left: 5, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text(
                          " "+customerFields[index]
                          , style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ),
                  Text(
                      " "+customerValueField[index]
                      , style:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                  SizedBox(height: 5),
                  Divider(thickness: 1, endIndent: 1, indent: 1,),
                ],
              ),
            );
          } else {
            return Container();
          }

        },
      ),
    );
  }

  Widget violationList(BuildContext context){
    return  Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("VIOLATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
          buttonAddNew(context),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.builder(
              itemCount: listViolations.length,
              itemBuilder: (context, index){
                //print(listPayments[index].paymentType.toLowerCase());
                if(listViolations.length > 0){
                  return Padding(
                    padding: EdgeInsets.only(left: 5, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 260,
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                                listViolations[index], style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                        ),
                        SizedBox(height: 5),
                        Divider(thickness: 1, endIndent: 1, indent: 1,),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }

              },
            ),
          ),
          new Container(
            margin: EdgeInsets.only(left: 5),
            color: Colors.white,
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  width: 200,
                  child: new Text(
                    "TOTAL",
                    style: new TextStyle(fontWeight: FontWeight.bold, color: HexColor("#FF0000"), fontSize: 18),
                  ),
                ),
                new Container(
                  child: new Text(
                    formatter.format(1250),
                    style: new TextStyle(fontWeight: FontWeight.bold, color: HexColor("#FF0000"), fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonAddNew(BuildContext context){
    return FlatButton(
      padding: EdgeInsets.only(left: 120, right: 120),
      color: Colors.green,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.green)
      ),
      child: Text("Add New"),
      onPressed: () {
        print("Testing add new");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ViolationPage(),
        ));
      },
    );
  }

  showAlertDialog(BuildContext context){
    // set up the button
    Widget okButton = FlatButton(
      color: HexColor("#0C9E1F"),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: HexColor("#0C9E1F"))
      ),
      child: Text("Yes"),
      onPressed: ()  {
        Session.setListViolations(listViolations: listViolations);
        PrinterFunctions().testPrintTicket().whenComplete(() {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              MainDashboardPage()), (Route<dynamic> route) => false);
        });

      },
    );

    // set up the button
    Widget cancel = FlatButton(
      color: HexColor("#FF0000"),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: HexColor("#FF0000"))
      ),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                //title: Center(child: Text("Confirm Received?")),
                content: SingleChildScrollView(
                  child: Container(
                    height: 220,
                    width: 400,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text("Are you sure?", style: TextStyle(color: HexColor("#373737"),
                            fontSize: MediaQuery.of(context).textScaleFactor * 18, fontWeight: FontWeight.normal))),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            cancel, SizedBox(width: 30), okButton
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // actions: [
                //   Center(child: cancel ,),
                //   okButton,
                // ],
              );
            }
        );

      },
    );
  }



}