import 'dart:async';
import 'package:demo1/wrapper.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 6);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/image/splashscreen.jpg"),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          const Text(
            "",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          const CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 1,
          )
        ],
      )),
    );
  }
}
