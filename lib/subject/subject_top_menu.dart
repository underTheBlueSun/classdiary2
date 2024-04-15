import 'package:cloud_firestore/cloud_firestore.dart';
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

class SubjectTopMenu extends StatelessWidget {

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
              /// 주제일기
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () async{
                  /// 주제목록 가져오기
                  SubjectController.to.mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
                  await SubjectController.to.getSubjects();
                  SubjectController.to.active_screen.value = 'subject';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('주제일기', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 주제편집
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  SubjectController.to.active_screen.value = 'subject_edit';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.edit_calendar_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                      SizedBox(height: 10,),
                      Text('주제편집', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              /// 댓글허용
              /// 댓글 없애니 겹치는거 해결되어서 막음
              // Obx(
              //       () => Column(children: [
              //     SizedBox(height: 15,),
              //     Row(
              //       children: [
              //         Text('댓글허용', style: TextStyle(fontFamily: 'Jua'),),
              //         Switch(
              //           activeColor: Colors.amber,
              //           activeTrackColor: Colors.cyan,
              //           inactiveThumbColor: Colors.blueGrey.shade600,
              //           inactiveTrackColor: Colors.grey.shade400,
              //           splashRadius: 50.0,
              //           value: SubjectController.to.is_subject_comment.value,
              //           onChanged: (value) {
              //             SubjectController.to.is_subject_comment.value = !SubjectController.to.is_subject_comment.value;
              //             SubjectController.to.updCommentAllow();
              //             SubjectController.to.active_screen.value = 'subject_edit';
              //
              //           },
              //         ),
              //
              //       ],
              //     ),
              //   ],),
              // ),
              // SizedBox(width: 200,),

              SizedBox(width: 30,),
              /// <---- 날짜 ---->
              SubjectController.to.active_screen.value == 'subject_edit' ?
                  SizedBox() :
              Row(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (SubjectController.to.subject_id.value == 0) {
                        SubjectController.to.subject_id.value = 365;
                      }else{
                        SubjectController.to.subject_id.value = SubjectController.to.subject_id.value - 1;
                      }

                      SubjectController.to.subject.value = SubjectController.to.subjects[SubjectController.to.subject_id.value].subject;
                      SubjectController.to.mmdd = SubjectController.to.subjects[SubjectController.to.subject_id.value].mmdd;

                      String yyyy_string = DateFormat('yyyy').format(DateTime.now());
                      DateTime yyyymmdd_datetime = DateTime.parse(yyyy_string + SubjectController.to.mmdd);
                      String month = DateFormat('MM').format(yyyymmdd_datetime);
                      String day = DateFormat('dd').format(yyyymmdd_datetime);
                      String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);
                      SubjectController.to.mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';

                    },
                    child: Icon(Icons.arrow_circle_left, size: 45, color: Colors.orangeAccent,),
                  ),
                  SizedBox(width: 10,),
                  Obx(() => Text(SubjectController.to.mmdd_yoil.value, style: TextStyle(fontFamily: 'Jua', fontSize: 40),)),
                  SizedBox(width: 10,),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (SubjectController.to.subject_id.value == 365) {
                        SubjectController.to.subject_id.value = 0;
                      }else{
                        SubjectController.to.subject_id.value = SubjectController.to.subject_id.value + 1;
                      }

                      SubjectController.to.subject.value = SubjectController.to.subjects[SubjectController.to.subject_id.value].subject;
                      SubjectController.to.mmdd = SubjectController.to.subjects[SubjectController.to.subject_id.value].mmdd;

                      String yyyy_string = DateFormat('yyyy').format(DateTime.now());
                      DateTime yyyymmdd_datetime = DateTime.parse(yyyy_string + SubjectController.to.mmdd);
                      String month = DateFormat('MM').format(yyyymmdd_datetime);
                      String day = DateFormat('dd').format(yyyymmdd_datetime);
                      String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);
                      SubjectController.to.mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';
                    },
                    child: Icon(Icons.arrow_circle_right, size: 45, color: Colors.orangeAccent,),
                  ),
                ],
              ),

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


