import 'package:flutter/material.dart';
import 'package:pnpdict/src/util/hex_color.dart';

import 'login_pincode_screen.dart';

class LoginEmailScreen extends StatefulWidget {

  @override
  _LoginEmailScreenState createState() => new _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  bool isFingerprint = false;
  TextEditingController _controller = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
              ),
              Center(
                child:  Image.asset("assets/images/pnplogo.png", width: 200, height: 150,),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Enter your E-mail Address", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context)
                        .textScaleFactor *
                        16),),
              ),
              Container(
                height: 70,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(0),
                  color: HexColor("#E1E1E1"),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            30),
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: HexColor("#BFBFBF"), fontSize: 30),
                        border: InputBorder.none,
                        hintText: 'Type here...'
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Make sure your Email is registered by your Admin", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context)
                        .textScaleFactor *
                        14),),
              ),
              SizedBox(height: 30),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.only(left: 80.0, right: 80.0),
                  color:  HexColor("#FFAA00"),
                  textColor: HexColor("#0B1043"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: HexColor("#FFAA00"))
                  ),
                  onPressed: () {
                    if(_controller.text == null || _controller.text == ""){
                      showAlertDialog(context);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            LoginPinCodeScreen(email: _controller.text),
                      ));
                    }
                  },
                  child: Text("NEXT", style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: MediaQuery.of(context)
                          .textScaleFactor *
                          14),),
                ),
              ),
              SizedBox(height: 30),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(left: 10.0),
              //       child: Text("Or use Existing E-mail Address (Select One)", style: TextStyle(
              //           fontWeight: FontWeight.normal,
              //           color: Colors.black,
              //           fontSize: MediaQuery.of(context)
              //               .textScaleFactor *
              //               15),),
              //     ),
              //     Container(
              //       height: MediaQuery.of(context).size.height,
              //       child: ListView.builder(
              //         padding: EdgeInsets.zero,
              //           itemCount: 8,
              //           itemBuilder: (context, index){
              //             return GestureDetector(
              //               behavior: HitTestBehavior.translucent,
              //               onTap: () {
              //
              //               },
              //               child: Container(
              //                 //margin: EdgeInsets.only(top: 5.0),
              //                 padding: EdgeInsets.all(10),
              //                 child: Row(
              //                   children: <Widget>[
              //                     Text(
              //                       'jhenanne2315@yahoo.com',
              //                       style:
              //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }),
              //     ),
              //   ],
              // ),

              // Container(
              //   height: 50,
              //   child: ListView.builder(
              //       itemCount: 5,
              //       itemBuilder: (context, index){
              //         return GestureDetector(
              //           behavior: HitTestBehavior.translucent,
              //           onTap: () {
              //
              //           },
              //           child: Container(
              //             //margin: EdgeInsets.only(top: 5.0),
              //             padding: EdgeInsets.all(10),
              //             child: Row(
              //               children: <Widget>[
              //                 Text(
              //                   'jhenanne2315@yahoo.com',
              //                   style:
              //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );

  }

  showAlertDialog(BuildContext context){
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("PNP Ticketing"),
      content: Text("Please enter your email to login."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}