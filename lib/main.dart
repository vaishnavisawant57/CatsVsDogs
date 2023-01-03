import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);
  @override
  State<MySplash> createState() => _MySplash();
}

class _MySplash extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                Home()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Color(0xff3F3B6C),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
         Text(
          "Cat and Dog Classifier",
          style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                  fontSize: 28,
                  color: Color(0xffA3C7D6),
                  letterSpacing: 3,
                  decoration: TextDecoration.none
              )
          ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              child: Image.asset('assets/icon.png'),
            height: 250,
            width: 250,
          ),
          SizedBox(height: 40,),
          LoadingAnimationWidget.staggeredDotsWave(
            color: Color(0xffA3C7D6),
            size: 50,
          ),
        ],
      ),
    );
  }
}
