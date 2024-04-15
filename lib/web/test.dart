

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Test extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text('모바일'),
      ),
      body: Container(
        color: Colors.red,
          child: Text('bbb')),
    );
  }

}




