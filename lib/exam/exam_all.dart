import 'package:carousel_slider/carousel_slider.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/attendance_controller.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/diary_controller.dart';
import '../controller/exam_controller.dart';
import '../controller/signinup_controller.dart';

class ExamAll extends StatelessWidget {

  // List won_num_list = ['0', '①', '②', '③', '④'];
  // List answer_list = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  List title_list = ['번호','성명','국어','사회','수학','과학','영어'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          /// 1월,2월은 전학년도 처리
              .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
              .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
          (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
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

            ExamController.to.all_score_list_docs = [];

            return Container(
              width: MediaQuery.of(context).size.width*0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, ),
                              onPressed: () {
                                ExamController.to.addScore('국어');
                              },
                              child: Text('국어 채점', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, ),
                              onPressed: () {
                                ExamController.to.addScore('사회');
                              },
                              child: Text('사회 채점', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, ),
                              onPressed: () {
                                ExamController.to.addScore('수학');
                              },
                              child: Text('수학 채점', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, ),
                              onPressed: () {
                                ExamController.to.addScore('과학');
                              },
                              child: Text('과학 채점', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, ),
                              onPressed: () {
                                ExamController.to.addScore('영어');
                              },
                              child: Text('영어 채점', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, ),
                          onPressed: () {
                            ExamController.to.exportExcel();
                          },
                          child: Text('엑셀로 내보내기', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('전체 결과', style: TextStyle(fontFamily: 'Jua', fontSize: 20),),
                  Table(
                    columnWidths: {
                      0: FractionColumnWidth(0.1),
                      // 1: FractionColumnWidth(0.7)
                    },
                    border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                    children: [
                      /// 반번호,성명,국사수과영,
                      TableRow(children: [
                        for (int title_index = 0; title_index < 7; title_index++)
                          TableCell(
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              color: Colors.teal.withOpacity(0.3),
                              child: Text(title_list[title_index], style: TextStyle(fontSize: 15, ),),
                            ),
                          ),
                      ]),

                    ],
                  ),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: AttendanceController.to.attendanceDocs.length,
                    itemBuilder: (context, index) {
                      var attendance_doc = AttendanceController.to.attendanceDocs[index];
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
                              .where('number', isEqualTo: attendance_doc['number'] ).snapshots(),
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
                              // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black.withOpacity(0.5))));
                            }

                            var korea_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '국어');
                            var society_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '사회');
                            var math_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '수학');
                            var science_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '과학');
                            var eng_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '영어');

                            int korea_all_score = 0;
                            int society_all_score = 0;
                            int math_all_score = 0;
                            int science_all_score = 0;
                            int eng_all_score = 0;
                            List all_score_list = [0,0,0,0,0];

                            if (korea_docs.length > 0) {
                              korea_all_score = korea_docs.first['a1_score']+korea_docs.first['a2_score']+korea_docs.first['a3_score']+korea_docs.first['a4_score']+korea_docs.first['a5_score']+
                                  korea_docs.first['a6_score']+korea_docs.first['a7_score']+korea_docs.first['a8_score']+korea_docs.first['a9_score']+korea_docs.first['a10_score']+
                                  korea_docs.first['a11_score']+korea_docs.first['a12_score']+korea_docs.first['a13_score']+korea_docs.first['a14_score']+korea_docs.first['a15_score']+
                                  korea_docs.first['a16_score']+ korea_docs.first['a17_score']+korea_docs.first['a18_score']+korea_docs.first['a19_score']+korea_docs.first['a20_score']+
                                  korea_docs.first['a21_score']+ korea_docs.first['a22_score']+korea_docs.first['a23_score']+korea_docs.first['a24_score']+korea_docs.first['a25_score'];
                            }

                            if (society_docs.length > 0) {
                              society_all_score = society_docs.first['a1_score']+society_docs.first['a2_score']+society_docs.first['a3_score']+society_docs.first['a4_score']+society_docs.first['a5_score']+
                                  society_docs.first['a6_score']+society_docs.first['a7_score']+society_docs.first['a8_score']+society_docs.first['a9_score']+society_docs.first['a10_score']+
                                  society_docs.first['a11_score']+society_docs.first['a12_score']+society_docs.first['a13_score']+society_docs.first['a14_score']+society_docs.first['a15_score']+
                                  society_docs.first['a16_score']+ society_docs.first['a17_score']+society_docs.first['a18_score']+society_docs.first['a19_score']+society_docs.first['a20_score']+
                                  society_docs.first['a21_score']+ society_docs.first['a22_score']+society_docs.first['a23_score']+society_docs.first['a24_score']+society_docs.first['a25_score'];
                            }
                            if (math_docs.length > 0) {
                              math_all_score = math_docs.first['a1_score']+math_docs.first['a2_score']+math_docs.first['a3_score']+math_docs.first['a4_score']+math_docs.first['a5_score']+
                                  math_docs.first['a6_score']+math_docs.first['a7_score']+math_docs.first['a8_score']+math_docs.first['a9_score']+math_docs.first['a10_score']+
                                  math_docs.first['a11_score']+math_docs.first['a12_score']+math_docs.first['a13_score']+math_docs.first['a14_score']+math_docs.first['a15_score']+
                                  math_docs.first['a16_score']+ math_docs.first['a17_score']+math_docs.first['a18_score']+math_docs.first['a19_score']+math_docs.first['a20_score']+
                                  math_docs.first['a21_score']+ math_docs.first['a22_score']+math_docs.first['a23_score']+math_docs.first['a24_score']+math_docs.first['a25_score'];
                            }
                            if (science_docs.length > 0) {
                              science_all_score = science_docs.first['a1_score']+science_docs.first['a2_score']+science_docs.first['a3_score']+science_docs.first['a4_score']+science_docs.first['a5_score']+
                                  science_docs.first['a6_score']+science_docs.first['a7_score']+science_docs.first['a8_score']+science_docs.first['a9_score']+science_docs.first['a10_score']+
                                  science_docs.first['a11_score']+science_docs.first['a12_score']+science_docs.first['a13_score']+science_docs.first['a14_score']+science_docs.first['a15_score']+
                                  science_docs.first['a16_score']+ science_docs.first['a17_score']+science_docs.first['a18_score']+science_docs.first['a19_score']+science_docs.first['a20_score']+
                                  science_docs.first['a21_score']+ science_docs.first['a22_score']+science_docs.first['a23_score']+science_docs.first['a24_score']+science_docs.first['a25_score'];
                            }
                            if (eng_docs.length > 0) {
                              eng_all_score = eng_docs.first['a1_score']+eng_docs.first['a2_score']+eng_docs.first['a3_score']+eng_docs.first['a4_score']+eng_docs.first['a5_score']+
                                  eng_docs.first['a6_score']+eng_docs.first['a7_score']+eng_docs.first['a8_score']+eng_docs.first['a9_score']+eng_docs.first['a10_score']+
                                  eng_docs.first['a11_score']+eng_docs.first['a12_score']+eng_docs.first['a13_score']+eng_docs.first['a14_score']+eng_docs.first['a15_score']+
                                  eng_docs.first['a16_score']+ eng_docs.first['a17_score']+eng_docs.first['a18_score']+eng_docs.first['a19_score']+eng_docs.first['a20_score']+
                                  eng_docs.first['a21_score']+ eng_docs.first['a22_score']+eng_docs.first['a23_score']+eng_docs.first['a24_score']+eng_docs.first['a25_score'];
                            }

                            all_score_list = [korea_all_score,society_all_score,math_all_score,science_all_score,eng_all_score];
                            ExamController.to.all_score_list_docs.add({'number': attendance_doc['number'], 'score': all_score_list});

                            return Table(
                              columnWidths: {
                                0: FractionColumnWidth(0.1),
                                // 1: FractionColumnWidth(0.7)
                              },
                              border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                              children: [
                                /// 반번호,성명,국사수과영, 미도달
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      color: Colors.white,
                                      child: Text(attendance_doc['number'].toString(), style: TextStyle(fontSize: 15, color: Colors.black),),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      color: Colors.white,
                                      child: Text(attendance_doc['name'].toString(), style: TextStyle(fontSize: 15, color: Colors.black),),
                                    ),
                                  ),
                                  for (int score_index = 0; score_index < 5; score_index++)
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        color: Colors.white,
                                        child: Text(all_score_list[score_index].toString(), style: TextStyle(fontSize: 15, color: Colors.black),),
                                      ),
                                    ),
                                ]),

                              ],
                            );
                          }
                      );

                    },

                  ),
                ],
              ),
            );
          }
      ),
    );

  }
}



