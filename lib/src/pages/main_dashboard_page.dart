import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pnpdict/src/api_connection/stream_channel_api.dart';
import 'package:pnpdict/src/api_connection/stream_user_api.dart';
import 'package:pnpdict/src/login/login_email_screen.dart';
import 'package:pnpdict/src/models/FirebaseUser.dart';
import 'package:pnpdict/src/pages/sales/sales.dart';
import 'package:pnpdict/src/printer/PrinterFunctions.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:pnpdict/src/services/storage.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'dart:collection';

import 'apprehension/apprehension.dart';
import 'bulletin/news_feed.dart';
import 'chatroom/chat.dart';



class MainDashboardPage extends StatefulWidget {

  @override
  _MainDashboardPageState createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> with WidgetsBindingObserver{

  final formatter = new NumberFormat("#,##0.00#", "en_US");
  final SecureStorage secureStorage = SecureStorage();

  SharedPreferences preferences;
  DatabaseReference profileReference;


  String currentTab = '', nameTab = '';
  String uid = '', type = '', displayName = '', businessName = '', token = '';
  int _selectedIndex = 0;
  TextEditingController _controller = new TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 0){
        currentTab = "ticketing";
        nameTab = "Ticketing";
      } else if (index == 1){
        currentTab = "sales";
        nameTab = "Dashboard";
      }else if (index == 2){
        currentTab = "bulletin";
        nameTab = "Bulletin";
      } else if (index == 3){
        currentTab = "chatroom";
        nameTab = "Chatroom";
      }
    });

  }

  @override
  void initState() {
    super.initState();


    currentTab = "ticketing";
    nameTab = "Ticketing";

    initPrefAndLogin();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#0B1043"),
        title: Text(nameTab),
        // flexibleSpace: Image(
        //   image: AssetImage('assets/image/outerbox_bg.png'),
        //   fit: BoxFit.cover,
        // ),
      ),
      //body: bodyView(currentTab, userData, localToken));
      body: bodyView(currentTab),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: HexColor("#FFAA00"),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Image.asset('assets/image/ticketing_yellow.png', width: 25, height: 25) : Image.asset('assets/image/ticketing_violet.png', width: 25, height: 25),
            title: Text('Ticketing'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 ? Image.asset('assets/image/dashboard_yellow.png', width: 25, height: 25) : Image.asset('assets/image/dashboard_violet.png', width: 25, height: 25),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 ? Image.asset('assets/image/bulletinyellow_icon.png', width: 25, height: 25) : Image.asset('assets/image/bulletin_icon.png', width: 25, height: 25),
            title: Text('Bulletin'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3 ? Image.asset('assets/image/chatroom_yellow.png', width: 25, height: 25) : Image.asset('assets/image/chat_room.png', width: 25, height: 25),
            title: Text('Chatroom'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

    );
  }

  Widget bodyView(String selectTab) {
    if (selectTab == "ticketing") {
      setState(() {
        _selectedIndex = 0;
      });
      return ApprehensionPage();
    }
    else if (selectTab == "sales") {
      setState(() {
        _selectedIndex = 1;
      });
      return SalesPage();
    }
    else if (selectTab == "bulletin") {
      setState(() {
        _selectedIndex = 2;
      });
      return NewsFeed(uid: uid, accountType: type, displayName: displayName);
    }
    else if (selectTab == "chatroom") {
      setState(() {
        _selectedIndex = 3;
      });
      return Chat();
    }
    else {

      return Container();
    }

  }




  showConvertLoadAlertDialog(BuildContext context) {
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
        Navigator.of(context).pop();
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
                title: Center(child: Text("Convert to Load?")),
                content: SingleChildScrollView(
                  child: Container(
                    height: 250,
                    width: 400,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Center(
                          child: Text("AMOUNT",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: MediaQuery.of(context)
                                    .textScaleFactor *
                                    25),
                          ),
                        ),
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

  void initPrefAndLogin() async {
    preferences = await SharedPreferences.getInstance();
    DatabaseReference usersReference = FirebaseDatabase.instance.reference().child("users");
    // String myUuid = Uuid().v4();
    // Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
    // FirebaseUser firebaseUser = new FirebaseUser();
    // firebaseUser.uid = myUuid;
    // firebaseUser.name = "Erica Reyes Pasista";
    // firebaseUser.status = "Active";
    // firebaseUser.email = "erpasista@gmail.com";
    // firebaseUser.avatar = "";
    // firebaseUser.pin = "123456";
    // firebaseUser.loginName = "Erica Reyes Pasista";
    // firebaseUser.lastActiveAt = DateTime.now().millisecondsSinceEpoch;
    // firebaseUser.type = "staff";
    // childUpdate.putIfAbsent(myUuid, () => firebaseUser.toJson());
    // usersReference.update(childUpdate);

    await Session.getUID().then((value) async {
      TransactionResult transactionResult = await usersReference.child(value).runTransaction((MutableData mutableData) async {
        return mutableData;
      });


      if(transactionResult.dataSnapshot.value != null){
        FirebaseUser firebaseUser = new FirebaseUser();
        firebaseUser.uid = transactionResult.dataSnapshot.value["uid"];
        firebaseUser.name = transactionResult.dataSnapshot.value["name"];
        firebaseUser.status = "Active";
        firebaseUser.email = transactionResult.dataSnapshot.value["email"];
        firebaseUser.avatar = transactionResult.dataSnapshot.value["avatar"];
        firebaseUser.pin = transactionResult.dataSnapshot.value["pin"];
        firebaseUser.loginName = transactionResult.dataSnapshot.value["loginName"];
        firebaseUser.lastActiveAt = DateTime.now().millisecondsSinceEpoch;
        firebaseUser.type = transactionResult.dataSnapshot.value["type"];
        usersReference.child(transactionResult.dataSnapshot.value["uid"]).update(firebaseUser.toJson());

        if(transactionResult.dataSnapshot.value["uid"] == "1748842c-8b7a-454b-bf71-52e688d152b1"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "SPO4: Jovito Pangan",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);

        } else if(transactionResult.dataSnapshot.value["uid"] == "238c66ec-2a46-4995-8ab7-7ccb85e59a22"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "PO3: Jane Guevarra",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);

        } else if(transactionResult.dataSnapshot.value["uid"] == "3b5fab7e-a1d5-4030-8ed9-d16f1f1fc441"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "Dir.: Arjal Bryan Altes",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);
        } else if(transactionResult.dataSnapshot.value["uid"] == "3e6fbe32-8be2-4b05-9e66-c863bd202f18"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "SI: Erica Pasista",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);
        } else if(transactionResult.dataSnapshot.value["uid"] == "9e5ad8b8-9fbf-4595-b086-a5fa79b0183a"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "Sen Insp: Melanio Usana",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);
        } else if(transactionResult.dataSnapshot.value["uid"] == "e8d62a69-2acd-4fab-9f5f-44034c26e6ed"){
          await StreamUserApi.login(idUser: transactionResult.dataSnapshot.value["uid"],
              fullName: "Gen: Hermano Lorente",
              avatar: "",
              type: transactionResult.dataSnapshot.value["type"],
              uid: transactionResult.dataSnapshot.value["uid"]);
        }

        displayName = transactionResult.dataSnapshot.value["name"];
        uid = transactionResult.dataSnapshot.value["uid"];
        type = transactionResult.dataSnapshot.value["type"];
        Session.setFullName(fullName: transactionResult.dataSnapshot.value["name"]);

      }
    });



    // await Session.getAdmin().then((value) async {
    //   print("isAdmin? $value");
    //   if(value == "yes"){
    //     await StreamUserApi.login(idUser: "pnpdictuser3",
    //         fullName: "Maj: Christian Sorante",
    //         avatar: "",
    //         type: "director",
    //         uid: "pnpdictuser3");
    //     Session.setListDriverDetails(listDetails: ["Juan Dela Cruz", "12132 Dau Mabalacat City", "D06-203291938", "Non-Professional", "2022/07/09", "1,2", "UBK838"]);
    //     Session.setListVehicleDetails(listDetails: ["UBK838", "Nissan Sedan", "SNWC165467", "SWWWC234251", "Rob Santos", "06/06/2022"]);
    //   } else {
    //     await StreamUserApi.login(idUser: "pnpdictuser2",
    //         fullName: "SPO1: Juan De Ponce",
    //         avatar: "",
    //         type: "staff",
    //         uid: "pnpdictuser2");
    //     Session.setListDriverDetails(listDetails: ["Marvin Gayle", "0896 Angeles City", "D06-203291938", "Professional", "2025/08/08", "1,2", "ADM1023"]);
    //     Session.setListVehicleDetails(listDetails: ["ADM1023", "Toyota Sedan", "DLWC235467", "DLWWC234251", "Mike Lowie", "10/07/2022"]);
    //   }
    // });
     PrinterFunctions().connectPrinterAutomatic();
  }

  createChannelWithUsers() async {

    String urlImage = "https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png";

    await StreamChannelApi.createChannel(
      context,
      name: "SPO4: Jovito Pangan",
      urlImage: urlImage,
      idMembers: ["1748842c-8b7a-454b-bf71-52e688d152b1"],
    );
  }

  showConfirmLogoutAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      color: HexColor("#0C9E1F"),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: HexColor("#0C9E1F"))
      ),
      child: Text("Confirm"),
      onPressed: () async {
        secureStorage.deleteSecureData(key: 'token');
        await preferences.clear();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginEmailScreen()), (Route<dynamic> route) => false);
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
                insetPadding: EdgeInsets.all(10),
                contentPadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Container(
                    height: 150,
                    width: 400,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Are you sure you want to logout?", style: TextStyle(fontSize: 18),),
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