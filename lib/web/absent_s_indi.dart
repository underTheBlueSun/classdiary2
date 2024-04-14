import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/dashboard_controller.dart';


// ignore_for_file: prefer_const_constructors

class AbsentSIndi extends StatelessWidget {

  void absentIndiDialog(BuildContext context, docs) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 600,
            child: Column(
              children: [
                Row(
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
                SizedBox(height: 20,),
                Text(docs[0]['name']),
                SizedBox(height: 20,),
                Container(
                  height: 500, width: 400,
                  child: ListView.separated(
                    // scrollDirection: Axis.vertical,
                    // primary: false,
                    // shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            // width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration : BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('${docs[index]['date'].toString().substring(5,7)}.${docs[index]['date'].toString().substring(8,10)} '
                                  '(${DateFormat.E('ko_KR').format(DateTime.parse(docs[index]['date']))})',
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width:200,
                            child: Text(docs[index]['memo'],
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Container(
                            // width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration : BoxDecoration(color:
                            docs[index]['gubun'] == '결석' ?
                            Colors.orange.withOpacity(0.7) : Colors.teal.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text(docs[index]['gubun'],
                                style: TextStyle(color: Colors.white, ),
                              ),
                            ),
                          ),

                        ],);
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

    return Obx(() => StreamBuilder<QuerySnapshot>(
/// 1월, 2월
          stream: FirebaseFirestore.instance
              .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
              .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
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
            height: 370,
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
                /// 1월, 2월 이면 전년도 가져오기
                var nowY = (DateTime.now().month == 1 || DateTime.now().month == 2) ?   DateTime(DateTime.now().year -1).toString().substring(0,4) + '-03' : DateTime(DateTime.now().year).toString().substring(0,4) + '-03';  //  2022-03
                var nextYM = (DateTime.now().month == 1 || DateTime.now().month == 2) ? DateTime(DateTime.now().year).toString().substring(0,4) + '-03' : DateTime(DateTime.now().year + 1).toString().substring(0,4) + '-03'; //  2023-03
                // var nowY = DateTime(DateTime.now().year).toString().substring(0,4);  //  2022
                // var nextYM = DateTime(DateTime.now().year + 1).toString().substring(0,4) + '-03'; //  2023-03
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('absent').where('email', isEqualTo: GetStorage().read('email'))
                        .where('number', isEqualTo: doc['number'])
                        .where('date', isGreaterThan: nowY).where('date', isLessThan: nextYM).snapshots(),
                    builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (!snapshot2.hasData) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                      }
                      var absentCnt = snapshot2.data!.docs.where((doc) => doc['gubun'] == '결석').length;
                      var agreeCnt = snapshot2.data!.docs.where((doc) => doc['gubun'] == '인정').length;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)  || index + 1 == AttendanceController.to.attendanceCnt.value
                                ? BorderSide(width: 1, color: Colors.transparent,)
                                : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                            right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                          ),
                        ),
                        child: InkWell(

                          onTap: () {
                            if (snapshot2.data!.docs.length > 0) {
                              absentIndiDialog(context, snapshot2.data!.docs);
                            }

                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 5,),
                              Container(
                                width: 19,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(0.4),
                                  child: Center(
                                    child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 70,
                                child: Text(doc['name'],),
                              ),
                              Row(
                                children: [
                                  Text(absentCnt.toString()),
                                  Text('/'),
                                  Text(agreeCnt.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              },

            ),
          );
        }
      ),
    );
  }

}



