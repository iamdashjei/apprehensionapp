import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pnpdict/src/util/hex_color.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;

  final double initialRadius = 30.0;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
            0.0,
            1.0,
            curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );
    animationRadiusOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticIn),
      ),
    );
    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialRadius;
        } else if (controller.value >= 0.00 && controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialRadius;
        }
      });
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Stack(
            children: <Widget>[
              Dot(
                radius: 30,
                color: Colors.black12,
              ),
              Transform.translate(
                offset: Offset(radius * cos(pi/4), radius * sin(pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.blue,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(2*pi/4), radius * sin(2*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(3*pi/4), radius * sin(3*pi/4)),
                child: Dot(
                    radius: 10.0,
                    color:Colors.deepPurpleAccent
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(4*pi/4), radius * sin(4*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(5*pi/4), radius * sin(5*pi/4)),
                child: Dot(
                    radius: 10.0,
                    color:Colors.deepPurpleAccent
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(6*pi/4), radius * sin(6*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.lightBlue,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(7*pi/4), radius * sin(7*pi/4)),
                child: Dot(
                    radius: 10.0,
                    color:Colors.deepPurpleAccent
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(8*pi/4), radius * sin(8*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({Key key, this.radius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
