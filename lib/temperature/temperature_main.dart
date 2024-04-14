import 'package:classdiary2/temperature/temperature.dart';
import 'package:classdiary2/temperature/temperature_edit.dart';
import 'package:classdiary2/temperature/temperature_top_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/temper_controller.dart';

class TemperatureMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if (GetStorage().read('job') == 'teacher') {
      return Scaffold(
        // backgroundColor: Color(0xFFF7F7F7),
        // backgroundColor:Color(0xFFEEE9DF),
        body: SingleChildScrollView(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// top menu
              Container(
                // color: Colors.grey.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                  child: TemperatureTopMenu(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 화면전환
                  Padding(
                    padding: const EdgeInsets.only(left:20, right: 30, top:10, bottom: 20),
                    child: TemperController.to.active_screen.value == 'temperature' ? Temperature() :
                    TemperController.to.active_screen.value == 'temperature_edit' ? TemperatureEdit() :
                    SizedBox(),
                  ),
                ],
              ),

            ],
          ),
          ),
        ),
      );
    }else {
      return
        MediaQuery.of(context).size.width > 600 ?
        Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: Text('태블릿'),
        ) :
        Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: Text('스마트폰'),
        );
    }


  }
}


