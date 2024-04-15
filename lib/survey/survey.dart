import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/point_controller.dart';
import '../controller/signinup_controller.dart';
import 'package:get/get.dart';


class Survey extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/cat1.png', width: 200,),
            Text('개발 예정입니다.', style: TextStyle(fontFamily: 'Jua', fontSize: 60),)
          ],
        ),
      ),
    );

  }
}


