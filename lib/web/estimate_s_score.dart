import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/attendance_controller.dart';
import 'package:intl/intl.dart';

// ignore_for_file: prefer_const_constructors

class EstimateSScore extends StatelessWidget {

  void indiDialog(context, name, docs, number) {
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
                SizedBox(height: 30,),
                Container(
                  height: 400, width: 300,
                  child: ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot doc = docs.toList()[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 250,
                                child: Text(doc['title'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: 30,
                                alignment: Alignment(1.0, 0.0),
                                child: Text(doc['numMap']['${number}'], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.orange.withOpacity(0.7)),),
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
    return SingleChildScrollView(
      child: Obx(() => Column(
        children: [
          /// 이거 안하면 obx 안먹음
          Text(EstiController.to.chartSelections2.length.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
          /// 1월,2월은 전학년도로 처리
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendance').where('email', isEqualTo: GetStorage().read('email') )
                  .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2)  ?
              (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                  // .where('yyyy', isEqualTo: DateTime.now().year.toString() )
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
                height: 390,
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
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                              || index + 1 == AttendanceController.to.attendanceCnt.value
                              ? BorderSide(width: 1, color: Colors.transparent)
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
                                stream: FirebaseFirestore.instance.collection('estimate').where('email', isEqualTo: GetStorage().read('email'))
                                    .where('gubun', isNotEqualTo: '폴더').where('esti', isEqualTo: 'score').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                                  }

                                  var indiTotalDocs;
                                  var score = 0;
                                  var nowYYYY = DateTime.now().toString().substring(0,4);

                                  /// 전체
                                  if (EstiController.to.chartSelections2.length == 0){
                                    indiTotalDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4) == nowYYYY  && doc['numMap'].containsKey('${index+1}'));
                                    indiTotalDocs.forEach((doc) {
                                      score = int.parse(doc['numMap']['${index+1}']) + score;
                                    });

                                  }
                                  /// 선택한 경우
                                  else {
                                    indiTotalDocs = snapshot.data!.docs.where((doc) => doc['date'].substring(0,4) == nowYYYY && (EstiController.to.chartSelections2.contains(doc['folderID'])
                                        || EstiController.to.chartSelections2.contains(doc.id)) && doc['numMap'].containsKey('${index+1}') );
                                    indiTotalDocs.forEach((doc) {
                                      score = int.parse(doc['numMap']['${index+1}']) + score;
                                    });

                                  }

                                  return InkWell(
                                    onTap: () {
                                      indiDialog(context, doc['name'], indiTotalDocs, index+1);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 19,
                                          child:
                                          CircleAvatar(
                                            backgroundColor: Colors.black.withOpacity(0.4),
                                            child: Center(
                                              child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: 60,
                                          child: Text(doc['name'], ),
                                        ),
                                        SizedBox(width: 30,),
                                        Container(
                                          alignment: Alignment(1.0, 0.0),
                                          width: 30,
                                          child: Text(score.toString(), style: TextStyle(color: Colors.orange.withOpacity(0.7)),),
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
      ),
    );
  }

}





