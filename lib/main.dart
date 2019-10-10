import 'package:flutter/material.dart';
import 'package:gifio/src/ui/Home.dart';

void main(List<String> args) {
    runApp(
        MaterialApp(
            home: Home(),
            theme: ThemeData(
                hintColor: Colors.white
            ),
        )
    );
}