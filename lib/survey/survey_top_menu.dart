import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/entrance_exit.dart';
import '../controller/signinup_controller.dart';
import '../web/dashboard.dart';

class SurveyTopMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icon(Icons.house_siding, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('학급다이어리', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 설문지 목록
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () async{
                  // ExamController.to.active_screen.value = 'exam_all';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.list, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('설문 목록', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 설문만들기
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () async{
                  // ExamController.to.active_screen.value = 'exam_all';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.dashboard_customize_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('설문 만들기', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
            ]),
      ],
    );

  }
}


