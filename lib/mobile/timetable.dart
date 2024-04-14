import 'package:classdiary2/controller/timetable_controller.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:classdiary2/mobile/floatingbutton_widget.dart';
import 'package:classdiary2/mobile/popupmenu_widget.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
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

  void todoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return ToDoWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        title: Text('시간표', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          PopUpMenuWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// <- 2022 ->
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(width: 30),
            //     InkWell(
            //       onTap: () {
            //         var s_date = DateTime.parse(TimetableController.to.selectedDate.value);
            //         TimetableController.to.selectedDate.value = DateTime(s_date.year-1, s_date.month, s_date.day).toString();
            //       },
            //       child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 25,),
            //     ),
            //     SizedBox(width: 10,),
            //     Text('${TimetableController.to.selectedDate.substring(0,4)}',
            //       style: TextStyle(fontSize: 17, color: Colors.grey,),),
            //     SizedBox(width: 10,),
            //     InkWell(
            //       onTap: () {
            //         var s_date = DateTime.parse(TimetableController.to.selectedDate.value);
            //         TimetableController.to.selectedDate.value = DateTime(s_date.year+1, s_date.month, s_date.day).toString();
            //       },
            //       child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 25,),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10,),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('timetable').where('email', isEqualTo: GetStorage().read('email'))
                    .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
                (int.parse(TimetableController.to.selectedDate.substring(0,4)) - 1).toString() : TimetableController.to.selectedDate.value.substring(0,4) )
                    .orderBy('order', descending: false)
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
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, //1 개의 행에 보여줄 item 개수
                      childAspectRatio: 1 / 9, //item 의 가로, 세로 의 비율
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

                      return Column(
                        children: [
                          Container(
                            width: 35, height: 35,
                            padding: EdgeInsets.all(6),
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Center(
                                  child: Text(
                                    doc['weekday'],
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width: 50, height:25,
                            child: TextField(
                              inputFormatters: [LengthLimitingTextInputFormatter(2),],
                              enabled: doc['order'] == '1' ? false : true,
                              textAlign: TextAlign.center,
                              controller: class1_controller,
                              onChanged: (value) {
                                TimetableController.to.updTimetable(doc.id, value, 'class1');
                              },
                              onSubmitted: (value) {
                                // FocusScope.of(context).requestFocus(focusMap['2-${index+1}']);
                                // makeFocusMap(1, index+1)?.dispose();
                              },
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 25, width: 50,
                            child: TextField(
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
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 25, width: 50,
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
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 25, width: 50,
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
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 25, width: 50,
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
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: 25, width: 50,
                            child: TextField(
                              // focusNode: makeFocusMap(6, index+1),
                              inputFormatters: [LengthLimitingTextInputFormatter(2),],
                              enabled: doc['order'] == '1' ? false : true,
                              textAlign: TextAlign.center,
                              controller: class6_controller,
                              onChanged: (value) {
                                TimetableController.to.updTimetable(doc.id, value, 'class6');
                              },
                              style: TextStyle(fontSize: 17),
                              decoration: InputDecoration( border: InputBorder.none,),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNaviBarWidget(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30,),
            FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                todoDialog(context);
              },
              child: const Text('할일'),
            ),
          ],
        )
    );
  }

}

