import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:classdiary2/controller/signinup_controller.dart';
import 'package:classdiary2/main.dart';
import 'package:classdiary2/mobile/absent.dart';
import 'package:classdiary2/mobile/absent_s_indi.dart';
import 'package:classdiary2/mobile/absent_s_month.dart';
import 'package:classdiary2/mobile/attendance.dart';
import 'package:classdiary2/mobile/checklist_s_month.dart';
import 'package:classdiary2/mobile/checklist_s_week.dart';
import 'package:classdiary2/mobile/consult.dart';
import 'package:classdiary2/mobile/estimate_s_tripple.dart';
import 'package:classdiary2/mobile/estimate_s_score.dart';
import 'package:classdiary2/mobile/mobile_signinup_view.dart';
import 'package:classdiary2/mobile/note.dart';
import 'package:classdiary2/mobile/timetable.dart';
import 'package:classdiary2/mobile/academic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PopUpMenuWidget extends StatelessWidget {

  void accountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 100, width: 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(height: 30,),
                Text('계정을 정말 삭제하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      var authentication = FirebaseAuth.instance;
                      var user = authentication.currentUser;
                      user?.delete().then((value) => print('삭제완료')).catchError((error) { print(error); });

                    }, // onPressed
                    style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                    child: Text('삭제', style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton(
      icon: Icon(Icons.dehaze, ),
      itemBuilder: (BuildContext context) {
        return [
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 0)
            PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 5,),
                Text("월간 출결현황", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 0)
            PopupMenuItem(
            value: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 5,),
                    Text("개인별 출결현황", style: TextStyle(color: Colors.white),),
                  ],
                ),
                Divider(color: Colors.grey,)
              ],
            ),
          ),
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 1)
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 5,),
                  Text("월간 체크현황", style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 1)
            PopupMenuItem(
              value: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_view_week),
                      SizedBox(width: 5,),
                      Text("주간 체크현황", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Divider(color: Colors.grey,)
                ],
              ),
            ),
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 2)
            PopupMenuItem(
              value: 4,
              child: Row(
                children: [
                  Icon(Icons.three_g_mobiledata),
                  SizedBox(width: 5,),
                  Text("평가(상중하)", style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
          if (MobileMainController.to.bottomNaviCurrentIndex.value == 2)
            PopupMenuItem(
              value: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt_rounded),
                      SizedBox(width: 5,),
                      Text("평가(점수)", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Divider(color: Colors.grey,)
                ],
              ),
            ),
          PopupMenuItem(
            value: 6,
            child: Row(
              children: [
                Icon(Icons.view_timeline),
                SizedBox(width: 5,),
                Text("시간표", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          PopupMenuItem(
            value: 7,
            child: Row(
              children: [
                Icon(Icons.people),
                SizedBox(width: 5,),
                Text("출석부", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          PopupMenuItem(
            value: 8,
            child: Row(
              children: [
                Icon(Icons.timeline_rounded),
                SizedBox(width: 5,),
                Text("학사일정", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          PopupMenuItem(
            value: 9,
            child: Row(
              children: [
                Icon(Icons.link),
                SizedBox(width: 5,),
                Text("상담일지", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          PopupMenuItem(
            value: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.note),
                    SizedBox(width: 5,),
                    Text("노트", style: TextStyle(color: Colors.white),),
                  ],
                ),
                Divider(color: Colors.grey,)
              ],
            ),
          ),
          PopupMenuItem(
            value: 11,
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 5,),
                Text("로그아웃", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          PopupMenuItem(
            value: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(width: 5,),
                    Text("계정삭제", style: TextStyle(color: Colors.white),),
                  ],
                ),
                Divider(color: Colors.grey,)
              ],
            ),
          ),
          PopupMenuItem(
            value: 13,
            child: SignInUpController.to.isDarkMode.value == true ?
            Row(
              children: [
                Icon(Icons.light_mode_rounded, color: Colors.orange.withOpacity(0.7),),
                SizedBox(width: 5,),
                Text("라이트모드", style: TextStyle(color: Colors.white),),
              ],
            ) :
            Row(
              children: [
                Icon(Icons.dark_mode_rounded, color: Colors.orange.withOpacity(0.7),),
                SizedBox(width: 5,),
                Text("다크모드", style: TextStyle(color: Colors.white),),
              ],
            )
          ),
        ];
      },
      onSelected: (int value) {
        if (value == 0) {
          Get.to(() => AbsentSMonth());
        }else if (value == 1) {
          Get.to(() => AbsentSIndi());
        }else if (value == 2) {
          Get.to(() => ChecklistSMonth());
        }else if (value == 3) {
          Get.to(() => ChecklistSWeek());
        }else if (value == 4) {
          Get.to(() => EstimateSTripple());
        }else if (value == 5) {
          Get.to(() => EstimateSScore());
        }else if (value == 6) {
          Get.to(() => TimeTable());
        }else if (value == 7) {
          Get.to(() => Attendance());
        }else if (value == 8) {
          Get.to(() => Academic());
        }else if (value == 9) {
          Get.to(() => Consult());
        }else if (value == 10) {
          Get.to(() => Note());
        }else if (value == 11) {
          SignInUpController.to.signOut();
          /// 화면이 바뀌면 signOut이 잘 안먹힘.
          // Get.offAll(() => MobileSignInUpView());
          GetStorage().remove('job');
        }else if (value == 12) {
          accountDialog(context);
        }else if (value == 13) {
          SignInUpController.to.isDarkMode.value = !SignInUpController.to.isDarkMode.value;
          GetStorage().write('isDarkMode', SignInUpController.to.isDarkMode.value);

        }
      },
      color: Color(0xFF47494C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
    );
  }

}