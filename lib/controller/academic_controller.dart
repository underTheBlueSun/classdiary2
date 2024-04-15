// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore_for_file: prefer_const_constructors

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }
  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }
  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }
  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }
  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }
  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.docID);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String docID;
}

class AcademicController extends GetxController {
  static AcademicController get to => Get.find();

  RxString selectedDate = DateTime.now().toString().obs;
  RxString toDate = DateTime.now().toString().obs;
  List dayList = [];
  List<Meeting> meetings = [];
  // RxString endDate = ''.obs;
  RxString selectedColor = 'color1'.obs;
  RxBool isUpdateView = false.obs;  //  수정화면 클릭하면
  String eventName = '';
  String docID = '';
  String input = '';
  RxInt firstWeekChoice = 1.obs;  // 월요일

  @override
  void onInit() async {
    super.onInit();

    if(GetStorage().read('firstWeekChoice') != null) {
      firstWeekChoice.value = GetStorage().read('firstWeekChoice');
    }
  }

  // void getDataSource() async{
  //   await FirebaseFirestore.instance.collection('academic').where('email', isEqualTo: GetStorage().read('email')).get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       if (doc['color'] == 'color1') {
  //         meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF0B556B), false, doc.id));
  //       }else if (doc['color'] == 'color2') {
  //         meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFFA3556B), false, doc.id));
  //       }else if (doc['color'] == 'color3') {
  //         meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF27945D), false, doc.id));
  //       }else if (doc['color'] == 'color4') {
  //         meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF2D1F43), false, doc.id));
  //       }
  //       // meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(doc['color']), false, doc.id));
  //       // meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF0B556B), false, doc.id));
  //       // meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFFA3556B), false, doc.id));
  //       // meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF27945D), false, doc.id));
  //       // meetings.add(Meeting(doc['title'], doc['startTime'], doc['endTime'], Color(0xFF2D1F43), false, doc.id));
  //     });
  //   });
  //
  // }

  void saveAcademic(date, title) async{
    var difference = date.difference(DateTime.parse(toDate.value)).inDays;
    DocumentReference ref = await FirebaseFirestore.instance.collection('academic')
        .add({ 'email': GetStorage().read('email'), 'title': title, 'startTime': date, 'endTime': DateTime.parse(toDate.value), 'color': selectedColor.value})
        .catchError((error) { print(error); });

    // for (int i=1; i < difference; i++) {
    //   meetings.add(Meeting('111', date.add(Duration(days: i)), date.add(Duration(days: i)), Color(0xFF0B556B), false, ref.id));
    // }

  }

  void updAcademic(id, title) async{
    await FirebaseFirestore.instance.collection('academic').doc(id).update({ 'title': title, 'color': selectedColor.value})
        .catchError((error) { print(error); });

    // for (int i=1; i < difference; i++) {
    //   meetings.add(Meeting('111', date.add(Duration(days: i)), date.add(Duration(days: i)), Color(0xFF0B556B), false, ref.id));
    // }

  }

  void delAcademic(id) {
    FirebaseFirestore.instance.collection('academic').doc(id).delete();
  }

  // void getAcademic() async{
  //   var now = DateTime.now();
  //   var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   await FirebaseFirestore.instance.collection('academic').where('email', isEqualTo: GetStorage().read('email')).get()
  //       .then((snapshot) {
  //     meetings = [];
  //     for(var doc in snapshot.docs)
  //       meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate();
  //   });
  //
  // }


}