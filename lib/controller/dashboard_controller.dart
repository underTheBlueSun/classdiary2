import 'dart:async';

import 'package:classdiary2/controller/anim_list_controller.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

// ignore_for_file: prefer_const_constructors

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  RxBool isHoverAbsent = false.obs;
  RxBool isHoverCheck = false.obs;
  RxBool isHoverEval = false.obs;
  RxBool isHoverThisWeek = false.obs;
  RxBool isHoverAcademic = false.obs;
  RxBool isHoverConsult = false.obs;
  RxBool isHoverNote = false.obs;
  RxBool isHoverShortcut = false.obs;
  RxBool isHoverLogout = false.obs;
  RxBool isHoverBell = false.obs;
  // RxInt clickedToDoIndex = 9999.obs; // 할일 체크 여부
  final clickedToDoIndex = Rxn<int>();
  RxBool isSelectedDate = false.obs;
  RxString clickedMenu = '이번주'.obs;
  RxInt count = 0.obs;
  // RxString selectedDate = ''.obs;
  RxString selectedDateThisweek = ''.obs;
  RxString selectedDateTodo = ''.obs;
  String todoContent = '';
  String todoMemo = '';
  DateTime selectedDateTimeStamp = DateTime.now();
  RxBool isRepeatToggle = false.obs;
  RxString repeatToggle = 'no'.obs; //  no,day,week,month
  RxString isToDoDate = '전체'.obs; //  전체,과거,오늘,미래
  RxInt toDoTatalCnt = 0.obs; //  전체
  RxInt toDoPrevCnt = 0.obs;  //  과거
  RxInt toDoTodayCnt = 0.obs; //  오늘
  RxInt toDoFutureCnt = 0.obs;  //  미래
  RxInt toDoCompleteCnt = 0.obs;  //  완료
  RxBool isThisweekInput = false.obs; //  이번주에서 내용을 입력하면 저장버튼 보이게
  RxBool isSearchFolded = true.obs;
  RxBool isSearchSubmit = false.obs;
  String searchInput = '';
  int anilistInitCnt = 0;
  RxBool isVisibleRight = true.obs;
  /// 시종
  RxBool isPlay = true.obs;
  RxString selectedSong = ''.obs;
  RxString selectedHH = '00'.obs;
  RxString selectedMM = '00'.obs;


  /// 호세피나
  String game_gubun = '보드';
  RxBool isHoverBoard = false.obs;
  RxBool isHoverQuiz = false.obs;
  RxBool isHoverAuction = false.obs;
  RxBool isHoverMemento = false.obs;
  RxBool isHoverMoney = false.obs;
  RxBool isHoverTrade = false.obs;
  RxBool isHoverThermostat = false.obs;
  RxBool isHoverDiary = false.obs;
  RxBool isHoverCoupon = false.obs;
  RxBool isHoverPoint = false.obs;
  RxBool isHoverSubject = false.obs;
  RxBool isHoverExam = false.obs;
  RxBool isSurvey = false.obs;
  RxBool isRelation = false.obs;

  // RxInt selectedItem = 0.obs; //  애니메이션 리스트
  final selectedItem = Rxn<int>();

  List<Color> kDefaultRainbowColors =  [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple,];

  @override
  void onInit() async{
    super.onInit();

    /// 다음날 다시 켜면 시종 리셋......
    // await FirebaseFirestore.instance.collection('bell').where('email', isEqualTo: GetStorage().read('email')).get()
    //     .then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((doc) { doc.reference.update({ 'isPlayed' : false });});
    // });

    /// 시종을 사용하면 타이머 설정하기.
    // await FirebaseFirestore.instance.collection('bell').where('email', isEqualTo: GetStorage().read('email')).get()
    //     .then((QuerySnapshot snapshot) {
    //       if (snapshot.docs.isNotEmpty) { setTimer(); }
    //     });

  }

  // void setTimer() async{
  //   final player = AudioPlayer();
  //   Timer.periodic(Duration(seconds: 10), (timer) async{
  //     // print(DateTime.now().toString().substring(0,16)); /// 2023-03-12 10:01
  //     var hh = DateTime.now().toString().substring(11,13);
  //     var mm = DateTime.now().toString().substring(14,16);
  //     await FirebaseFirestore.instance.collection('bell').where('email', isEqualTo: GetStorage().read('email')).where('hh', isEqualTo: hh).where('mm', isEqualTo: mm).get()
  //         .then((QuerySnapshot snapshot) {
  //
  //           if (snapshot.docs.isNotEmpty && snapshot.docs[0]['isPlayed'] == false) {
  //             if (snapshot.docs[0]['song'] == '종소리1(10초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%8C%E1%85%A9%E1%86%BC%E1%84%89%E1%85%A9%E1%84%85%E1%85%B51(10%E1%84%8E%E1%85%A9).mp3?alt=media&token=ad12f637-ee79-486b-8cd7-911e37542568'); }
  //             else if (snapshot.docs[0]['song'] == '종소리2(7초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%8C%E1%85%A9%E1%86%BC%E1%84%89%E1%85%A9%E1%84%85%E1%85%B52(7%E1%84%8E%E1%85%A9).mp3?alt=media&token=c46a30cb-53ab-485e-b8a4-f698514864ba'); }
  //             else if (snapshot.docs[0]['song'] == '종소리3(17초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%8C%E1%85%A9%E1%86%BC%E1%84%89%E1%85%A9%E1%84%85%E1%85%B53(17%E1%84%8E%E1%85%A9).mp3?alt=media&token=07f524ad-d59c-4361-9e0d-058583665a01'); }
  //             else if (snapshot.docs[0]['song'] == '시작송1(38초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%89%E1%85%B5%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A9%E1%86%BC1(38%E1%84%8E%E1%85%A9).mp3?alt=media&token=45c3f584-56ad-45da-8e65-ee104edacd05'); }
  //             else if (snapshot.docs[0]['song'] == '시작송2(44초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%89%E1%85%B5%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A9%E1%86%BC2(44%E1%84%8E%E1%85%A9).mp3?alt=media&token=ac448d0b-38c2-4fa3-8dc9-1a8d0fcf54d9'); }
  //             else if (snapshot.docs[0]['song'] == '급식송1(40초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%80%E1%85%B3%E1%86%B8%E1%84%89%E1%85%B5%E1%86%A8%E1%84%89%E1%85%A9%E1%86%BC1(40%E1%84%8E%E1%85%A9).mp3?alt=media&token=fdad4712-1c7d-42dc-ae25-fe0179b5c217'); }
  //             else if (snapshot.docs[0]['song'] == '급식송2(63초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%80%E1%85%B3%E1%86%B8%E1%84%89%E1%85%B5%E1%86%A8%E1%84%89%E1%85%A9%E1%86%BC2(63%E1%84%8E%E1%85%A9).mp3?alt=media&token=715f46f9-5fe3-4d52-9e87-a55e869f0de0'); }
  //             else if (snapshot.docs[0]['song'] == '급식송3(126초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%80%E1%85%B3%E1%86%B8%E1%84%89%E1%85%B5%E1%86%A8%E1%84%89%E1%85%A9%E1%86%BC3(126%E1%84%8E%E1%85%A9).mp3?alt=media&token=4bd6e79f-8279-4397-96d9-7cb472d903cd'); }
  //             else if (snapshot.docs[0]['song'] == '청소송1(82초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%8E%E1%85%A5%E1%86%BC%E1%84%89%E1%85%A9%E1%84%89%E1%85%A9%E1%86%BC1(82%E1%84%8E%E1%85%A9).mp3?alt=media&token=717f3ca0-9fdc-4d45-a0e7-cfcfcbaeb6cc'); }
  //             else if (snapshot.docs[0]['song'] == '청소송2(60초)') { player.setUrl('https://firebasestorage.googleapis.com/v0/b/classdiary2.appspot.com/o/%E1%84%8E%E1%85%A5%E1%86%BC%E1%84%89%E1%85%A9%E1%84%89%E1%85%A9%E1%86%BC2(60%E1%84%8E%E1%85%A9).mp3?alt=media&token=295370d3-b8a6-4929-93b5-02c6e80dbcd1'); }
  //
  //             player.play();
  //
  //             FirebaseFirestore.instance.collection('bell').doc(snapshot.docs[0].id).update({ 'isPlayed' : true });
  //           }
  //         });
  //
  //   });
  // }

  void setPlus() {
    count.value = count.value + 1;
  }

  void setClickedMenu(menu) {
    clickedMenu.value = menu;
    ChecklistController.to.whereToGo.value = 'Checklist';
    EstiController.to.whereToGo.value = 'Estimate';
    ConsultController.to.whereToGo.value = 'Consult';
    NoteController.to.whereToGo.value = 'Note';
    ChecklistController.to.chartSelections.value = [];
    EstiController.to.chartSelections1.value = [];
    EstiController.to.chartSelections2.value = [];
    DashboardController.to.isSearchSubmit.value = false;
    DashboardController.to.isSearchFolded.value = true;
    AttendanceController.to.selectedDate.value = DateTime.now().toString();
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
    }else if (selectedDateTodo.value.length == 23) {
      selectedDateTimeStamp = DateTime.parse(selectedDateTodo.value);

    }
  }

  void saveToDo() async{
    getSelectedDateTimeStamp();
    await FirebaseFirestore.instance.collection('todo')
        .add({ 'email': GetStorage().read('email'), 'content': todoContent, 'memo': todoMemo, 'date': selectedDateTimeStamp, 'repeat' : repeatToggle.value })
       //  .then((value) {
       //    AnimListController.to.addItem({'id' : value.id, 'date' : Timestamp.fromDate(selectedDateTimeStamp), 'content' : todoContent, 'memo': todoMemo,
       //      'repeat' : repeatToggle.value});
       // })
        .catchError((error) { print('saveToDo() : ${error}'); });
    // todoMemo = '';
  } // saveToDo()

  void delToDo(id) async {
    FirebaseFirestore.instance.collection('completetodo').doc(id).delete();

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

  void updToDo(item) async{
    getSelectedDateTimeStamp();
    if (isRepeatToggle.value == false) {
      repeatToggle.value = 'no';
    }

    // AnimListController.to.removeItem(index);
    /// 애니 리스트에 추가
    // AnimListController.to.addItem({'id' : item['id'], 'date' : Timestamp.fromDate(selectedDateTimeStamp), 'content' : todoContent,
    //   'memo': todoMemo, 'repeat' : repeatToggle.value});

    await FirebaseFirestore.instance.collection('todo').doc(item.id)
        .update({ 'email': GetStorage().read('email'), 'content': todoContent, 'memo': todoMemo, 'date': selectedDateTimeStamp, 'repeat' : repeatToggle.value });
    todoMemo = '';
  } // updToDo()

  void repeatToDo(item) async{
    ///  날짜는 yyyymmdd로 끊지 않으면 시간이 빠른 오늘은 과거로 인식함
    var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var selectedDateYMD = DateTime(item['date'].toDate().year, item['date'].toDate().month, item['date'].toDate().day);

    if (item['repeat'] == 'day') {
      if(selectedDateYMD.compareTo(nowYMD) < 0 ) {  //  과거이면 오늘로 날짜 수정

        await FirebaseFirestore.instance.collection('todo').doc(item.id)
            .update({'date': nowYMD}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        // Future.delayed(const Duration(milliseconds: 400), () {
        //   clickedToDoIndex.value = null;  //  밖으로 빼면 체크할때 체크아이콘, 글자중간에 빗금 효과 안됨, 아마도 시간차이인것 같음.
        //   /// 애니 리스트에서 삭제
        //   AnimListController.to.removeItem(index);
        //   /// 애니 리스트에 추가
        //   AnimListController.to.addItem({'id' : item['id'], 'date' : Timestamp.fromDate(nowYMD), 'content' : item['content'], 'memo': item['memo'], 'repeat' : item['repeat']});
        // });

      }else { //  오늘 또는 미래이면 그 다음날로 날짜 수정
        var nextDay = item['date'].toDate().add(Duration(days: 1));

        await FirebaseFirestore.instance.collection('todo').doc(item.id)
            .update({'date': nextDay}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        // Future.delayed(const Duration(milliseconds: 400), () {
        //   clickedToDoIndex.value = null;
        //   /// 애니 리스트에서 삭제
        //   AnimListController.to.removeItem(index);
        //   /// 애니 리스트에 추가
        //   AnimListController.to.addItem({'id' : item['id'], 'date' : Timestamp.fromDate(nextDay), 'content' : item['content'], 'memo': item['memo'], 'repeat' : item['repeat']});
        // });
      }
    }else if (item['repeat'] == 'week') {
      var nextWeek = item['date'].toDate().add(Duration(days: 7));

      await FirebaseFirestore.instance.collection('todo').doc(item.id)
          .update({'date': nextWeek}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      // Future.delayed(const Duration(milliseconds: 400), () {
      //   clickedToDoIndex.value = null;  //  밖으로 빼면 체크할때 체크아이콘, 글자중간에 빗금 효과 안됨, 아마도 시간차이인것 같음.
      //   /// 애니 리스트에서 삭제
      //   AnimListController.to.removeItem(index);
      //   /// 애니 리스트에 추가
      //   AnimListController.to.addItem({'id' : item['id'], 'date' : Timestamp.fromDate(nextWeek), 'content' : item['content'], 'memo': item['memo'], 'repeat' : item['repeat']});
      // });
    }else {
      var nextMonth = DateTime(item['date'].toDate().year, item['date'].toDate().month + 1, item['date'].toDate().day, item['date'].toDate().hour,
          item['date'].toDate().minute, item['date'].toDate().second, item['date'].toDate().millisecond);

      await FirebaseFirestore.instance.collection('todo').doc(item.id)
          .update({'date': nextMonth}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      // Future.delayed(const Duration(milliseconds: 400), () {
      //   clickedToDoIndex.value = null;  //  밖으로 빼면 체크할때 체크아이콘, 글자중간에 빗금 효과 안됨, 아마도 시간차이인것 같음.
      //   /// 애니 리스트에서 삭제
      //   AnimListController.to.removeItem(index);
      //   /// 애니 리스트에 추가
      //   AnimListController.to.addItem({'id' : item['id'], 'date' : Timestamp.fromDate(nextMonth), 'content' : item['content'], 'memo': item['memo'], 'repeat' : item['repeat']});
      // });
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

  void saveBell() async{
    var bellDocs = await FirebaseFirestore.instance.collection('bell').where('email', isEqualTo: GetStorage().read('email'))
        .where('hh', isEqualTo: selectedHH.value).where('mm', isEqualTo: selectedMM.value).get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.length == 0){
             FirebaseFirestore.instance.collection('bell')
                .add({ 'email': GetStorage().read('email'), 'date': DateTime.now(), 'hh': selectedHH.value, 'mm': selectedMM.value, 'song': selectedSong.value, 'isPlayed': false })
                .catchError((error) { print('saveBell() : ${error}'); });
          }
    });

    // setTimer();

  } // saveBell()

  void delBell(doc) async{
    await FirebaseFirestore.instance.collection('bell').doc(doc.id).delete();

  } // updBell()

}