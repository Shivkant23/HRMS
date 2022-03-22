import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrm/ui/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this, duration: const  Duration(milliseconds: 2000));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    startTimeout();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  startTimeout() async {
    var duration = const Duration(seconds: 2);
    return Timer(
        duration,
        () => Navigator.of(context).pushReplacementNamed(HomeScreen.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  color: Colors.white,
                  child: Image.asset(
                      'assets/logo.png'),
                ),
              ));
  }
}