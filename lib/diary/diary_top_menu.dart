import 'package:classdiary2/common/entrance_exit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/attendance_controller.dart';
import '../controller/board_controller.dart';
import '../controller/class_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/signinup_controller.dart';
import '../web/dashboard.dart';

class DiaryTopMenu extends StatelessWidget {

  void exitDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('닫기', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
                ),
              ),
            ],),
          content: EntranceExit(),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      /// 홈
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          Get.off(() => Dashboard());
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              // Image.asset('assets/images/quiz_home_icon.png', height: 33,),
              Icon(Icons.house_siding, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              SizedBox(height: 10,),
              Text('학급다이어리', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),
      /// < --- 날짜선택 ----->
      Row(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              DiaryController.to.current_page_index.value = DiaryController.to.current_page_index.value - 1;
            },
            child: Icon(Icons.arrow_circle_left, size: 40, color: Colors.orangeAccent,),
          ),
          SizedBox(width: 10,),
          Obx(() => Text(DiaryController.to.diary_days[DiaryController.to.current_page_index.value], style: TextStyle(fontFamily: 'Jua', fontSize: 30),)),
          SizedBox(width: 10,),
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              DiaryController.to.current_page_index.value = DiaryController.to.current_page_index.value + 1;
            },
            child: Icon(Icons.arrow_circle_right, size: 40, color: Colors.orangeAccent,),
          ),
        ],
      ),

      /// 입퇴장
      TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              exitDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.exit_to_app, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('입퇴장 관리', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                ],
              ),
            ),
          ),

    ]);

  }
}


