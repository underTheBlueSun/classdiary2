import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

class ChecklistSWeekDetail extends StatelessWidget {

  void indiDialog(context, name, docs) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 500,
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
                  ],),
                Text(name),
                SizedBox(height: 20,),
                Container(
                  height: 400, width: 300,
                  child: ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot doc = docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 210,
                                  child: Text(doc['title'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(doc['date'].substring(2,4) + '.' +
                                doc['date'].substring(5,7) + '.' +
                                doc['date'].substring(8,10) + '(' +
                                DateFormat.E('ko_KR').format(DateTime.parse(doc['date'])) + ')',
                              style: TextStyle(fontSize: 12, color: Colors.grey,),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Divider(color: Colors.grey.withOpacity(0.7),);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
            height: 150,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: <ChartData>[
                      for(var key in ChecklistController.to.setStasticsDayCheck2(ChecklistController.to.weekCnt, ChecklistController.to.weekdayOffirstDay).keys.toList()..sort())
                        ChartData(key, ChecklistController.to.setStasticsDayCheck2(ChecklistController.to.weekCnt, ChecklistController.to.weekdayOffirstDay)[key]),
                    ],
                    xValueMapper: (ChartData data, _) => data.x.substring(8,10)  + '일',
                    yValueMapper: (ChartData data, _) => data.y,
                    // name: 'Gold',
                    color: Colors.teal.withOpacity(0.7),
                    width: 0.05,
                  )
                ])
        ),
        /// 개인별
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
                .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2)  ?
            (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                .orderBy('number', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
              }
            return Container(
              height: 500, width: 400,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 4 / 1, //item 의 가로, 세로 의 비율
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];

                  var percent = 0.0;
                  var check_items = [];

                  /// e['date'].substring(0,4) 이거 안해주면 contains때문에 에러남. 이유를 모르겠음.
                  check_items = ChecklistController.to.sweekDocs.where((e) => e['date'].substring(0,4) == ChecklistController.to.selectedDate.substring(0,4)
                      && e['numArray'].contains(index+1)).toList();

                  if (percent.isNaN) {  // 분모가 0 이면
                    percent = 0;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                            || index + 1 == AttendanceController.to.attendanceCnt.value
                            ? BorderSide(width: 1, color: Colors.transparent,)
                            : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                        right: index % 2 == 0 ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                      ),
                    ),
                    // color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        indiDialog(context, doc['name'], check_items);
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 20,
                            child: CircleAvatar(
                              backgroundColor:
                              Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 85,
                            child: Text(doc['name'],),
                          ),
                          Expanded(child: SizedBox()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${percent.round().toString()}%',
                                style: TextStyle(color: Colors.orange.withOpacity(0.7), ),),
                              Text(
                                '(${check_items.length}/${ChecklistController.to.sweekDocs.length})',),
                            ],
                          ),
                          SizedBox(width: 10,),
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
    );
  }
}

