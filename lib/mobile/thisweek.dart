import 'dart:io';
import 'dart:typed_data';

import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:classdiary2/mobile/popupmenu_widget.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:classdiary2/web/checklist_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

// import 'image_controller.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/dashboard_controller.dart';


class ThisWeek extends StatelessWidget {

  void absentDialog(context, docs) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content:
          SingleChildScrollView(
            child: SizedBox(
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
                        child: Icon(Icons.close_outlined, color: Colors.grey,),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),
                  for(var doc in docs)
                    Row(
                      children: [
                        Text('•', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                        SizedBox(width: 10,),
                        Text(doc['gubun']),
                        SizedBox(width: 20,),
                        Text(doc['name']),
                      ],
                    ),

                ],
              ),
            ),
          ),

        );
      },
    );
  }

  void checklistDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 350, height: 400,
            child: ChecklistDetail(),
          ),
        );
      },
    );
  }

  void subjectDialog(BuildContext context, index, subject, id) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 120, height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(height: 5,),
                Text(subject),
                SizedBox(height: 10,),
                Container(
                  width: 180,
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (value) {
                      if (index == 0) { ThisWeekController.to.class0 = value; }
                      else if (index == 1) { ThisWeekController.to.class1 = value; }
                      else if (index == 2) { ThisWeekController.to.class2 = value; }
                      else if (index == 3) { ThisWeekController.to.class3 = value; }
                      else if (index == 4) { ThisWeekController.to.class4 = value; }
                      else if (index == 5) { ThisWeekController.to.class5 = value; }
                      else if (index == 6) { ThisWeekController.to.class6 = value; }
                      else if (index == 7) { ThisWeekController.to.class7 = value; }
                      ThisWeekController.to.setThisweek(id);
                      ThisWeekController.to.isChangedSubject.value = !ThisWeekController.to.isChangedSubject.value;
                      Navigator.pop(context);
                    },
                    decoration: InputDecoration(
                      hintText: '과목명 수정',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey, ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text('저장은 엔터키', style: TextStyle(fontSize: 10),),
              ],
            ),
          ),

        );
      },
    );
  }

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
    // ThisWeekController.to.selectedDate.value = DateTime.now().toString();
    // ThisWeekController.to.getThisWeeks();
    // ThisWeekController.to.getTimeTable();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false, /// back button 제거
          elevation: 0,
          title: Text('이번주', style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            PopUpMenuWidget(),
          ],
        ),
        body: SingleChildScrollView(
          child: Obx(() => GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ThisWeekController.to.isChangedSubject.value.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
                SizedBox(height: 10,),
                /// 월화수목금토일
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        var s_date = DateTime.parse(ThisWeekController.to.selectedDate.value);
                        ThisWeekController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day-7).toString();
                        ThisWeekController.to.getThisWeeks();
                      },
                      child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 25,),
                    ),
                    for ( var weekday in ThisWeekController.to.thisweekMap.keys )
                      InkWell(
                        onTap: () {
                          ThisWeekController.to.selectedDate.value = ThisWeekController.to.thisweekMap[weekday].toString().substring(0,10);
                          ThisWeekController.to.getThisWeeks();
                          ThisWeekController.to.getTimeTable();

                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          curve: Curves.easeIn,
                          width:
                          DateFormat.E('ko_KR').format(DateTime.parse(ThisWeekController.to.selectedDate.value)) == weekday ? 45 : 35,
                          child: CircleAvatar(
                            backgroundColor:
                            DateFormat.E('ko_KR').format(DateTime.parse(ThisWeekController.to.selectedDate.value)) == weekday ? Colors.orange.withOpacity(0.7) : Colors.black.withOpacity(0.4),
                            child:
                            DateFormat.E('ko_KR').format(DateTime.parse(ThisWeekController.to.selectedDate.value)) == weekday ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ThisWeekController.to.thisweekMap[weekday].month.toString() + '.'+ThisWeekController.to.thisweekMap[weekday].day.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 13),),
                                Text(weekday, style: TextStyle(color: Colors.white, fontSize: 11, ),),
                              ],
                            ) :
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ThisWeekController.to.thisweekMap[weekday].day.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 11, ),),
                                Text(weekday, style: TextStyle(color: Colors.white, fontSize: 9, ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        var s_date = DateTime.parse(ThisWeekController.to.selectedDate.value);
                        ThisWeekController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day+7).toString();
                        ThisWeekController.to.getThisWeeks();
                      },
                      child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 25,),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.withOpacity(0.7),),

                /// 출결
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('absent').where('email', isEqualTo: GetStorage().read('email'))
                        .where('date', isEqualTo: ThisWeekController.to.selectedDate.value.substring(0,10)).snapshots(),
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
                      var absentCnt = snapshot.data!.docs.where((doc) => doc['gubun'] == '결석').length;
                      var agreeCnt = snapshot.data!.docs.where((doc) => doc['gubun'] == '인정').length;
                      return InkWell(
                        onTap: () {
                          if (absentCnt > 0 || agreeCnt > 0) {
                            absentDialog(context, snapshot.data!.docs);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 27,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              padding: EdgeInsets.all(3),
                              decoration : BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),),
                              child: Center(
                                child: Text('결석 ' + absentCnt.toString(), style: const TextStyle(color: Colors.black, fontSize: 12),),
                              ),
                            ),
                            Container(
                              height: 27,
                              padding: EdgeInsets.all(3),
                              decoration : BoxDecoration(color: Colors.teal.withOpacity(0.7),borderRadius: BorderRadius.circular(7),),
                              child: Center(
                                child: Text('출석인정 ' + agreeCnt.toString(), style: TextStyle(color: Colors.black, fontSize: 12),),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
                Divider(color: Colors.grey.withOpacity(0.7),),

                /// 체크리스트
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('checklist').where('email', isEqualTo: GetStorage().read('email'))
                      .where('gubun', isNotEqualTo: '폴더')
                      .where('date', isEqualTo: ThisWeekController.to.selectedDate.value.substring(0,10)).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                    }
                    return Container(
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child:
                            InkWell(
                              onTap: () {
                                ChecklistController.to.id = doc.id;
                                ChecklistController.to.title.value = doc['title'];
                                ChecklistController.to.selectedDate.value = doc['date'];
                                ChecklistController.to.whoCall = 'Thisweek';
                                checklistDialog(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.insert_drive_file_outlined,),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 220,
                                        child: Text(doc['title'], overflow: TextOverflow.ellipsis,),
                                      ),
                                      Row(
                                        children: [
                                          Text(doc['date'].substring(2,4) + '.' +
                                              doc['date'].substring(5,7) + '.' +
                                              doc['date'].substring(8,10) + '(' +
                                              DateFormat.E('ko_KR').format(DateTime.parse(doc['date'])) + ')',
                                            style: TextStyle(fontSize: 11, color: Colors.grey),),
                                          SizedBox(width: 5,),
                                          doc['gubun'] == '폴더파일' ?
                                          Icon(Icons.folder, color: Colors.teal.withOpacity(0.7), size: 15,) :
                                          SizedBox(),
                                          doc['gubun'] == '폴더파일' ?
                                          Text(doc['folderTitle'], style: TextStyle(fontSize: 11, color: Colors.grey),)
                                              : SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(),),
                                  Text(doc['numArray'].length.toString(), style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                                ],),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) {
                          return Divider(color: Colors.grey.withOpacity(0.7),);
                        },
                      ),
                    );

                  },
                ),
                SizedBox(height: 20,),
                /// 수업
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.teal.withOpacity(0.7),
                  ),
                  child: Center(child: Text('수업', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,),),),
                ),
                // SizedBox(height: 10,),
                FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('thisweek').where('email', isEqualTo: GetStorage().read('email'))
                        .where('date', isEqualTo: ThisWeekController.to.selectedDate.substring(0,10) ).get(),
                    builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                      }

                      if (snapshot.data!.docs.length > 0) {
                        ThisWeekController.to.class0 = snapshot.data!.docs[0]['class0'];
                        ThisWeekController.to.class1 = snapshot.data!.docs[0]['class1'];
                        ThisWeekController.to.class2 = snapshot.data!.docs[0]['class2'];
                        ThisWeekController.to.class3 = snapshot.data!.docs[0]['class3'];
                        ThisWeekController.to.class4 = snapshot.data!.docs[0]['class4'];
                        ThisWeekController.to.class5 = snapshot.data!.docs[0]['class5'];
                        ThisWeekController.to.class6 = snapshot.data!.docs[0]['class6'];
                        ThisWeekController.to.class7 = snapshot.data!.docs[0]['class7'];

                        ThisWeekController.to.content0 = snapshot.data!.docs[0]['content0'];
                        ThisWeekController.to.content1 = snapshot.data!.docs[0]['content1'];
                        ThisWeekController.to.content2 = snapshot.data!.docs[0]['content2'];
                        ThisWeekController.to.content3 = snapshot.data!.docs[0]['content3'];
                        ThisWeekController.to.content4 = snapshot.data!.docs[0]['content4'];
                        ThisWeekController.to.content5 = snapshot.data!.docs[0]['content5'];
                        ThisWeekController.to.content6 = snapshot.data!.docs[0]['content6'];
                        ThisWeekController.to.content7 = snapshot.data!.docs[0]['content7'];
                        ThisWeekController.to.memo = snapshot.data!.docs[0]['memo'];
                      } else {
                        ThisWeekController.to.class0 = ThisWeekController.to.selectedTimetable['class0']!;
                        ThisWeekController.to.class1 = ThisWeekController.to.selectedTimetable['class1']!;
                        ThisWeekController.to.class2 = ThisWeekController.to.selectedTimetable['class2']!;
                        ThisWeekController.to.class3 = ThisWeekController.to.selectedTimetable['class3']!;
                        ThisWeekController.to.class4 = ThisWeekController.to.selectedTimetable['class4']!;
                        ThisWeekController.to.class5 = ThisWeekController.to.selectedTimetable['class5']!;
                        ThisWeekController.to.class6 = ThisWeekController.to.selectedTimetable['class6']!;
                        ThisWeekController.to.class7 = ThisWeekController.to.selectedTimetable['class7']!;

                        ThisWeekController.to.content0 = '';
                        ThisWeekController.to.content1 = '';
                        ThisWeekController.to.content2 = '';
                        ThisWeekController.to.content3 = '';
                        ThisWeekController.to.content4 = '';
                        ThisWeekController.to.content5 = '';
                        ThisWeekController.to.content6 = '';
                        ThisWeekController.to.content7 = '';
                        ThisWeekController.to.memo = '';
                      }
                      return Column(
                        children: [
                          Container(
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: 8,
                              itemBuilder: (_, index) {
                                // var controller1 = TextEditingController();
                                var controller2 = TextEditingController();
                                var subject = '';

                                if (snapshot.data!.docs.length == 0) {
                                  subject = ThisWeekController.to.selectedTimetable['class${index}']!;
                                }else {
                                  controller2.text = snapshot.data!.docs[0]['content${index}'];
                                  subject = snapshot.data!.docs[0]['class${index}'];

                                }

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.3),),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        width: 45, height: 70,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(width: 1, color: Colors.grey.withOpacity(0.3),),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            var id = ThisWeekController.to.selectedDate.value.substring(0,10) + GetStorage().read('email');
                                            if (snapshot.data!.docs.length > 0) {
                                              subjectDialog(context, index, subject, snapshot.data!.docs[0].id);
                                            }else {
                                              subjectDialog(context, index, subject, id);
                                            }

                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment(0.0, 0.0),
                                                width: 25,
                                                child: Text(subject,
                                                  style: TextStyle(fontSize: index == 7 ? 9 : 13,
                                                      fontWeight: FontWeight.bold),),
                                                decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(width: 1, color: Colors.grey,),),
                                                ),
                                              ),
                                              if (index != 0 && index !=7)
                                                Text('${index.toString()}교시', style: TextStyle(fontSize: 10), ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child:
                                        TextField(
                                          controller: controller2,
                                          onChanged: (value) {
                                            if (index == 0) { ThisWeekController.to.content0 = value; }
                                            else if (index == 1) { ThisWeekController.to.content1 = value; }
                                            else if (index == 2) { ThisWeekController.to.content2 = value; }
                                            else if (index == 3) { ThisWeekController.to.content3 = value; }
                                            else if (index == 4) { ThisWeekController.to.content4 = value; }
                                            else if (index == 5) { ThisWeekController.to.content5 = value; }
                                            else if (index == 6) { ThisWeekController.to.content6 = value; }
                                            else if (index == 7) { ThisWeekController.to.content7 = value; }

                                            var id = ThisWeekController.to.selectedDate.value.substring(0,10) + GetStorage().read('email');
                                            if (snapshot.data!.docs.length > 0) {
                                              ThisWeekController.to.setThisweek(snapshot.data!.docs[0].id);
                                            }else {
                                              ThisWeekController.to.setThisweek(id);
                                            }

                                          },
                                          minLines: 4,
                                          maxLines: 8,
                                          style: TextStyle(fontSize: 15,),
                                          decoration: InputDecoration(border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          /// 메모
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.teal.withOpacity(0.7),
                              // border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.3),),),
                            ),
                            child: Center(child: Text('메모', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,),),),),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: TextField(
                              controller: TextEditingController(text: ThisWeekController.to.memo),
                              onChanged: (value) {
                                ThisWeekController.to.memo = value;

                                var id = ThisWeekController.to.selectedDate.value.substring(0,10) + GetStorage().read('email');
                                if (snapshot.data!.docs.length > 0) {
                                  ThisWeekController.to.setThisweek(snapshot.data!.docs[0].id);
                                }else {
                                  ThisWeekController.to.setThisweek(id);
                                }
                              },
                              minLines: 6,
                              maxLines: 15,
                              style: TextStyle(fontSize: 15.0,),
                              decoration: InputDecoration(
                                hintText: "내용을 입력하세요",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                ),
                SizedBox(height: 80,),
              ],
            ),
          ),
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
            Expanded(child: SizedBox()),
            SizedBox(
              width: 40,
              child: // 키보드 입력이 없으면 안보이게
              MediaQuery.of(context).viewInsets.bottom == 0 ? SizedBox() :
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  // 이거 안하면 키보드 내려갔을때 입력값이 원복됨.
                  // ThisWeekController.to.checkClass();
                  // if (ThisWeekController.to.isClass == false) {
                  //   /// 기초 시간표 가져와서 리스트 만들기
                  //   ThisWeekController.to.selectedTimeTable();
                  // }else{
                  //   ThisWeekController.to.selectedClass();
                  // }
                },
                tooltip: '키보드',
                child: const Icon(Icons.keyboard_hide, color: Colors.grey,),
                // const Text('상중하'),
              ),
            ),
          ],
        ),

    );
  }
}



