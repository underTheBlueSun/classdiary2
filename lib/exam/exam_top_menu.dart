import 'package:classdiary2/controller/exam_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/entrance_exit.dart';
import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/signinup_controller.dart';
import '../controller/subject_controller.dart';
import '../web/dashboard.dart';

class ExamTopMenu extends StatelessWidget {

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

  // void answerDialog(context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // backgroundColor: Color(0xFF4C4C4C),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         title: Row(
  //           children: [
  //             TextButton(
  //               style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(5),
  //                 child: Text('닫기', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
  //               ),
  //             ),
  //           ],),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Container(
  //                 // padding: const EdgeInsets.symmetric(horizontal: 5),
  //                 child: TextField(
  //                   // controller: TextEditingController(text: doc['memo']),
  //                   onChanged: (value) {
  //                     ExamController.to.subject = value;
  //                   },
  //                   style: TextStyle( fontSize: 15.0,),
  //                   decoration: InputDecoration(
  //                     hintText: "과목 입력",
  //                     hintStyle: TextStyle(fontSize: 13.0,),
  //                     border: InputBorder.none,
  //                   ),
  //                 ),
  //               ),
  //               Divider(),
  //               for (int number = 1; number < 26; number++)
  //               Row(
  //                 children: [
  //                   Container(
  //                     width: 20,
  //                     child:
  //                     CircleAvatar(
  //                       backgroundColor: Colors.teal,
  //                       child: Center(
  //                         child: Text(number.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10,),
  //                   Container(
  //                     width: 100,
  //                     // padding: const EdgeInsets.symmetric(horizontal: 5),
  //                     child: TextField(
  //                       keyboardType: TextInputType.number,
  //                       inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
  //                       // controller: TextEditingController(text: doc['memo']),
  //                       onChanged: (value) {
  //                         ExamController.to.answer_list[ExamController.to.answer_list.indexWhere((e) => e.number == number)].answer = int.parse(value);
  //                       },
  //                       // style: TextStyle( fontSize: 15.0,),
  //                       decoration: InputDecoration(
  //                         hintText: "${number}번 답안 입력",
  //                         // border: InputBorder.none,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 30,),
  //               Container(
  //                 width: 200,
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, ),
  //                   onPressed: () async{
  //                     ExamController.to.addAnswer();
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('저장', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  // }

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
              /// 전체결과
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () async{
                  ExamController.to.active_screen.value = 'exam_all';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.all_inbox_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('전체결과', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 개인별결과
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  ExamController.to.active_screen.value = 'exam_indi';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.person, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('개인별결과', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 답안지작성
              GetStorage().read('email') == 'umssam00@gmail.com' && GetStorage().read('job') == 'teacher' ?
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  // answerDialog(context);
                  ExamController.to.active_screen.value = 'exam_answer';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.reset_tv_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('정답지', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ) : SizedBox(),
            ]),
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
      ],
    );

  }
}


