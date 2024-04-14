// import 'dart:ffi';
import 'dart:typed_data';

import 'package:classdiary2/board_main.dart';
import 'package:classdiary2/controller/board_controller.dart';
import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/controller/subject_controller.dart';
import 'package:classdiary2/quiz/quiz_main_anonymous.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../auction/auction_main.dart';
import '../board_indi.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
// import 'dart:html' as html;
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../class_entrance.dart';
import '../quiz/quiz_main_real.dart';
import 'attendance_controller.dart';

class ClassController extends GetxController {
  static ClassController get to => Get.find();

  RxBool isClassCode = false.obs;
  String classInput = '';
  RxString noExitMessage = ''.obs;
  List attendanceList = [];
  RxString selectedName = ''.obs;
  String selectedDoc = '';
  String schoolYear = '';
  // RxBool isHoverExit = false.obs;  // 퇴장

  @override
  void onInit() async {
    // 학년도 가져오기
    schoolYear = DateTime.now().toString().substring(0,4);
    if (DateTime.now().month == 1 || DateTime.now().month == 2) {
      schoolYear = (DateTime.now().year-1).toString();
    }

  }

  String genClassCode() {
    // 반 코드 생성
    var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return  String.fromCharCodes(Iterable.generate(5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  /// 선생님이 로그인하거나 새로 회원가입하면
  void setClassCode() async{
    await FirebaseFirestore.instance.collection('class_info').where('email', isEqualTo: GetStorage().read('email'))
        .where('school_year', isEqualTo: schoolYear).get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        GetStorage().write('class_code', genClassCode());
        FirebaseFirestore.instance.collection('class_info').add({ 'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'),
          'date': DateTime.now(), 'school_year' : schoolYear, 'visit' : [],
          'purchase' : 'no', 'purchase_date' : '', 'board_cnt' : 0, 'game_cnt' : 0, 'gubun' : '', 'temp1' : '', 'temp2' : '', 'subject_comment' : true });
      }else {
        GetStorage().write('class_code', snapshot.docs.first['class_code']);
        /// 댓글허용 여부
        // SubjectController.to.is_subject_comment.value = snapshot.docs.first['subject_comment'];
        /// 유무료 체크
        checkFreePay();
      }

    });

    // if (GetStorage().read('class_code') != null) {
    //   // 반코드가 있더라도 학년도가 바뀌면 새로 반코드를 생성해야 한다
    //   await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).get()
    //       .then((QuerySnapshot snapshot) {
    //     if (snapshot.docs.isEmpty) {
    //       GetStorage().write('class_code', genClassCode());
    //       FirebaseFirestore.instance.collection('class_info').add({ 'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'),
    //         'date': DateTime.now(), 'school_year' : schoolYear, 'attendance' : AttendanceController.to.attendanceList, 'visit' : []});
    //     }else {
    //       GetStorage().write('class_code', snapshot.docs.first['class_code']);
    //     }
    //
    //   });
    // }else {
    //   GetStorage().write('class_code', genClassCode());
    //   await FirebaseFirestore.instance.collection('class_info').add({ 'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'),
    //     'date': DateTime.now(), 'school_year' : schoolYear, 'attendance' : AttendanceController.to.attendanceList, 'visit' : []});
    // }

  }

  /// 유무료 체크
  String payment_pay_gubun = '무료';
  int payment_free_period = 30;
  String purchase = 'no';
  String free_end_date = '';
  void checkFreePay() async{
    String date = DateTime.now().toString().substring(0,10);
    await FirebaseFirestore.instance.collection('payment').get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        payment_pay_gubun = snapshot.docs.first['pay_gubun'];
        payment_free_period = snapshot.docs.first['free_period'];
        free_end_date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + payment_free_period).toString().substring(0,10);
      }
    });
    await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read(('class_code'))).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        if (payment_pay_gubun == '유료') {
          if (snapshot.docs.first['temp2'] == '9999-12-30') {
            await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date, 'temp2': free_end_date});
          }else {
            await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date});
          }
        }else if (payment_pay_gubun == '무료') {
          await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date, 'temp2': '9999-12-30'});
        }
        purchase = snapshot.docs.first['purchase'];
        free_end_date = snapshot.docs.first['temp2'];
      }

    });
  }

  void addVisit(id,attendance, classCode) async{
    await FirebaseFirestore.instance.collection('class_info').doc(id)
        .update({ 'visit': FieldValue.arrayUnion([{'number': attendance['number'], 'name': attendance['name']}]) })
        .catchError((error) { print('addVisit() : ${error}'); });

    GetStorage().write('class_code', classCode);
    GetStorage().write('number', attendance['number']);
    GetStorage().write('name', attendance['name']);
    GetStorage().write('job', 'student');
    GetStorage().write('class_info_id', id);  // 삭제시 활용
    if (BoardController.to.param_gubun == 'board') {
      Get.to(() => BoardMain());
    }else if (BoardController.to.param_gubun == 'auction') {
      Get.to(() => AuctionMain());
    }else if (BoardController.to.param_gubun == 'quiz') {
      if(QuizController.to.is_real_name == true) {
        Get.to(() => QuizMainReal());
      }else{
        Get.to(() => QuizMainAnonymous());
      }

    }


  }

  void exitClass() async{
    await FirebaseFirestore.instance.collection('class_info').doc(GetStorage().read('class_info_id'))
        .update({ 'visit': FieldValue.arrayRemove([{'number': GetStorage().read('number'), 'name': GetStorage().read('name')}]) })
        .catchError((error) { print('exitClass() : ${error}'); });
    var class_code = GetStorage().read('class_code');
    /// Get.to(() => ClassEntrance(GetStorage().read('class_code')) ); 이렇게 하면 null 반환함
    Get.offAll(() => ClassEntrance(class_code) );
    // GetStorage().remove('class_code');
    // GetStorage().remove('number');
    // GetStorage().remove('name');
    // GetStorage().remove('job');
    // GetStorage().remove('class_info_id');

  }

  void exitClassByTeacher(number, name, id) async{
    await FirebaseFirestore.instance.collection('class_info').doc(id)
        .update({ 'visit': FieldValue.arrayRemove([{'number': number, 'name': name}]) })
        .catchError((error) { print('exitClassByTeacher() : ${error}'); });
  }

  /// 학생이 반코드를 입력하면
  // void retClassCode() async{
  //   noExitMessage.value = '';
  //   attendanceList = [];
  //   selectedDoc = '';
  //   await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: classInput).get()
  //       .then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.isEmpty) {
  //       noExitMessage.value = '반이 존재하지 않습니다';
  //     }else {
  //       attendanceList = snapshot.docs.first['attendance'];
  //       selectedDoc = snapshot.docs.first.id;
  //       isClassCode.value = true;
  //     }
  //   });
  //
  // }

  /// 학생이 자기 이름을 선택하면
  // void entrance() async{
  //   await FirebaseFirestore.instance.collection('class_info').doc(selectedDoc)
  //       .update({ 'visit': FieldValue.arrayUnion([selectedName.value]) });
  //
  // }

  // Future<void> getClassInfo(paramClassCode) async{
  //   attendanceList = [];
  //   await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: paramClassCode).get()
  //       .then((QuerySnapshot snapshot) {
  //     attendanceList = snapshot.docs.first['attendance'];
  //   });
  //
  // }


}






