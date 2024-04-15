import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

import '../controller/dashboard_controller.dart';

// ignore_for_file: prefer_const_constructors

class AbsentSMonth extends StatelessWidget {

  void  absentDialog(BuildContext context, docs) {
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
                Text('${docs[0]['date'].substring(0,7)}월'),
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
                            width: 200,
                            child: Text('${docs[index]['name']} (${docs[index]['memo']})',
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

    return Column(
      children: [
        Container(
          height: 260,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1.1, //item 의 가로, 세로 의 비율
              // childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.7),
            ),
            /// 1월, 2월
            itemCount: DateTime.now().month == 1 ? 11 : DateTime.now().month == 2 ? 12 : DateTime.now().month - 2,

            itemBuilder: (context, index) {
              var nowYM = DateTime(DateTime.now().year, DateTime.now().month - index).toString().substring(0,7);  //  2022-08
              var nextYM = DateTime(DateTime.now().year, DateTime.now().month + 1 - index).toString().substring(0,7); //  2022-09

              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('absent').where('email', isEqualTo: GetStorage().read('email'))
                      .where('date', isGreaterThan: nowYM).where('date', isLessThan: nextYM).snapshots(),
                  builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    var absent_items = snapshot.data!.docs.where((doc) => doc['gubun'] == '결석').length;
                    var agree_items = snapshot.data!.docs.where((doc) => doc['gubun'] == '인정').length;

                    return InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (snapshot.data!.docs.length > 0) {
                          absentDialog(context, snapshot.data!.docs);
                        }

                      },
                      child: CircularPercentIndicator(
                        radius: 40,
                        lineWidth: 6.0,
                        percent: 1.0,
                        header: Text(DateTime(DateTime.now().year,DateTime.now().month - index).toString().substring(5,7) + '월',
                          // header: Text((int.parse(DateTime.now().toString().substring(5,7)) - index).toString() + '월',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        center: Text('결석: ${absent_items}\n인정: ${agree_items}'),
                        progressColor: Colors.green,
                      ),
                    );
                  }
              );
            },

          ),
        ),
      ],
    );
  }
}
