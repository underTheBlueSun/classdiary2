import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/mobile/absent_s_indi_detail.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/dashboard_controller.dart';


// ignore_for_file: prefer_const_constructors

class AbsentSIndi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        title: Text('개인별 출결현황', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
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
          return GridView.builder(
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
              var nowY = (DateTime.now().month == 1 || DateTime.now().month == 2) ?   DateTime(DateTime.now().year -1).toString().substring(0,4)+ '-03' : DateTime(DateTime.now().year).toString().substring(0,4)+ '-03';  //  2022-03
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
                            Get.to(() => AbsentSIndiDetail(), arguments: snapshot2.data!.docs);
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
                              child: Text(doc['name'], style: TextStyle(fontSize: 17),),
                            ),
                            Row(
                              children: [
                                Text(absentCnt.toString(), style: TextStyle(color: Colors.orange.withOpacity(0.7), fontSize: 17),),
                                Text('/'),
                                Text(agreeCnt.toString(), style: TextStyle(color: Colors.white, fontSize: 17),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },

          );
        }
      ),
      bottomNavigationBar: BottomNaviBarWidget(),
    );
  }

}



