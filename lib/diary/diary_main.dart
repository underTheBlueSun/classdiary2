import 'package:classdiary2/temperature/temperature.dart';
import 'package:classdiary2/temperature/temperature_top_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/diary_controller.dart';
import '../controller/signinup_controller.dart';
import 'diary.dart';
import 'diary_top_menu.dart';

class DiaryMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        // backgroundColor:  SignInUpController.to.isDarkMode.value == true ? Color(0xFF303030) : Color(0xFFBECEDE),
        // backgroundColor:  Color(0xFFEEE9DF),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// top menu
              Container(
                // color: Colors.grey.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                  child: DiaryTopMenu(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 화면전환
                  Padding(
                    padding: const EdgeInsets.only(left:20, right: 30, top:10, bottom: 20),
                    child: DiaryController.to.active_screen.value == 'diary' ? Diary() : SizedBox(),
                    // DiaryController.to.active_screen.value == 'add' ? Temperature() : SizedBox(),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );

  }
}


