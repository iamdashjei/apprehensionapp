import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

//import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pnpdict/src/pages/apprehension/user_apprehend.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import 'package:unicorndial/unicorndial.dart';

class ApprehensionPage extends StatefulWidget {

  @override
  _ApprehensionPageState createState() => _ApprehensionPageState();
}

class _ApprehensionPageState extends State<ApprehensionPage>{
  final formatter = new NumberFormat("#,##0.00#", "en_US");

  final floatingButtons = List<UnicornButton>();

  TextEditingController _controller = new TextEditingController();
  String tagBarcode = "";

  DatabaseReference databaseReference, saleItems, updateMyInfo;

  StreamSubscription<Event> _onSIMAdded;
  StreamSubscription<Event>  _onSIMUpdate;
  Query _todoQuery;

  double simCounter = 0;

  @override
  void initState() {
    super.initState();

    floatingButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "DL Number",
        currentButton: FloatingActionButton(
          heroTag: "dlNumber",
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.attach_file),
          onPressed: () {
            print('Attachment FAB clicked');
            showSerialAlertDialog(context);
          },
        ),
      ),
    );
    floatingButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Barcode Scan",
        currentButton: FloatingActionButton(
          onPressed: () {
            print('Camera FAB clicked');
            showBarcodeAlertDialog(context, null);
          },
          heroTag: "barcodeScan",
          backgroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.photo_camera),
        ),
      ),
    );

  }

  @override
  void dispose(){
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: new SliverChildListDelegate([
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text("0", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            50),),
                  ),
                  Container(
                    child: Text("Total Apprehended Today", style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            16),),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(thickness: 2, endIndent: 10, indent: 10,),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 800,
                      child: ListView.builder(
                          itemCount: 0,
                          itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                print("Tapped");

                              }, trailing: Text("100002121213", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).textScaleFactor * 18, color: HexColor("##FF0000")),),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("${new DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.now())}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).textScaleFactor * 16)),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Image.asset('assets/image/barcode.png', width: 15, height: 20),
                                  SizedBox(width: 5),
                                  Expanded(child: Text(new Random().nextInt(100000000).toString(), style: TextStyle(fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic, fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                      color: HexColor("##FF0000")))),

                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                            Divider(thickness: 2, endIndent: 10, indent: 10,),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: UnicornDialer(
          backgroundColor: Colors.black38,
          parentButtonBackground: HexColor("#0B1043"),
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: floatingButtons),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: HexColor("#0B1043"),
      //   onPressed: ()  async {
      //     _offsetPopupAlert();
      //
      //   //  var result = await BarcodeScanner.scan();
      //
      //     // print(result.type); // The result type (barcode, cancelled, failed)
      //     // print(result.rawContent); // The barcode content
      //     // print(result.format); // The barcode format (as enum)
      //     // print(result.formatNote);
      //     String barcodeScanRes = await FlutterBarcodeScanner
      //         .scanBarcode(
      //         "#ff6666",
      //         "OK",
      //         false,
      //         ScanMode.DEFAULT);
      //    // print(barcodeScanRes);
      //
      //
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) =>
      //           UserDetailPage(),
      //     ));
      //
      //
      //     // if(simMap.containsKey(barcodeScanRes)){
      //     //   print("SCANNING =>" + simMap[barcodeScanRes].key);
      //     //   showBarcodeAlertDialog(context, barcodeScanRes, simMap[barcodeScanRes]);
      //     // } else {
      //     //   Fluttertoast.showToast(
      //     //       msg: "No result found.",
      //     //       toastLength: Toast.LENGTH_SHORT,
      //     //       gravity: ToastGravity.BOTTOM,
      //     //       timeInSecForIosWeb: 1,
      //     //       backgroundColor: Colors.red,
      //     //       textColor: Colors.white,
      //     //       fontSize: 16.0
      //     //   );
      //     // }
      //     // showBarcodeAlertDialog(context, barcodeScanRes);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  showDummyText(String serial){
    if(serial == "196487532"){
      Session.setListDriverDetails(listDetails: ["Marvin Gayle", "0896 Angeles City", "D06-203291938", "Professional", "2025/08/08", "1,2", "ADM1023"]);
      Session.setListVehicleDetails(listDetails: ["ADM1023", "Toyota Sedan", "DLWC235467", "DLWWC234251", "Mike Lowie", "10/07/2022"]);
    } else if(serial == "235461241"){
      Session.setListDriverDetails(listDetails: ["Juan Dela Cruz", "12132 Dau Mabalacat City", "YXI-92AAAA", "Non-Professional", "2022/07/09", "1,2", "UBK838"]);
      Session.setListVehicleDetails(listDetails: ["UBK838", "Nissan Sedan", "SNWC165467", "SWWWC234251", "Rob Santos", "06/06/2022"]);
    } else if(serial == "241578863"){
      Session.setListDriverDetails(listDetails: ["Belmon Cruz", "2391 Dau Mabalacat City", "HSO-02AAAA", "Non-Professional", "2022/03/04", "1", "RDA231"]);
      Session.setListVehicleDetails(listDetails: ["RDA231", "Mitsubishi Sedan", "REVP09XFAZ", "REVP09XFAZ", "Belmon Cruz", "08/11/2026"]);
    } else if(serial == "114275697"){
      Session.setListDriverDetails(listDetails: ["Kyan Mortimer", "11523 Dau Mabalacat City", "LOG-48AAAA", "Professional", "2025/03/04", "1,2", "KBN321"]);
      Session.setListVehicleDetails(listDetails: ["KBN321", "Nissan Sedan", "JEZS30FMMS", "JEZS30FMMS", "Kyan Mortimer", "08/11/2022"]);
    } else if(serial == "225447343"){
      Session.setListDriverDetails(listDetails: ["Kaden Millar", "23512 Tarlac City", "PPJ-04AAAA", "Non-Professional", "2025/03/04", "1,2", "EA102J"]);
      Session.setListVehicleDetails(listDetails: ["EA102J", "Nissan Sedan", "MEYQ68AOGT", "MEYQ68AOGT", "Kaden Millar", "08/11/2024"]);
    } else if(serial == "124577912"){
      Session.setListDriverDetails(listDetails: ["Kristian Maurer", "2221 Angeles City", "ENP-04AAAA", "Non-Professional", "2025/03/04", "1", "HQA996"]);
      Session.setListVehicleDetails(listDetails: ["HQA996", "Toyota Sedan", "FZVG61LAQQ", "FZVG61LAQQ", "Kristian Maurer", "08/11/2027"]);
    } else if(serial == "889457123"){
      Session.setListDriverDetails(listDetails: ["Alexis Nelson", "3353 Gapan City", "PJV-96AAAA", "Professional", "2025/03/04", "1,2", "UTJ966"]);
      Session.setListVehicleDetails(listDetails: ["IIA239", "Toyota Sedan", "YIPO97LINT", "YIPO97LINT", "Alexis Nelson", "08/11/2024"]);
    } else if(serial == "127894612"){
      Session.setListDriverDetails(listDetails: ["Alicia Shuzen", "1256 Tarlac City", "PRT-11AAAA", "Professional", "2025/03/04", "1", "RDA231"]);
      Session.setListVehicleDetails(listDetails: ["UTJ966", "Hyundai Sedan", "GSTY30OEFL", "GSTY30OEFL", "Alicia Shuzen", "08/11/2021"]);
    } else if(serial == "192168457"){
      Session.setListDriverDetails(listDetails: ["Dolores Quinn", "7453 Angeles City", "MWG-28AIAS", "Professional", "2025/03/04", "1", "ESX845"]);
      Session.setListVehicleDetails(listDetails: ["ESX845", "Toyota Sedan", "RWOH76PLQD", "RWOH76PLQD", "Dolores Quinn", "08/11/2027"]);
    } else if(serial == "111475239"){
      Session.setListDriverDetails(listDetails: ["Phyllis Lynn", "2156 Gapan City", "TOT-58ASAD", "Professional", "2025/03/04", "1,2", "IGN365"]);
      Session.setListVehicleDetails(listDetails: ["IGN365", "Hyundai Sedan", "VIWP24RKKF", "VIWP24RKKF", "Phyllis Lynn", "08/11/2028"]);
    }


    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          UserDetailPage(),
    ));
  }



  showSerialAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      color: HexColor("#0C9E1F"),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: HexColor("#0C9E1F"))
      ),
      child: Text("Confirm"),
      onPressed: () {

        showDummyText(_controller.text);


        //Navigator.of(context).pop();
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
      child: Text("Back"),
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
                title: Center(child: Text("DL Number")),
                content: SingleChildScrollView(
                  child: Container(
                    height: 180,
                    width: 400,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 70,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(0),
                            color: HexColor("#E1E1E1"),
                          ),
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context)
                                      .textScaleFactor *
                                      45),
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),

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

  showBarcodeAlertDialog(BuildContext context, String result) async {


    Session.setListDriverDetails(listDetails: ["Marvin Gayle", "0896 Angeles City", "D06-203291938", "Professional", "2025/08/08", "1,2", "ADM1023"]);
    Session.setListVehicleDetails(listDetails: ["ADM1023", "Toyota Sedan", "DLWC235467", "DLWWC234251", "Mike Lowie", "10/07/2022"]);

    String barcodeScanRes = await FlutterBarcodeScanner
        .scanBarcode(
        "#ff6666",
        "OK",
        false,
        ScanMode.DEFAULT);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          UserDetailPage(),
    ));
  }



}
