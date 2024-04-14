import 'package:classdiary2/controller/timetable_controller.dart';
import 'package:classdiary2/web/attendance_reg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/attendance_controller.dart';
import '../controller/dashboard_controller.dart';

// ignore_for_file: prefer_const_constructors

class Attendance extends StatelessWidget {

  void attendanceDialog(BuildContext context, doc) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 500, width: 400,
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
                      child: Icon(Icons.close_outlined,),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                Text(doc['name']),
                Divider(),
                SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    controller: TextEditingController(text: doc['memo']),
                    onChanged: (value) {
                      AttendanceController.to.attendanceMemo = value;
                    },
                    minLines: 25, /// 배포시 만약 6으로 하면 6번째 라인에서 한글이 깨짐
                    maxLines: 25,
                    style: TextStyle( fontSize: 15.0,),
                    decoration: InputDecoration(
                      hintText: "내용을 입력하세요. \n(예) 가정환경조사, 행동 관찰기록 등",
                      hintStyle: TextStyle(fontSize: 13.0,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      AttendanceController.to.updAttendanceMemo(doc.id);
                      Navigator.pop(context);
                      // if (AttendanceController.to.attendanceMemo.length > 0) {
                      //   AttendanceController.to.updAttendanceMemo(doc.id);
                      //   Navigator.pop(context);
                      // }
                    }, // onPressed
                    child: Text('저장', ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          // SizedBox(height: 10,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         var s_date = DateTime.parse(AttendanceController.to.selectedDate.value);
          //         AttendanceController.to.selectedDate.value = DateTime(s_date.year-1, s_date.month, s_date.day).toString();
          //       },
          //       child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 20,),
          //     ),
          //     SizedBox(width: 10,),
          //     /// 1월,2월은 전학년도 처리
          //     Text('${(AttendanceController.to.selectedDate.substring(5,7) == '01' || AttendanceController.to.selectedDate.substring(5,7) == '02') ?
          //     (int.parse(AttendanceController.to.selectedDate.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.substring(0,4)}학년도',
          //       style: TextStyle(fontSize: 14, color: Colors.grey),),
          //     SizedBox(width: 10,),
          //     InkWell(
          //       onTap: () {
          //         var s_date = DateTime.parse(AttendanceController.to.selectedDate.value);
          //         AttendanceController.to.selectedDate.value = DateTime(s_date.year+1, s_date.month, s_date.day).toString();
          //       },
          //       child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 20,),
          //     ),
          //   ],
          // ),
          StreamBuilder<QuerySnapshot>(
            // AttendanceController.to.selectedDate.value.substring(0,4)
              /// 1월, 2월은 전학년도로 처리
              stream: FirebaseFirestore.instance
                  .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
                  .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
              (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                  // .where('yyyy', isEqualTo: AttendanceController.to.selectedDate.value.substring(0,4))
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
                  height: 200,
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
                            bottom: (index + 1 == snapshot.data!.docs.length - 1 && (index + 1).isOdd)  || index + 1 == snapshot.data!.docs.length
                                ? BorderSide(width: 1, color: Colors.transparent,)
                                : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                            right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            attendanceDialog(context,doc);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  SizedBox(width: 10,),
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
                                    // width: 100,
                                    child: Text(doc['name'], ),
                                  ),
                                ],
                              ),

                            SizedBox(
                                width: 50,
                                child: Icon(Icons.assignment_outlined, color: Colors.grey.withOpacity(0.5), size: 17.0,)),
                            ],
                          ),
                        ),
                      );
                    },

                  ),
                );
              }),
        ],
      ),
    );
  }

}



