import 'package:flutter/material.dart';
import 'BasicInformation.dart';
import 'Quiz.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => BasicInformation(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/quiz': (context) => Quiz(),
    },
  ));
}
