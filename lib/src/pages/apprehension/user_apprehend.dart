import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import './violation_Page.dart';

class UserDetailPage extends StatefulWidget {

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> with WidgetsBindingObserver{

  final formatter = new NumberFormat("#,##0.00#", "en_US");
  TextEditingController _controller = new TextEditingController();



  String token = '', deviceIdLatest = '';

  List<String> customerFields = [
    "Driver's Name",
    "Address",
    "Driver's License No.",
    "Type",
    "Expiration Date",
    "Restrictions",
    "Plate No."
  ];
  List<String> customerValueField = [
    "Juan Dela Cruz",
    "Test Address",
    "03131246",
    "Non-Professional",
    "2022/01/09",
    "1,2", " "
  ];

  bool isEditClicked = false;

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

              // new Divider(height: 1.0),
              //
              // new Container(
              //   height: 60,
              //   decoration:
              //   new BoxDecoration(color: HexColor("#0B1043")),
              //   child: _buildTextComposer(context),
              // ),


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
        setState(() {


        });

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
      height: 400,
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
          // SizedBox(height: 10),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 100,
          //   child: ListView.builder(
          //     itemCount: 4,
          //     itemBuilder: (context, index){
          //       //print(listPayments[index].paymentType.toLowerCase());
          //       if(customerFields.length > 0){
          //         return Padding(
          //           padding: EdgeInsets.only(left: 5, right: 15),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               Container(
          //                   margin: EdgeInsets.only(left: 5),
          //                   child: Text(
          //                       " "
          //                       , style:
          //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
          //               ),
          //               Text(
          //                   " "
          //                   , style:
          //               TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
          //               SizedBox(height: 5),
          //               Divider(thickness: 1, endIndent: 1, indent: 1,),
          //             ],
          //           ),
          //         );
          //       } else {
          //         return Container();
          //       }
          //
          //     },
          //   ),
          // ),
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



}