import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnpdict/src/api_connection/stream_api.dart';
import 'package:pnpdict/src/login/login_email_screen.dart';
import 'package:pnpdict/src/pages/main_dashboard_page.dart';
import 'package:pnpdict/src/services/database_helper.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;
  Permission permission = Permission.storage;
  final status = await permission.request();

  if(status.isGranted){
    DatabaseHelper().initDatabase();
  }

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key key, this.isLoggedIn}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: StreamApi.client,
      child: ChannelsBloc(
        child: OverlaySupport(
          child: MaterialApp(
            title: '',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Segoe UI',
            ),
            home: isLoggedIn ? SplashScreen(
              seconds: 5,
              photoSize: 75,
              navigateAfterSeconds: MainDashboardPage(),
              title: new Text(
                'Traffic Violation Ticketing System',
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              image: Image.asset("assets/image/pnplogo.png"),
              backgroundColor: Colors.white,
              loaderColor: HexColor("#0B1043"),
            ) : SplashScreen(
              seconds: 5,
              photoSize: 75,
              navigateAfterSeconds: LoginEmailScreen(),
              title: new Text(
                'Traffic Violation Ticketing System',
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              image: Image.asset("assets/image/pnplogo.png"),
              backgroundColor: Colors.white,
              loaderColor: HexColor("#0B1043"),
            ),
          ),
        ),
      ),
    );
  }
}
