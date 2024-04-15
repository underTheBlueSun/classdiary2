import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

class AbsentSMonthDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey,),
        title: Text('${Get.arguments[0]['date'].substring(0,7)}월',
          style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          primary: false,
          shrinkWrap: true,
          itemCount: Get.arguments.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(width: 30,),
                Container(
                  // width: 40,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration : BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(7),),
                  child: Center(
                    child: Text('${Get.arguments[index]['date'].toString().substring(0,4)}.${Get.arguments[index]['date'].toString().substring(5,7)}.${Get.arguments[index]['date'].toString().substring(8,10)} '
                        '(${DateFormat.E('ko_KR').format(DateTime.parse(Get.arguments[index]['date']))})',
                      style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7), ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Text(Get.arguments[index]['name'],
                  style: TextStyle( color: Colors.black, fontSize: 17),
                ),
                Expanded(child: SizedBox()),
                Container(
                  // width: 40,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration : BoxDecoration(color:
                  Get.arguments[index]['gubun'] == '결석' ?
                  Colors.orange.withOpacity(0.7) : Colors.teal.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(7),),
                  child: Center(
                    child: Text(Get.arguments[index]['gubun'],
                      style: TextStyle(color: Colors.white, ),
                    ),
                  ),
                ),
                SizedBox(width: 30,),
              ],);
          },
          separatorBuilder: (_, index) {
            return Divider(color: Colors.grey.withOpacity(0.7),);
          },

        ),
      ),
    );
  }
}

