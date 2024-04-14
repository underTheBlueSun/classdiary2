import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/mobile/mobile_signinup_view.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/attendance_controller.dart';
import 'package:intl/intl.dart';

import '../controller/signinup_controller.dart';

// ignore_for_file: prefer_const_constructors

class Absent extends StatelessWidget {

  void calendarDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 450,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],),
                TableCalendarWidget(gubun: 'absent',),
              ],
            ),
          ),
        );
      },
    );
  }

  void memoDialog(BuildContext context, doc) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: SizedBox(
            height: 150.0,
            child: SingleChildScrollView(
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
                        child: Icon(Icons.close_outlined,),
                      ),
                    ],),
                  Text(
                    AttendanceController.to.selectedDate.substring(5,7) + '월 ' +
                        AttendanceController.to.selectedDate.substring(8,10) + '일(' +
                        DateFormat.E('ko_KR').format(DateTime.parse(AttendanceController.to.selectedDate.value)) + ')',
                  ),
                  SizedBox(height: 5,),
                  Text(
                    doc['name'],

                  ),
                  SizedBox(height: 5,),
                  Divider(thickness: 1, height: 1,),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: TextEditingController(text: doc['memo']),
                      autofocus: true,
                      onChanged: (value) {
                        AttendanceController.to.absentMemo = value;
                      },
                      maxLines: 6,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "내용을 입력하세요",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                        // border: OutlineInputBorder(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
          onPressed: () {
            AttendanceController.to.updAbsentMemo(doc.id);
            Navigator.pop(context);
          }, // onPressed
          style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
          child: Text('저장',),
          // child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.grey : Colors.black),),
        ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// 브라우져에서 탭을 하나 더 추가하면 모든 데이터 다 가져옴
    /// 모바일앱은 main에서만 처리하면 되던데 웹은 안먹힘.
    if (GetStorage().read('email') == null) {
      FirebaseAuth.instance.signOut();
    }

    AttendanceController.to.getAbsentCnt();
    // AttendanceController.to.getAttendance();

    return Obx(() => Column(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              /// 날짜선택
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      var s_date = DateTime.parse(AttendanceController.to.selectedDate.value);
                      AttendanceController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day-1).toString();
                      AttendanceController.to.getAbsentCnt();
                    },
                    child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 17,),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      calendarDialog(context);
                    },

                    child: Text(
                      AttendanceController.to.selectedDate.substring(0,4) + '.' +
                      AttendanceController.to.selectedDate.substring(5,7) + '.' +
                          AttendanceController.to.selectedDate.substring(8,10) + '(' +
                          DateFormat.E('ko_KR').format(DateTime.parse(AttendanceController.to.selectedDate.value)) + ')',
                      style: TextStyle(color: Colors.grey,),
                    ),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      var s_date = DateTime.parse(AttendanceController.to.selectedDate.value);
                      AttendanceController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day+1).toString();
                      AttendanceController.to.getAbsentCnt();
                    },
                    child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 17,),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              /// 결석 0, 출석인정 0
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.7)),
                  ),
                  SizedBox(width: 5,),
                  Text('결석 ${AttendanceController.to.absentCnt.value}'),
                  SizedBox(width: 30,),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal.withOpacity(0.7)),
                  ),
                  SizedBox(width: 5,),
                  Text('출석인정 ${AttendanceController.to.agreeCnt.value}'),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1, height: 1,),
            ],
          ),
          SizedBox(height: 20,),
          /// 이거 안해주면 출석부에서 이름 추가할때 칸 모양 이상해 진다.
          Text(AttendanceController.to.selectedDate.value, style: TextStyle(fontSize: 1, color: Colors.transparent),),
          StreamBuilder<QuerySnapshot>(
              /// 1월,2월은 전 학년도로 처리
              stream: FirebaseFirestore.instance
                  .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
                  .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2)  ?
              (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                  // .collection('attendance').where('email', isEqualTo: GetStorage().read('email')).where('yyyy', isEqualTo: DateTime.now().year.toString())
                  .orderBy('number', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Container(
                    height: 40,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: DashboardController.to.kDefaultRainbowColors,
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.transparent
                    ),
                  ),);
                  // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                }
              return Container(
                height: 600,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 5 / 1, //item 의 가로, 세로 의 비율
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    // AttendanceController.to.getAbsentOrNot(doc['number']);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                              || index + 1 == AttendanceController.to.attendanceCnt.value
                              ? BorderSide(width: 1, color: Colors.transparent,)
                              : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                          right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                        ),
                      ),
                      child: Container(
                        // width: 100,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 3,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('absent').where('email', isEqualTo: GetStorage().read('email'))
                                    .where('number', isEqualTo: doc['number'])
                                    .where('date', isEqualTo: AttendanceController.to.selectedDate.value.substring(0,10)).snapshots(),
                                builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                    if (!snapshot2.hasData) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                                    // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                                  }
                                  return InkWell(

                                    onTap: () {
                                      if (doc['name'] == '') {
                                        return;
                                      }
                                      if (snapshot2.data!.docs.length == 0) {
                                        AttendanceController.to.saveAbsent(doc, '없음');
                                      }else if (snapshot2.data!.docs[0]['gubun'] == '결석') {
                                        AttendanceController.to.saveAbsent(snapshot2.data!.docs[0], '결석');
                                      } else {
                                        AttendanceController.to.saveAbsent(snapshot2.data!.docs[0], '인정');
                                      }
                                      AttendanceController.to.getAbsentCnt();
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(
                                          width: 19,
                                          child:
                                          CircleAvatar(
                                            backgroundColor: snapshot2.data!.docs.length == 0
                                                ? Colors.black.withOpacity(0.4)
                                                : snapshot2.data!.docs[0]['gubun'] == '결석'
                                                ? Colors.orange.withOpacity(0.7)
                                                : Colors.teal.withOpacity(0.7),
                                            child: Center(
                                              child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: 65,
                                          child: Text(doc['name'] ),

                                        ),
                                        if (snapshot2.data!.docs.length != 0)
                                          IconButton(
                                            onPressed: () {

                                              memoDialog(context, snapshot2.data!.docs[0]);
                                            },
                                            icon: Icon(Icons.assignment_outlined, color: Colors.grey.withOpacity(0.7), size: 14.0,),
                                          ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    );

                  },

                ),
              );
            }
          ),
        ],
      ),
    );
  }

}



