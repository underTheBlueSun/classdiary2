import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/web/checklist_s_week_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../controller/dashboard_controller.dart';

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}

class ChecklistSWeek extends StatelessWidget {

  void detailDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 700,width: 400,
            child: ChecklistSWeekDetail(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() => SingleChildScrollView(
      child: Column(
          children: [
            /// 이거 안해주면 그래프 자동으로 못그림.
            Text(ChecklistController.to.chartSelections.length.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
            Container(
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1 / 1.1, //item 의 가로, 세로 의 비율
                ),
                itemCount: ChecklistController.to.retWeekOfMonth(),
                itemBuilder: (context, index) {
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
                        DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
                        int weekdayOffirstDay = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 1).weekday;
                        int itemCnt = ChecklistController.to.retWeekOfMonth();

                        var attendance_cnt = AttendanceController.to.attendanceCnt.value;
                        num sWeekCnt = 0;
                        num sWeekFileCnt = 0;
                        double percent = 0.0;
                        var sweekDocs;

                        if (ChecklistController.to.chartSelections.length == 0){
                          sweekDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == firstDayOfMonth.toString().substring(0,7)
                              && ((DateTime.parse(doc['date']).day + weekdayOffirstDay - 1) / 7).ceil() == (itemCnt - index));
                          sweekDocs.forEach((doc) {
                            sWeekCnt += doc['numArray'].length;
                          });

                          sWeekFileCnt = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == firstDayOfMonth.toString().substring(0,7)
                              && ((DateTime.parse(doc['date']).day + weekdayOffirstDay - 1) / 7).ceil() == (itemCnt - index)
                              && doc['gubun'] != '폴더').length;
                        } else {
                          sweekDocs  = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == firstDayOfMonth.toString().substring(0,7)
                              && ((DateTime.parse(doc['date']).day + weekdayOffirstDay - 1) / 7).ceil() == (itemCnt - index)
                              && (ChecklistController.to.chartSelections.contains(doc['folderID']) || ChecklistController.to.chartSelections.contains(doc.id)));
                          sweekDocs.forEach((doc) {
                            sWeekCnt += doc['numArray'].length;
                          });

                          sWeekFileCnt = snapshot.data!.docs.where((doc) => doc['date'].substring(0,7)  == firstDayOfMonth.toString().substring(0,7)
                              && ((DateTime.parse(doc['date']).day + weekdayOffirstDay - 1) / 7).ceil() == (itemCnt - index)
                              && (ChecklistController.to.chartSelections.contains(doc['folderID']) || ChecklistController.to.chartSelections.contains(doc.id)) && doc['gubun'] != '폴더').length;
                        }
                        percent = (sWeekCnt / (sWeekFileCnt * attendance_cnt))*100;
                        if (percent.isNaN) {  // 분모가 0 이면
                          percent = 0;
                        }
                      return InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          ChecklistController.to.selectedDate.value = DateTime.now().toString();
                          // Get.to(() => StasticsCheckWeekDetail(), arguments: [(itemCnt - index), weekdayOffirstDay]);
                          ChecklistController.to.sweekDocs = sweekDocs;
                          ChecklistController.to.weekCnt = itemCnt - index;
                          ChecklistController.to.weekdayOffirstDay = weekdayOffirstDay;
                          detailDialog(context);

                        },
                        child:
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 6.0,
                          percent: percent/100,
                          animation: true,
                          animationDuration: 600,
                          header: Text(
                            (itemCnt - index) == itemCnt ?
                            '이번주(${itemCnt - index}주)' :
                            (itemCnt - index).toString() + '주',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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

