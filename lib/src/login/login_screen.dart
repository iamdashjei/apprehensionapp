import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/pnplogo.png',
                    height: 300,
                    width: 300.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('Enter your E-mail Address'),
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: new InputDecoration(
                    fillColor: Color(0xFFE1E1E1),
                    filled: true,
                    hintText: 'Type here',
                    hintStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    labelStyle:
                        new TextStyle(color: Colors.grey.withOpacity(.01)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                      'Make sure your e-mail is registered by your Master Dealer'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 150, height: 40),
                      child: ElevatedButton(onPressed: (){},
                          child: Text('NEXT', style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFAA00)),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: 
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('Or use Existing E-mail Address (Select One)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
