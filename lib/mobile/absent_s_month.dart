import 'package:classdiary2/mobile/absent_s_month_detail.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        title: Transform(
          transform:  Matrix4.translationValues(-50.0, 0.0, 0.0),
          child: Text('월간 출결현황', ),
        ),
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
            childAspectRatio: 1 / 1.1, //item 의 가로, 세로 의 비율
          ),
          itemCount: DateTime.now().month == 1 ? 11 : DateTime.now().month == 2 ? 12 : DateTime.now().month - 2,
          // itemCount: int.parse(DateTime.now().toString().substring(5,7)) - 2,
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
                  onTap: () {
                    if (snapshot.data!.docs.length > 0) {
                      // absentDialog(context, snapshot.data!.docs);
                      Get.to(() => AbsentSMonthDetail(), arguments: snapshot.data!.docs);
                    }

                  },
                  child: CircularPercentIndicator(
                    radius: 40,
                    lineWidth: 6.0,
                    percent: 1.0,
                    header: Text(DateTime(DateTime.now().year,DateTime.now().month - index).toString().substring(5,7) + '월',
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
      bottomNavigationBar: BottomNaviBarWidget(),
    );
  }
}
