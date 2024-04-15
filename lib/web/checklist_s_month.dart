import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/web/checklist_s_month_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../controller/dashboard_controller.dart';

// ignore_for_file: prefer_const_constructors

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}

class ChecklistSMonth extends StatelessWidget {

  void detailDialog( context, check_date) {
    showDialog(
      context: context,
      barrierDismissible: false, /// 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 700, width: 400,
            child: ChecklistSMonthDetail(check_date,),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AttendanceController.to.getAttendance();
    return Obx(() => SingleChildScrollView(
      child: Column(
          children: [
            /// 이거 안해주면 그래프 자동으로 못그림
            Text(ChecklistController.to.chartSelections.length.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
            Container(
              height: 260,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1 / 1.1, //item 의 가로, 세로 의 비율
                ),
                itemCount:
                /// 1월,2월은 전년도로 처리하기위해, 만약 2월이면 2월(2023)-1월(2023)-12월(2022)-11월(2022)...
                DateTime.now().toString().substring(5,7) == '01' ? 11 + 1 : DateTime.now().toString().substring(5,7) == '02' ? 12 + 1 :
                (int.parse(DateTime.now().toString().substring(5,7)) - 2) + 1,
                // itemCount: (int.parse(DateTime.now().toString().substring(5,7)) - 2) + 1, // +1 하는이유: 년 토탈도 포함시키기 위해
                itemBuilder: (context, index) {
                  var yyyymm = DateTime(DateTime.now().year, DateTime.now().month - (index-1));
                  // var yyyymm;
                  // if (DateTime.now().toString().substring(5,7) == '01' || DateTime.now().toString().substring(5,7) == '02') {
                  //   /// 1월이면
                  //   if(DateTime.now().toString().substring(5,7) == '01') {
                  //     yyyymm = DateTime(DateTime.now().year, DateTime.now().month - (index-1));
                  //   }if(DateTime.now().toString().substring(5,7) == '01') {
                  //
                  //   }
                  //   else{
                  //
                  //   }
                  //   // yyyymm = DateTime(DateTime.now().year - 1, DateTime.now().month - (index-1));
                  // }else{
                  //   /// 3월~12월인 경우
                  //   yyyymm = DateTime(DateTime.now().year, DateTime.now().month - (index-1));
                  // }

                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('checklist').where('email', isEqualTo: GetStorage().read('email')).where('gubun', isNotEqualTo: '폴더').snapshots(),
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

                        var sMonthDocs;
                        num sMonthCheckCnt = 0;
                        num sMonthFileCnt = 0;
                        double percent = 0.0;

                        var check_date;

                        /// 년간
                        if (index == 0) {
                          check_date = DateTime.now().year.toString() + '-13';
                          /// 전체
                          if (ChecklistController.to.chartSelections.length == 0){
                            /// 1월 2월이면
                            if(DateTime.now().toString().substring(5,7) == '01' || DateTime.now().toString().substring(5,7) == '02') {
                              sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4)  == yyyymm.toString().substring(0,4)
                                  || doc['date'].substring(0,4)  == DateTime(yyyymm.year - 1).toString().substring(0,4) );
                            }else{
                              sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4)  == yyyymm.toString().substring(0,4) );
                            }

                            sMonthDocs.forEach((doc) {
                              sMonthCheckCnt += doc['numArray'].length;
                            });
                            sMonthFileCnt = sMonthDocs.length;
                            percent = (sMonthCheckCnt / (sMonthFileCnt * AttendanceController.to.attendanceCnt.value))*100;
                          }
                          /// 선택한 경우
                          else {
                            /// 1월 2월이면
                            if(DateTime.now().toString().substring(5,7) == '01' || DateTime.now().toString().substring(5,7) == '02') {
                              sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4)  == yyyymm.toString().substring(0,4)
                                  || doc['date'].substring(0,4)  == DateTime(yyyymm.year - 1).toString().substring(0,4)
                                  && (ChecklistController.to.chartSelections.contains(doc['folderID']) || ChecklistController.to.chartSelections.contains(doc.id)) );
                            }else{
                              sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4)  == yyyymm.toString().substring(0,4)
                                  && (ChecklistController.to.chartSelections.contains(doc['folderID']) || ChecklistController.to.chartSelections.contains(doc.id)) );
                            }

                            sMonthDocs.forEach((doc) {
                              sMonthCheckCnt += doc['numArray'].length;
                            });
                            sMonthFileCnt = sMonthDocs.length;
                            percent = (sMonthCheckCnt / (sMonthFileCnt * AttendanceController.to.attendanceCnt.value))*100;
                          }
                        }else {
                          check_date = yyyymm.toString();
                          /// 월간
                          if (ChecklistController.to.chartSelections.length == 0){
                            sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == yyyymm.toString().substring(0,7));
                            sMonthDocs.forEach((doc) {
                              sMonthCheckCnt += doc['numArray'].length;
                            });
                            sMonthFileCnt = sMonthDocs.length;
                            percent = (sMonthCheckCnt / (sMonthFileCnt * AttendanceController.to.attendanceCnt.value))*100;
                          } else {
                            sMonthDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == yyyymm.toString().substring(0,7)
                                && (ChecklistController.to.chartSelections.contains(doc['folderID']) || ChecklistController.to.chartSelections.contains(doc.id)) );
                            sMonthDocs.forEach((doc) {
                              sMonthCheckCnt += doc['numArray'].length;
                            });
                            sMonthFileCnt = sMonthDocs.length;
                            percent = (sMonthCheckCnt / (sMonthFileCnt * AttendanceController.to.attendanceCnt.value))*100;
                          }
                        }

                        if (percent.isNaN) {  // 분모가 0 이면
                          percent = 0;
                        }
                        return InkWell(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            // ChecklistController.to.checklistDocs = snapshot.data!.docs;
                            ChecklistController.to.smonthDocs = sMonthDocs;
                            // ChecklistController.to.smonthFileCnt = sMonthFileCnt;
                            // var month = int.parse(DateTime.now().toString().substring(5,7)) - (index-1);
                            detailDialog(context,check_date);
                            // ChecklistController.to.selectedDate.value = yyyymm.toString();
                          },
                          child: index == 0 ?
                          CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 6.0,
                            percent: percent/100,
                            animation: true,
                            animationDuration: 600,
                            header: Text('3월~현재',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            center: Text(percent.round().toString() + '%',
                                style: TextStyle(fontSize: 16, color: Colors.orange.withOpacity(0.7), fontWeight: FontWeight.bold)),
                            progressColor: Colors.orange.withOpacity(0.7),
                            backgroundColor: Colors.grey.withOpacity(0.2),
                          ) :
                          CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 6.0,
                            // percent: 0,
                            percent: percent/100,
                            animation: true,
                            animationDuration: 600,
                            header: Text(DateTime(DateTime.now().year,DateTime.now().month - (index-1)).toString().substring(5,7) + '월',
                            // header: Text((int.parse(DateTime.now().toString().substring(5,7)) - (index-1)).toString() + '월',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            // center: Text(AttendanceController.to.attendanceCnt.value.toString() + '%',
                            center: Text(percent.round().toString() + '%',
                                style: TextStyle(fontSize: 16, color: Colors.orange.withOpacity(0.7), fontWeight: FontWeight.bold)),
                            progressColor: Colors.teal.withOpacity(0.7),
                            backgroundColor: Colors.grey.withOpacity(0.2),
                          ),
                        );
                      }
                  );
                },

              ),
            ),
          ],
        ),
    ),
    );
  }
}

