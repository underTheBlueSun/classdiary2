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

class ExamIndi extends StatelessWidget {
  List won_num_list = ['0', '①', '②', '③', '④'];
  List answer_list = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('       맞은 문항은 1, 틀린 문항은 0', style: TextStyle(fontSize: 20, fontFamily: 'Jua', color: Colors.orangeAccent)),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2/1, //item 의 가로, 세로 의 비율
                  // childAspectRatio: 3.5/1, //item 의 가로, 세로 의 비율
                ),
                itemCount: AttendanceController.to.attendanceDocs.length,
                itemBuilder: (context, index) {
                  var attendance_doc = AttendanceController.to.attendanceDocs[index];
                  return Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Text(attendance_doc['name'], style: TextStyle(fontSize: 15, fontFamily: 'Jua')),
                        SizedBox(height: 10,),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                .where('number', isEqualTo: attendance_doc['number']).snapshots(),
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

                              // var sort_docs = snapshot.data!.docs;
                              // sort_docs.sort((a, b) => a['id'].compareTo(b['id']));
                              List subject_list = ['국어','사회','수학','과학','영어'];
                              List won_num_list = ['', '①', '②', '③', '④'];
                              List ox_list = ['X', 'O'];
                              List answer_list = ['a1','a2','a3','a4','a5','a6','a7','a8'
                                ,'a9','a10','a11','a12','a13','a14','a15','a16','a17','a18','a19'
                                ,'a20','a21','a22','a23','a24','a25'];
                              List answer_score_list = ['a1_score','a2_score','a3_score','a4_score','a5_score','a6_score','a7_score','a8_score'
                                ,'a9_score','a10_score','a11_score','a12_score','a13_score','a14_score','a15_score','a16_score','a17_score','a18_score','a19_score'
                                ,'a20_score','a21_score','a22_score','a23_score','a24_score','a25_score'];
                              List docs_list = [];
                              var korea_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '국어');
                              var society_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '사회');
                              var math_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '수학');
                              var science_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '과학');
                              var eng_docs = snapshot.data!.docs.where((doc) => doc['subject'] == '영어');
                              docs_list = [korea_docs,society_docs,math_docs,science_docs,eng_docs];

                              // return
                              // Container(
                              //   decoration: BoxDecoration(
                              //     border: Border.all(),
                              //     // border: Border(
                              //     //   bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                              //     //   right: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                              //     // ),
                              //   ),
                              //   child: Column(children: [
                              //     /// 국사수과영
                              //     for (int subject_index = 0; subject_index < 5; subject_index++)
                              //     Row(children: [
                              //       /// 과목명
                              //       Container(
                              //         width: 50,
                              //         child: Text(subject_list[subject_index]),
                              //       ),
                              //       /// 번호,답지
                              //       for (int score_index = 0; score_index < 24; score_index++)
                              //       Column(
                              //         children: [
                              //           /// 1번
                              //           Container(
                              //             width: 50,
                              //             child: Text('1',),
                              //             // child: Text((score_index+1).toString(),),
                              //           ),
                              //           /// 1번 답지
                              //           Container(
                              //             width: 50,
                              //             child: Text('0',),
                              //             // child: Text(docs_list[subject_index].length > 0 ? docs_list[subject_index].first[answer_score_list[score_index]].toString() : '0',),
                              //           ),
                              //         ],
                              //       ),
                              //     ],),
                              //   ],),
                              // );

                              return Table(
                                border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                                // columnWidths: {
                                //   0: FractionColumnWidth(0.3),
                                //   1: FractionColumnWidth(0.7)
                                // },
                                children: [
                                  /// 번호
                                  TableRow(children: [
                                    for (int num_index = 0; num_index < 26; num_index++)
                                    /// 0번~25번
                                      TableCell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          color: Colors.teal.withOpacity(0.3),
                                          child: Text(num_index==0 ? '' : num_index.toString(), style: TextStyle(fontSize: 15, ),),
                                        ),
                                      ),
                                  ]),
                                  /// 국사수과영
                                  for (int subject_index = 0; subject_index < 5; subject_index++)
                                    TableRow(children: [
                                      /// 과목명
                                      TableCell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          // height: 30,
                                          height: 60,
                                          color: Colors.teal.withOpacity(0.3),
                                          child: Text(subject_list[subject_index], style: TextStyle(fontSize: 15, )),
                                        ),
                                      ),
                                      for (int score_index = 0; score_index < 25; score_index++)
                                      /// 1번 답지
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 60,
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                    child: Text(docs_list[subject_index].length > 0 ? ox_list[docs_list[subject_index].first[answer_score_list[score_index]]].toString() : 'X', style: TextStyle(fontSize: 15, color: Colors.black),)),
                                                Container(
                                                    height: 10,
                                                    child: Divider(color: Colors.grey,)),
                                                Container(
                                                    height: 25,
                                                    child: Text(docs_list[subject_index].length > 0 ? won_num_list[docs_list[subject_index].first[answer_list[score_index]]].toString() : '', style: TextStyle(fontSize: 15, color: Colors.black),)),
                                                // Text(docs_list[subject_index].length > 0 ? docs_list[subject_index].first[answer_score_list[score_index]].toString() : '0', style: TextStyle(fontSize: 15, color: Colors.black),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      //   TableCell(
                                      //     child: Container(
                                      //       alignment: Alignment.center,
                                      //       height: 30,
                                      //       color: Colors.white,
                                      //       child: Text(docs_list[subject_index].length > 0 ? docs_list[subject_index].first[answer_score_list[score_index]].toString() : '0', style: TextStyle(fontSize: 15, color: Colors.black),),
                                      //     ),
                                      //   ),

                                      //   Table(
                                      //       border: TableBorder.all(),
                                      //       children: [
                                      //         TableRow(children: [
                                      //           TableCell(
                                      //               child: Container(
                                      //                 alignment: Alignment.center,
                                      //                 height: 30,
                                      //                 color: Colors.white,
                                      //                 // child: Text(docs_list[subject_index].length > 0 ? ox_list[docs_list[subject_index].first[answer_score_list[score_index]]].toString() : 'X', style: TextStyle(fontSize: 15, color: Colors.black),),
                                      //                 child: Text(docs_list[subject_index].length > 0 ? docs_list[subject_index].first[answer_score_list[score_index]].toString() : '0', style: TextStyle(fontSize: 15, color: Colors.black),),
                                      //               ),
                                      //           ),
                                      //         ]),
                                      //         TableRow(children: [
                                      //           TableCell(
                                      //               child: Container(
                                      //                 alignment: Alignment.center,
                                      //                 height: 30,
                                      //                 color: Colors.white,
                                      //                 // child: Text(docs_list[subject_index].length > 0 ? won_num_list[docs_list[subject_index].first[answer_list[score_index]]].toString() : '', style: TextStyle(fontSize: 15, color: Colors.black),),
                                      //                 child: Text(docs_list[subject_index].length > 0 ? docs_list[subject_index].first[answer_list[score_index]].toString() : '0', style: TextStyle(fontSize: 15, color: Colors.black),),
                                      //               ),
                                      //           ),
                                      //         ]),
                                      //   ]),

                                    ]),

                                ],
                              );

                            }
                        ),

                      ],
                    ),
                  );

                },

              ),
            ],
          );
        }
    );

  }
}



