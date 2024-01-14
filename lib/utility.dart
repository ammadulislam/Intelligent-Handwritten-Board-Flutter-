
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class utils{

  static void flushBarErrorMessage(String message,BuildContext context){
    showFlushbar(context: context,
        flushbar: Flushbar(
          message: message,
          forwardAnimationCurve: Curves.decelerate,
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10
          ),
          padding: EdgeInsets.all(15),
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          backgroundColor: Colors.red,
          duration: Duration(seconds:3),
          icon: Icon(Icons.email,size: 28,color: Colors.white,),
        )..show(context));
  }
}// TODO Implement this library.