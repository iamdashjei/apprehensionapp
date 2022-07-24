import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnpdict/src/pages/main_dashboard_page.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/services/storage.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import 'package:http/http.dart' as http;

import 'login_email_screen.dart';

class LoginPinCodeScreen extends StatefulWidget {
  final String email;

  LoginPinCodeScreen({Key key, @required this.email}) : super(key: key);
  @override
  LoginPinCodeState createState() => LoginPinCodeState();
}

class LoginPinCodeState extends State<LoginPinCodeScreen>{
  bool isFirstPin = false, isSecondPin = false, isThirdPin = false, isFourthPin = false, isFifthPin = false, isSixthPin = false;
  String firstPin = "", secondPin = "", thirdPin = "", fourthPin = "", fifthPin = "", sixthPin = "";
  String allPinCombined = "";
  String pinCode = "123456";

  SharedPreferences pref;

  final databaseReference = FirebaseDatabase.instance.reference();
  final SecureStorage secureStorage = SecureStorage();

  StreamSubscription<Event> _onRetailerAdded;
  StreamSubscription<Event>  _onRetailUpdate;
  Query _todoQuery;
  Map<String, String> emailAndPin = new HashMap<String, String>();
  Map<String, String> emailAndStatus = new HashMap<String, String>();
  Map<String, String> emailAndUID = new HashMap<String, String>();

  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    // _todoQuery = databaseReference.reference().child("retailers");
    // _onRetailerAdded = _todoQuery.onChildAdded.listen(onEntryRetailerAdded);
    // _onRetailUpdate = _todoQuery.onChildChanged.listen(onEntryRetailerChanged);

    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    // _onRetailerAdded.cancel();
    // _onRetailUpdate.cancel();
  }

  loadData() async {
    pref = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/pnplogo.png',
                    height: 100.0,
                    width: 150.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.email, style: TextStyle(color: Colors.grey), maxLines: 2,),
                    SizedBox(width: 2,),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginEmailScreen()), (Route<dynamic> route) => false);
                      },
                      child: Text('Change Email', style: TextStyle(color: Color(0xFF0B1043)),),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Enter your 6 digit PIN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B1043))),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isFirstPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isSecondPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isThirdPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isFourthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isFifthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      width: width * 0.07,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isSixthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("1", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('1', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("2", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('2', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("3", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('3', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("4", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('4', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("5", context);
                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('5', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;

                        verifyPin("6", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('6', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("7", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('7', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("8", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('8', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("9", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('9', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height * 0.10,
                      width: width * 0.18,
                      child: Center(child: Text('_', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("0", context);
                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('0', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("del", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Icon(Icons.arrow_back, color: Colors.white, size: 30,) ),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 20.0),
                Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 150, height: 40),
                      child: ElevatedButton(onPressed: (){},
                        child: Text('Forgot Password?',  style: TextStyle(fontSize: 12, color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFAA00)),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyPin(String input, BuildContext context) async {
    print("Verifying " + allPinCombined);
    setState(() {
      if(input == "del"){
        if(isFirstPin == true && isSecondPin == false && isThirdPin == false && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isFirstPin = false;
          firstPin = "";
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == false && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isSecondPin = false;
          secondPin = "";
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isThirdPin = false;
          thirdPin = "";
          // 123 -> 12
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == false && isSixthPin == false){
          isFourthPin = false;
          fourthPin = "";
          // 1234 -> 123
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == false){
          isFifthPin = false;
          fifthPin = "";
          // 123 -> 1234
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == true){
          isSixthPin = false;
          sixthPin = "";
          // 12345 -> 1234
        }
      } else {
        if(isFirstPin == false){
          isFirstPin = true;
          firstPin = input;
        } else if(isFirstPin == true && isSecondPin == false){
          isSecondPin = true;
          secondPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == false){
          isThirdPin = true;
          thirdPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == false){
          isFourthPin = true;
          fourthPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == false){
          isFifthPin = true;
          fifthPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == false){
          isSixthPin = true;
          sixthPin = input;
        }
        allPinCombined = firstPin + secondPin + thirdPin + fourthPin + fifthPin + sixthPin;
      }


    });
    if(allPinCombined.length == 6){

      if(allPinCombined == "123456"){
        if(verifyEmail(widget.email)){
          pref.setBool("isLoggedIn", true);
          Session.setAdmin(key: "yes");
          // Admin
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              MainDashboardPage()), (Route<dynamic> route) => false);
        }
      }  else {
        if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == true){
          setState(() {
            isFirstPin = false;
            isSecondPin = false;
            isThirdPin = false;
            isFourthPin = false;
            isFifthPin = false;
            isSixthPin = false;
            fifthPin = "";
            secondPin = "";
            thirdPin = "";
            fourthPin = "";
            fifthPin = "";
            sixthPin = "";
          });
          showAlertDialog(context);
        }
      }
    }
    //print(emailAndPin.values.toString());
    // if(allPinCombined == pinCode){
    //   print("Enter now");
    //
    //
    // } else {
    //
    //
    // }

  }

  bool verifyEmail(String email){
    // setUID

    if(email == "pangjov@gmail.com"){
      Session.setUID(uid: "1748842c-8b7a-454b-bf71-52e688d152b1");
      return true;
    } else if (email == "jbguevarra@gmail.com"){
      Session.setUID(uid: "238c66ec-2a46-4995-8ab7-7ccb85e59a22");
      return true;
    } else if (email == "arbryaltes@gmail.com"){
      Session.setUID(uid: "3b5fab7e-a1d5-4030-8ed9-d16f1f1fc441");
      return true;
    } else if (email == "erpasista@gmail.com"){
      Session.setUID(uid: "3e6fbe32-8be2-4b05-9e66-c863bd202f18");
      return true;
    } else if (email == "melusana@gmail.com"){
      Session.setUID(uid: "9e5ad8b8-9fbf-4595-b086-a5fa79b0183a");
      return true;
    } else if (email == "hermanolorente04@gmail.com"){
      Session.setUID(uid: "e8d62a69-2acd-4fab-9f5f-44034c26e6ed");
      return true;
    } else {
      return false;
    }
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
      title: Text("Try again"),
      content: Text("Sorry you have entered wrong pin."),
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

  onEntryRetailerAdded(Event event) {

    if(event.snapshot.value != null){
      setState(() {
        emailAndPin.putIfAbsent(event.snapshot.value["email"].toString(), () => event.snapshot.value["pin"].toString());
        emailAndStatus.putIfAbsent(event.snapshot.value["email"].toString(), () => event.snapshot.value["activatedStatus"].toString());
        emailAndUID.putIfAbsent(event.snapshot.value["email"].toString(), () => event.snapshot.value["uid"].toString());
      });


    }

    //print("IDS => " + onlineIds.values.toString());
  }

  onEntryRetailerChanged(Event event) {

    if(event.snapshot.value != null){
      // print(event.snapshot.value["status"]);
      setState(() {
        emailAndPin.update(event.snapshot.value["email"].toString(), (v) => event.snapshot.value["pin"].toString());
        emailAndStatus.update(event.snapshot.value["email"].toString(), (v) => event.snapshot.value["activatedStatus"].toString());
        emailAndUID.update(event.snapshot.value["email"].toString(), (v) => event.snapshot.value["uid"].toString());
      });

    }
  }


}

