import 'package:classdiary2/controller/timetable_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/attendance_controller.dart';
import '../controller/dashboard_controller.dart';

// ignore_for_file: prefer_const_constructors

class TimeTable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      alignment: Alignment.center,
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 10,),
            /// <- 2022 ->
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         var s_date = DateTime.parse(TimetableController.to.selectedDate.value);
            //         TimetableController.to.selectedDate.value = DateTime(s_date.year-1, s_date.month, s_date.day).toString();
            //       },
            //       child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 15,),
            //     ),
            //     SizedBox(width: 10,),
            //     /// 1월이면 전년도 가져오기
            //     Text('${(DateTime.now().month == 1 || DateTime.now().month == 2) ? (int.parse(TimetableController.to.selectedDate.substring(0,4)) - 1).toString()
            //     : TimetableController.to.selectedDate.substring(0,4)}학년도',
            //     // Text('${TimetableController.to.selectedDate.substring(0,4)}',
            //       style: TextStyle(fontSize: 14, color: Colors.grey),),
            //     SizedBox(width: 10,),
            //     InkWell(
            //       onTap: () {
            //         var s_date = DateTime.parse(TimetableController.to.selectedDate.value);
            //         TimetableController.to.selectedDate.value = DateTime(s_date.year+1, s_date.month, s_date.day).toString();
            //         // TimeTableController.to.setTimeTable();
            //
            //       },
            //       child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 15,),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10,),
            FutureBuilder<QuerySnapshot>(
              /// 1월,2월이면 전학년도 처리
                future: FirebaseFirestore.instance
                    .collection('timetable').where('email', isEqualTo: GetStorage().read('email'))
                    .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
                (int.parse(TimetableController.to.selectedDate.substring(0,4)) - 1).toString() : TimetableController.to.selectedDate.value.substring(0,4) )
                    .orderBy('order', descending: false)
                    // .where('yyyy', isEqualTo: TimetableController.to.selectedDate.value.substring(0,4)).orderBy('order', descending: false)
                    .get(),
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
                  return FocusScope(
                    child: Container(
                      width: 390,
                      height: 180,
                      // height: 210,
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(1),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 1 / 5, //item 의 가로, 세로 의 비율
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          TextEditingController class1_controller = TextEditingController();
                          class1_controller.text = doc['class1'];
                          class1_controller.selection = TextSelection.fromPosition(TextPosition(offset: class1_controller.text.length));
                          TextEditingController class2_controller = TextEditingController();
                          class2_controller.text = doc['class2'];
                          class2_controller.selection = TextSelection.fromPosition(TextPosition(offset: class2_controller.text.length));
                          TextEditingController class3_controller = TextEditingController();
                          class3_controller.text = doc['class3'];
                          class3_controller.selection = TextSelection.fromPosition(TextPosition(offset: class3_controller.text.length));
                          TextEditingController class4_controller = TextEditingController();
                          class4_controller.text = doc['class4'];
                          class4_controller.selection = TextSelection.fromPosition(TextPosition(offset: class4_controller.text.length));
                          TextEditingController class5_controller = TextEditingController();
                          class5_controller.text = doc['class5'];
                          class5_controller.selection = TextSelection.fromPosition(TextPosition(offset: class5_controller.text.length));
                          TextEditingController class6_controller = TextEditingController();
                          class6_controller.text = doc['class6'];
                          class6_controller.selection = TextSelection.fromPosition(TextPosition(offset: class6_controller.text.length));

                          return FocusTraversalGroup(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 33, height: 33,
                                  padding: EdgeInsets.all(6),
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Center(
                                        child: Text(
                                          doc['weekday'],
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50, height:20,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(1, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class1_controller,
                                      // controller: TextEditingController(text: doc['class1'],),
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class1');
                                      },
                                      onSubmitted: (value) {
                                        // FocusScope.of(context).requestFocus(focusMap['2-${index+1}']);
                                        // makeFocusMap(1, index+1)?.dispose();
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 20, width: 50,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(2, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class2_controller,
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class2');
                                      },
                                      onSubmitted: (value) {
                                        // FocusScope.of(context).requestFocus(focusMap['3-${index+1}']);
                                        // makeFocusMap(2, index+1)?.dispose();
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 20, width: 50,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(3, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class3_controller,
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class3');
                                      },
                                      onSubmitted: (value) {
                                        // FocusScope.of(context).requestFocus(focusMap['4-${index+1}']);
                                        // makeFocusMap(3, index+1)?.dispose();
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 20, width: 50,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(4, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class4_controller,
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class4');
                                      },
                                      onSubmitted: (value) {
                                        // FocusScope.of(context).requestFocus(focusMap['5-${index+1}']);
                                        // makeFocusMap(4, index+1)?.dispose();
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 20, width: 50,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(5, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class5_controller,
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class5');
                                      },
                                      onSubmitted: (value) {
                                        // FocusScope.of(context).requestFocus(focusMap['6-${index+1}']);
                                        // makeFocusMap(5, index+1)?.dispose();
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 20, width: 50,
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    child: TextField(
                                      // focusNode: makeFocusMap(6, index+1),
                                      inputFormatters: [LengthLimitingTextInputFormatter(2),],
                                      enabled: doc['order'] == '1' ? false : true,
                                      textAlign: TextAlign.center,
                                      controller: class6_controller,
                                      onChanged: (value) {
                                        TimetableController.to.updTimetable(doc.id, value, 'class6');
                                      },
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration( border: InputBorder.none,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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

