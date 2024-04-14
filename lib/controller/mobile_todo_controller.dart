
import 'package:classdiary2/controller/anim_list_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class MobileToDoController extends GetxController {
  static MobileToDoController get to => Get.find();

  final clickedToDoIndex = Rxn<int>();
  RxString selectedDateTodo = ''.obs;
  String todoContent = '';
  String todoMemo = '';
  RxString isToDoDate = '전체'.obs; //  전체,과거,오늘,미래
  RxInt toDoTatalCnt = 0.obs; //  전체
  RxInt toDoPrevCnt = 0.obs;  //  과거
  RxInt toDoTodayCnt = 0.obs; //  오늘
  RxInt toDoFutureCnt = 0.obs;  //  미래
  RxInt toDoCompleteCnt = 0.obs;  //  완료
  DateTime selectedDateTimeStamp = DateTime.now();
  RxString repeatToggle = 'no'.obs; //  no,day,week,month
  RxBool isRepeatToggle = false.obs;
  RxBool isSelectedDate = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void getSelectedDateTimeStamp() {
    var nowNum = DateTime.now().weekday;  // 월 1, 일 7
    // var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var nowYMD = DateTime.now();
    if (selectedDateTodo == '' || selectedDateTodo == '오' || selectedDateTodo == '오늘') {
      selectedDateTimeStamp = nowYMD;
    }else if (selectedDateTodo == '내' || selectedDateTodo == '내일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: 1));
    }else if (selectedDateTodo == '모' || selectedDateTodo == '모레') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: 2));
    }else if (selectedDateTodo == '월' || selectedDateTodo == '월요' || selectedDateTodo == '월요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (1 - nowNum) % 7,));
    }else if (selectedDateTodo == '화' || selectedDateTodo == '화요' || selectedDateTodo == '화요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (2 - nowNum) % 7,));
    }else if (selectedDateTodo == '수' || selectedDateTodo == '수요' || selectedDateTodo == '수요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (3 - nowNum) % 7,));
    }else if (selectedDateTodo == '목' || selectedDateTodo == '목요' || selectedDateTodo == '목요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (4 - nowNum) % 7,));
    }else if (selectedDateTodo == '금' || selectedDateTodo == '금요' || selectedDateTodo == '금요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (5 - nowNum) % 7,));
    }else if (selectedDateTodo == '토' || selectedDateTodo == '토요' || selectedDateTodo == '토요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (6 - nowNum) % 7,));
    }else if (selectedDateTodo == '일' || selectedDateTodo == '일요' || selectedDateTodo == '일요일') {
      selectedDateTimeStamp = nowYMD.add(Duration(days: (7 - nowNum) % 7,));
    }else if (selectedDateTodo.value.length == 23) {  // 캘린더에서 선택한 날짜이면
      selectedDateTimeStamp = DateTime.parse(selectedDateTodo.value);
    }
  }

  void saveToDo() async{
    getSelectedDateTimeStamp();
    await FirebaseFirestore.instance.collection('todo')
        .add({ 'email': GetStorage().read('email'), 'content': todoContent, 'memo': todoMemo, 'date': selectedDateTimeStamp, 'repeat' : repeatToggle.value })
        .catchError((error) { print('saveToDo() : ${error}'); });

    // print(GetStorage().read('email'));
    // print(todoContent);
    // print(selectedDateTimeStamp);
    // print(repeatToggle.value);
  } // saveToDo()

  void delToDo(id) async {
    FirebaseFirestore.instance.collection('todo').doc(id).delete();

  } // delDoTo(doc)

  void completeToDo(doc) async {
    await FirebaseFirestore.instance.collection('completetodo')
        .add({ 'email': GetStorage().read('email'), 'content': doc['content'], 'memo': doc['memo'], 'date': doc['date'], 'repeat' : doc['repeat'] })
        .catchError((error) { print('completeToDo() : ${error}'); });

    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();

  }

  void restoreToDo(doc) async {
    getSelectedDateTimeStamp();
    await FirebaseFirestore.instance.collection('todo')
        .add({ 'email': GetStorage().read('email'), 'content': doc['content'], 'memo': doc['memo'], 'date': doc['date'].toDate(), 'repeat' : doc['repeat'] })
        .catchError((error) { print('todo() : ${error}'); });

    FirebaseFirestore.instance.collection('completetodo').doc(doc.id).delete();

  }

  void updToDo(doc) async{
    getSelectedDateTimeStamp();
    if (isRepeatToggle.value == false) {
      repeatToggle.value = 'no';
    }
    await FirebaseFirestore.instance.collection('todo').doc(doc.id)
        .update({ 'email': GetStorage().read('email'), 'content': todoContent, 'memo': todoMemo, 'date': selectedDateTimeStamp, 'repeat' : repeatToggle.value });

    Get.back();
  } // updToDo()

  void repeatToDo(doc) async{
    ///  날짜는 yyyymmdd로 끊지 않으면 시간이 빠른 오늘은 과거로 인식함
    var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var selectedDateYMD = DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day);

    if (doc['repeat'] == 'day') {
      if(selectedDateYMD.compareTo(nowYMD) < 0 ) {  //  과거이면 오늘로 날짜 수정

        await FirebaseFirestore.instance.collection('todo').doc(doc.id)
            .update({'date': nowYMD}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }else { //  오늘 또는 미래이면 그 다음날로 날짜 수정
        var nextDay = doc['date'].toDate().add(Duration(days: 1));

        await FirebaseFirestore.instance.collection('todo').doc(doc.id)
            .update({'date': nextDay}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }
    }else if (doc['repeat'] == 'week') {
      var nextWeek = doc['date'].toDate().add(Duration(days: 7));

      await FirebaseFirestore.instance.collection('todo').doc(doc.id)
          .update({'date': nextWeek}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
    }else {
      var nextMonth = DateTime(doc['date'].toDate().year, doc['date'].toDate().month + 1, doc['date'].toDate().day, doc['date'].toDate().hour,
          doc['date'].toDate().minute, doc['date'].toDate().second, doc['date'].toDate().millisecond);

      await FirebaseFirestore.instance.collection('todo').doc(doc.id)
          .update({'date': nextMonth}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
    }
  } // repeatToDo()

  void getToDoCnt() async{
    var now = DateTime.now();
    var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var todoDocs = await FirebaseFirestore.instance.collection('todo').where('email', isEqualTo: GetStorage().read('email')).get()
        .then((QuerySnapshot snapshot) {
      toDoTatalCnt.value = snapshot.docs.length;
      toDoPrevCnt.value = snapshot.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day).compareTo(nowYMD) < 0).length;
      toDoTodayCnt.value = snapshot.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day).compareTo(nowYMD) == 0).length;
      toDoFutureCnt.value = snapshot.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day).compareTo(nowYMD) > 0).length;
    });

    var todoCompleteDocs = await FirebaseFirestore.instance.collection('completetodo').where('email', isEqualTo: GetStorage().read('email')).get()
        .then((QuerySnapshot snapshot) {
      toDoCompleteCnt.value = snapshot.docs.length;
    });

  }

}