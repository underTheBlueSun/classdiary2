
// import 'dart:html';

import 'package:classdiary2/mobile/checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class ChecklistController extends GetxController {
  static ChecklistController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  RxString selectedDate = DateTime.now().toString().obs;
  RxString title = ''.obs;
  RxInt checkCnt = 0.obs;
  RxString whereToGo = 'Checklist'.obs;  //  디테일화면을 팝업에 띄우지 않고 바로 띄우기 위해
  String id = ''; //  디테일화면으로 넘길때 필요
  String folderid = '';
  RxString folderTitle = ''.obs;
  String whoCall = '';  //  디테일화면에서 이전 클릭하면 checklist로 갈건지 checklistfoler로 갈건지
  RxList<String> chartSelections = <String>[].obs;
  RxBool isChart = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void saveFolerFile(gubun) async{
    var nowYMD = DateTime.now().toString().substring(0,10);
    if (gubun == '폴더파일') {
      await FirebaseFirestore.instance.collection('checklist')
          .add({ 'email': GetStorage().read('email'), 'title': title.value, 'folderID': folderid, 'folderTitle': folderTitle.value, 'numArray': [], 'gubun' : gubun, 'date': nowYMD })
          .catchError((error) { print(error); });
    }else {
      await FirebaseFirestore.instance.collection('checklist')
          .add({ 'email': GetStorage().read('email'), 'title': title.value, 'folderID': '', 'folderTitle': '', 'numArray': [], 'gubun' : gubun, 'date': nowYMD })
          .catchError((error) { print(error); });

    }


  }

  void updNumArray(number, isExit) async{
    if (isExit == true) { //  존재하면 삭제
      await FirebaseFirestore.instance.collection('checklist').doc(id)
          .update({ 'numArray': FieldValue.arrayRemove([number]) }).catchError((error) { print(error); });
    }else {
      await FirebaseFirestore.instance.collection('checklist').doc(id)
          .update({ 'numArray': FieldValue.arrayUnion([number]) }).catchError((error) { print(error); });
    }
  }

  void updDate() async{
    await FirebaseFirestore.instance.collection('checklist').doc(id)
        .update({ 'date': selectedDate.substring(0,10) }).catchError((error) { print(error); });
  }

  void getCheckCnt(id) async{
    await FirebaseFirestore.instance.collection('checklist').doc(id).get()
        .then((DocumentSnapshot<Map<String,dynamic>> snapshot) {
      checkCnt.value = snapshot.data()?['numArray'].length;
    });
  }

  void delChecklist(gubun) async {
    /// 모바일, 웹 분기
    if (GetStorage().read('isMobile')) {
      Get.to(() => Checklist());
    }else {
      ChecklistController.to.whereToGo.value = 'Checklist'; //  이걸 삭제 뒤에 적으면 삭제하면서 실행되어 삭제는 되지만 화면에서 에러 뿌려줌
    }

    if (gubun == '폴더') {
      await FirebaseFirestore.instance.collection('checklist').where('folderID', isEqualTo: folderid).get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      await FirebaseFirestore.instance.collection('checklist').doc(id).delete();
    }else {
      await FirebaseFirestore.instance.collection('checklist').doc(id).delete();
    }
  }

  void updFolderTitle() async{
    await FirebaseFirestore.instance.collection('checklist').doc(folderid)
        .update({ 'title': folderTitle.value, 'folderTitle': folderTitle.value }).catchError((error) { print(error); });

    await FirebaseFirestore.instance.collection('checklist').where('folderID', isEqualTo: folderid).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('checklist').doc(doc.id).update({ 'folderTitle': folderTitle.value });
      });
    });

  }

  void updTitle() async{
    await FirebaseFirestore.instance.collection('checklist').doc(id)
        .update({ 'title': title.value }).catchError((error) { print(error); });
  }

  // var checklistDocs;
  // Stream<QuerySnapshot> getChecklist() {
  //   checklistDocs = FirebaseFirestore.instance
  //       .collection('checklist').where('email', isEqualTo: GetStorage().read('email')).where('gubun', isNotEqualTo: '폴더').snapshots();
  //   return checklistDocs;
  // }

  var smonthDocs;
  // var smonthFileCnt;
  Map setStasticsMonthCheck() {
    Map sumMap = {};

    if (chartSelections.length == 0) {
      smonthDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,7))) {
          sumMap[doc['date'].substring(0,7)] += doc['numArray'].length;
        } else {
          sumMap[doc['date'].substring(0,7)] = doc['numArray'].length;
        }
      });

    } else {
      smonthDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,7))) {
          sumMap[doc['date'].substring(0,7)] += doc['numArray'].length;
        } else {
          sumMap[doc['date'].substring(0,7)] = doc['numArray'].length;
        }

      });
    }
    return sumMap;
  }

  Map setStasticsDayCheck() {
    Map sumMap = {};
    if (chartSelections.length == 0) {
      smonthDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,10))) {
          sumMap[doc['date'].substring(0,10)] += doc['numArray'].length;
        } else {
          sumMap[doc['date'].substring(0,10)] = doc['numArray'].length;
        }
      });
    } else {
      smonthDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,10))) {
          sumMap[doc['date'].substring(0,10)] += doc['numArray'].length;
        } else {
          sumMap[doc['date'].substring(0,10)] = doc['numArray'].length;
        }
      });
    }
    return sumMap;
  }

  var sweekDocs;
  var weekdayOffirstDay;
  var weekCnt;
  Map setStasticsDayCheck2(weekOfMonth, weekdayOffirstDay) {
    Map sumMap = {};

    if (chartSelections.length == 0) {
      // var day_items = sweekDocs.where((e) => e.date.substring(0,7) == selected_date.substring(0,7)
      //     && ((DateTime.parse(e.date).day + weekdayOffirstDay - 1) / 7).ceil() == weekOfMonth && e.type == '' ).toList();
      sweekDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,10))) {
          sumMap[doc['date'].substring(0,10)] += 1;
        } else {
          sumMap[doc['date'].substring(0,10)] = 1;
        }

      });

    } else {
      // var day_items = Hive.box('single_check').values.where((e) => e.date.substring(0,7) == selected_date.substring(0,7)
      //     && SingleCheckController.to.checkbox_selections.contains(e.title) && ((DateTime.parse(e.date).day + weekdayOffirstDay - 1) / 7).ceil() == weekOfMonth && e.type == '' ).toList();
      sweekDocs.forEach((doc) {
        if (sumMap.containsKey(doc['date'].substring(0,10))) {
          sumMap[doc['date'].substring(0,10)] += 1;
        } else {
          sumMap[doc['date'].substring(0,10)] = 1;
        }

      });
    }

    return sumMap;
  }

  int retWeekOfMonth() {
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int weekdayOffirstDay = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 1).weekday;
    int weekOfMonth = ((DateTime.now().day + weekdayOffirstDay - 1) / 7).ceil();
    return weekOfMonth;
  }

} // MainController