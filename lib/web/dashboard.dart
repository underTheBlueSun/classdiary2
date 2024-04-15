import 'package:classdiary2/board_main.dart';
import 'package:classdiary2/controller/academic_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:classdiary2/controller/notice_controller.dart';
import 'package:classdiary2/controller/subject_controller.dart';
import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:classdiary2/web/absent.dart';
import 'package:classdiary2/web/absent_s_indi.dart';
import 'package:classdiary2/web/absent_s_month.dart';
import 'package:classdiary2/web/academic.dart';
import 'package:classdiary2/web/academic_full.dart';
import 'package:classdiary2/web/attendance.dart';
import 'package:classdiary2/web/attendance_reg.dart';
import 'package:classdiary2/web/checklist.dart';
import 'package:classdiary2/web/checklist_detail.dart';
import 'package:classdiary2/web/checklist_folder.dart';
import 'package:classdiary2/web/checklist_s_month.dart';
import 'package:classdiary2/web/checklist_s_week.dart';
import 'package:classdiary2/web/consult.dart';
import 'package:classdiary2/web/consultDetail.dart';
import 'package:classdiary2/web/estimate.dart';
import 'package:classdiary2/web/estimate_detail.dart';
import 'package:classdiary2/web/estimate_folder.dart';
import 'package:classdiary2/web/estimate_s_score.dart';
import 'package:classdiary2/web/estimate_s_tripple.dart';
import 'package:classdiary2/web/note.dart';
import 'package:classdiary2/web/note_detail.dart';
import 'package:classdiary2/web/notice_detail.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:classdiary2/web/thisweek.dart';
import 'package:classdiary2/web/timetable.dart';
import 'package:classdiary2/web/menu_view.dart';
import 'package:classdiary2/web/todo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../board_indi.dart';
import '../board_indi_temp.dart';
import '../controller/signinup_controller.dart';
import 'timetable.dart';

// ignore_for_file: prefer_const_constructors

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);


  void toDoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  width: 500, height: 40,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    child: TextField(
                      autofocus: true,
                      style: TextStyle( height: 1.0, fontWeight: FontWeight.bold,
                      ),
                      onSubmitted: (value) {
                        toDoValidate(context);
                      },
                      onChanged: (value) {
                        DashboardController.to.todoContent = value;
                      },
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.circle_outlined, color: Colors.orange,),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent,),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent,),
                        ),
                        hintText: '할 일을 입력하세요',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              Divider(thickness: 1, height: 1,),
                Expanded(
                  child: Container(
                    width: 500, height: 70,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      child: TextField(
                        minLines: 10,
                        maxLines: 10,
                        style: TextStyle( fontSize: 14),
                        onChanged: (value) {
                          DashboardController.to.todoMemo = value;
                        },
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.circle_outlined, color: Colors.orange,),
                          // Icon(Icons.check_circle_outline, color: Colors.grey,),,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent,),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent,),
                          ),
                          hintText: '메모',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 1, height: 1,),
                SizedBox(height: 10,),
                /// 만료일, 반복
                Obx(() => Row(
                  children: [
                    SizedBox(width: 7,),
                    if (DashboardController.to.isSelectedDate.value == false)
                      Container(
                        width: 80, height: 30,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          child: TextField(
                            // controller: TextEditingController(text: DashboardController.to.selectedDateTodo.value.substring(5,10)),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                            // FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ]'))
                            ],
                            style: TextStyle( height: 1.0, fontWeight: FontWeight.bold,),
                            onSubmitted: (value) {
                              toDoValidate(context);
                            },
                            onChanged: (value) {
                              DashboardController.to.selectedDateTodo.value = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              // prefixIcon: Icon(Icons.calendar_month, color: Colors.grey, size: 20,),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,),),
                              hintText: '만료일',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ),
                    if (DashboardController.to.isSelectedDate.value == true)
                      Container(
                        width: 100, height: 45,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          child: TextField(
                            controller: TextEditingController(text: DashboardController.to.selectedDateTodo.value),
                            enabled: false, // 수정 못하게
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ]'))
                            ],
                            style: TextStyle(height: 1.0, fontWeight: FontWeight.bold,),
                            onSubmitted: (value) {
                              toDoValidate(context);
                            },
                            onChanged: (value) {
                              DashboardController.to.selectedDateTodo.value = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              // prefixIcon: Icon(Icons.calendar_month, color: Colors.grey, size: 20,),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,),),
                              hintText: '만료일',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 10,),
                    Container(
                      height: 22,
                      child: OutlinedButton(
                        onPressed: () {
                          calendarDialog(context, 'todo');
                        }, // onPressed
                        child: Text('날짜선택', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                      ),
                    ),
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   hoverColor: Colors.transparent,
                    //   splashColor: Colors.transparent,
                    //   onTap: () {
                    //     calendarDialog(context, 'todo');
                    //   },
                    //   child: Container(
                    //     width: 20,
                    //     child: Icon(Icons.calendar_month, color: Colors.teal.withOpacity(0.7), size: 25,),
                    //   ),
                    // ),
                    SizedBox(width: 40,),
                    Text('반복'),
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        DashboardController.to.isRepeatToggle.value = !DashboardController.to.isRepeatToggle.value;
                      },
                      child: DashboardController.to.isRepeatToggle.value == true
                          ? Icon(Icons.toggle_on, color: Colors.teal.withOpacity(0.7), size: 38,)
                          : Icon(Icons.toggle_off, color: Colors.grey, size: 38,),
                    ),
                    //  반복 토글
                    if (DashboardController.to.isRepeatToggle.value == true)
                      Row(
                        children: [
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              DashboardController.to.repeatToggle.value = 'day';
                            },
                            child: Container(
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.all(3),
                              decoration : DashboardController.to.repeatToggle.value == 'day'
                                  ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                  : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                              child: Center(
                                child: Text('매일', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                              ),
                            ),
                          ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              DashboardController.to.repeatToggle.value = 'week';
                            },
                            child: Container(
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.all(3),
                              decoration : DashboardController.to.repeatToggle.value == 'week'
                                  ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                  : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                              child: Center(
                                child: Text('매주', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                              ),
                            ),
                          ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              DashboardController.to.repeatToggle.value = 'month';
                            },
                            child: Container(
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.all(3),
                              decoration : DashboardController.to.repeatToggle.value == 'month'
                                  ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                  : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                              child: Center(
                                child: Text('매월', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                              ),
                            ),
                          ),
                        ],
                      ),

                  ],
                ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('만료일: 내,내일,모,모레,월~금 입력가능', style: TextStyle(fontSize: 12),),
                  OutlinedButton(
                    onPressed: () {
                      // DashboardController.to.todoMemo = '';
                      toDoValidate(context);
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void calendarDialog(BuildContext context, gubun) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 400,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],),
                TableCalendarWidget(gubun: gubun,),
              ],
            ),
          ),
        );
      },
    );
  }

  void attendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 350,
            height: 700,
            child: AttendanceReg(),
          ),
        );
      },
    );
  }

  void checkDialog(BuildContext context, gubun) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 80.0,
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
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      ChecklistController.to.title.value = value;
                    },
                    onSubmitted: (value) {
                      if (value != '') {
                        ChecklistController.to.saveFolerFile(gubun);
                        Navigator.pop(context);
                      }
                    },
                    // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                    decoration: InputDecoration(
                      hintText:
                      gubun == '폴더' ?
                      '폴더명을 입력하세요' :
                      '제목을 입력하세요',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey, ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (ChecklistController.to.title != '') {
                        ChecklistController.to.saveFolerFile(gubun);  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void estimateDialog(BuildContext context, gubun) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        /// 조건문 안주면 마지막 esti값으로 상태가 자꾸 변함
        if(EstiController.to.whereToGo == 'Estimate') {
          EstiController.to.esti.value = 'tripple';
        }

        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 120,
            child: Obx(() => Column(
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
                  Container(
                    width: 300,
                    child: Column(
                      children: [
                        TextField(
                          autofocus: true,
                          onChanged: (value) {
                            EstiController.to.title.value = value;
                          },
                          onSubmitted: (value) {
                            if (value != '') {
                              EstiController.to.saveEsti(gubun);
                              Navigator.pop(context);
                            }
                          },
                          // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                          decoration: InputDecoration(
                            hintText:
                            gubun == '폴더' ?
                            '폴더명을 입력하세요' :
                            '제목을 입력하세요',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey, ),
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: 20,),
                        if(EstiController.to.whereToGo != 'EstimateFolder')
                        Row(
                          children: [
                            Text('평가기준: ', style: TextStyle(fontSize: 13),),
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                EstiController.to.esti.value = 'tripple';
                              },
                              child: Container(
                                width: 50,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.all(3),
                                decoration : EstiController.to.esti.value == 'tripple'
                                    ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                    : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                                child: Center(
                                  child: Text('상중하', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                EstiController.to.esti.value = 'score';
                              },
                              child: Container(
                                width: 50,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.all(3),
                                decoration : EstiController.to.esti.value == 'score'
                                    ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                    : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                                child: Center(
                                  child: Text('점수', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (EstiController.to.title != '') {
                        EstiController.to.saveEsti(gubun);  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void consultDialog(BuildContext context) {
    ConsultController.to.consultInput = '';
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 400, width: 400,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    controller: TextEditingController(text: ConsultController.to.consultInput),
                    autofocus: true,
                    onChanged: (value) {
                      ConsultController.to.consultInput = value;
                    },
                    minLines: 20, /// 배포시 만약 6으로 하면 6번째 라인에서 한글이 깨짐
                    maxLines: 20,
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
                      if (ConsultController.to.consultInput.length > 0) {
                        ConsultController.to.saveConsult();
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void noteDialog(BuildContext context) {
    NoteController.to.noteInput = '';
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 400, width: 400,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    controller: TextEditingController(text: NoteController.to.noteInput),
                    autofocus: true,
                    onChanged: (value) {
                      NoteController.to.noteInput = value;
                    },
                    minLines: 20, /// 배포시 만약 6으로 하면 6번째 라인에서 한글이 깨짐
                    maxLines: 20,
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
                      if (NoteController.to.noteInput.length > 0) {
                        NoteController.to.saveNote();
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void academicDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 800,
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],),
                AcademicFull(),
              ],
            ),
          ),
        );
      },
    );
  }

  void popupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 500,
            height: 750,
            child: NoticeDetail(),
          ),
        );
      },
    );
  }

  void excelDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Material(
              color: Colors.transparent,
              child: Text('지금까지의 이번주 데이터를 엑셀로 내보내기 합니다.', ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('내보내기'), onPressed: () {
              ThisWeekController.to.exportExcel();
              Navigator.pop(context);
            }),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    List pages = [BoardMain(), BoardIndi()];

    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await NoticeController.to.getPopup();

      if (GetStorage().read('popup-id') != NoticeController.to.doc?.id) {
        popupDialog(context);
      }

    });

    // Get.put(DashboardController());
    // Get.put(TimeTableController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///  MenuView
            Container(
              // margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(bottom: 10),
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                color: Colors.black.withOpacity(0.7),
                // borderRadius: BorderRadius.circular(5.0),
              ),
              child: MenuView(),
            ),

            ///  content
            Obx(() =>
            // SubjectController.to.isSubject.value == true ?
            // BoardIndiTemp() :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 왼쪽 화면
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  height: 840.0,
                  width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.3,
                  // width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.328,
                  // width: 400,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5),),
                  ),
                  child: Column(
                    children: [
                      Obx(() => buildColumn(DashboardController.to.clickedMenu.value, context),),
                      Expanded(child: SizedBox()),
                      Center(
                        child: Text('Copyright 2022. KyongDon Um All rights reserved', style: TextStyle(fontSize: 12),),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
                /// 중간 화면, 가운데
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 20),
                      height: (DashboardController.to.clickedMenu.value == '이번주' || DashboardController.to.clickedMenu.value == '상담일지' ||
                          DashboardController.to.clickedMenu.value == '노트') ? 260.0 : 350.0,
                      // DashboardController.to.clickedMenu.value == '노트') ? 310.0 : 350.0,
                      width: MediaQuery.of(context).size.width > 1200 ? 420 : MediaQuery.of(context).size.width * 0.328,
                      // width: MediaQuery.of(context).size.width > 1200 ? 420 : MediaQuery.of(context).size.width * 0.344,
                      // width: 420.0,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5),),
                      ),
                      child: DashboardController.to.clickedMenu.value == '출결관리'
                          ? buildColumn('월간 출결현황', context)
                          : DashboardController.to.clickedMenu.value == '체크리스트'
                          ? buildColumn('월간 체크현황', context)
                          : DashboardController.to.clickedMenu.value == '평가관리'
                          ? buildColumn('개인별 평가현황(상중하)', context)
                          : buildColumn('시간표', context),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 20),
                      height: (DashboardController.to.clickedMenu.value == '이번주' || DashboardController.to.clickedMenu.value == '상담일지' ||
                          DashboardController.to.clickedMenu.value == '노트') ? 560.0 : 470.0,
                      // DashboardController.to.clickedMenu.value == '노트') ? 510.0 : 470.0,
                      // width: 420.0,
                      width: MediaQuery.of(context).size.width > 1200 ? 420 : MediaQuery.of(context).size.width * 0.328,
                      // width: MediaQuery.of(context).size.width > 1200 ? 420 : MediaQuery.of(context).size.width * 0.344,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5),),
                      ),
                      child: DashboardController.to.clickedMenu.value == '출결관리'
                          ? buildColumn('개인별 출결현황', context)
                          : DashboardController.to.clickedMenu.value == '체크리스트'
                          ? buildColumn('주간 체크현황', context)
                          : DashboardController.to.clickedMenu.value == '평가관리'
                          ? buildColumn('개인별 평가현황(점수)', context)
                          : buildColumn('학사일정', context),
                    ),
                  ],
                ),
                /// 오른쪽 화면
                Column(
                  children: [
                    Visibility(
                      visible: DashboardController.to.isVisibleRight.value,
                      child:
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 310.0,
                        width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.3,
                        // width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.328,
                        // width: 400,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5),),
                        ),

                        child: buildColumn('출석부', context),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20),
                      // height: 510.0,
                      height: DashboardController.to.isVisibleRight.value == true ?  510 : 840,
                      // width: 400,
                      width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.3,
                      // width: MediaQuery.of(context).size.width > 1200 ? 400 : MediaQuery.of(context).size.width * 0.328,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5),),
                      ),
                      child: buildColumn('할 일', context),
                    ),
                  ],
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildColumn(menu, context) {
    return Column(
      children: [
        Container(
                    padding: menu == '학사일정' ?
                    EdgeInsets.only(right: 10, left: 10, top:10, bottom: 5) :
                    EdgeInsets.only(right: 20, left: 20, top:20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                if(menu == '이번주') {
                                  ThisWeekController.to.selectedDate.value = DateTime.now().toString();
                                  ThisWeekController.to.getThisWeeks();
                                }else {

                                }
                              },
                                child: Row(
                                  children: [
                                    Text(menu, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold,),),
                                    /// 1월, 2월 처리
                                    menu == '출석부' ?
                                    DateTime.now().month == 1 || DateTime.now().month == 2 ?
                                    Text(' (${(DateTime.now().year - 1).toString()} 학년도)',) :
                                    Text(' (${(DateTime.now().year).toString()} 학년도)',) :
                                        SizedBox(),
                                  ],
                                ),
                            ),
                            if (menu == '체크리스트')
                              Row(
                                children: [
                                  // if(ChecklistController.to.whereToGo != 'ChecklistFolder' && ChecklistController.to.whereToGo != 'ChecklistDetail')
                                  if(ChecklistController.to.whereToGo == 'Checklist')
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      checkDialog(context, '폴더');
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      // height: 50,
                                      child: Icon(Icons.create_new_folder_outlined, size: 25, ),
                                    ),
                                  ),
                                  if(ChecklistController.to.whereToGo != 'ChecklistDetail')
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      if(ChecklistController.to.whereToGo == 'Checklist') {
                                        checkDialog(context, '파일');
                                      }else {
                                        checkDialog(context, '폴더파일');
                                      }

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      // height: 50,
                                      child: Icon(Icons.insert_drive_file_outlined, size: 25, ),
                                    ),
                                  ),
                                ],
                              ),
                            if (menu == '평가관리')
                              Row(
                                children: [
                                  // if(EstiController.to.whereToGo != 'EstimateFolder' && EstiController.to.whereToGo != 'EstimateDetail')
                                  if(EstiController.to.whereToGo == 'Estimate')
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        estimateDialog(context, '폴더');
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        // height: 50,
                                        child: Icon(Icons.create_new_folder_outlined, size: 25, ),
                                      ),
                                    ),
                                  if(EstiController.to.whereToGo != 'EstimateDetail')
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        if(EstiController.to.whereToGo == 'Estimate') {
                                          estimateDialog(context, '파일');
                                        }else {
                                          estimateDialog(context, '폴더파일');
                                        }

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 60,
                                        // height: 50,
                                        child: Icon(Icons.insert_drive_file_outlined, size: 25, ),
                                      ),
                                    ),
                                ],
                              ),
                            if (menu == '할 일')

                              Row(
                                children: [
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      DashboardController.to.isVisibleRight.value = !DashboardController.to.isVisibleRight.value;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      // height: 50,
                                      child: DashboardController.to.isVisibleRight.value == false ?
                                      Icon(Icons.fullscreen_exit, size: 28, color: Colors.grey,) :
                                      Icon(Icons.fullscreen, size: 28, color: Colors.grey,),
                                    ),
                                  ),
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      DashboardController.to.todoContent = '';
                                      DashboardController.to.selectedDateTodo.value = '';
                                      DashboardController.to.isSelectedDate.value = false;
                                      DashboardController.to.isRepeatToggle.value = false;
                                      DashboardController.to.repeatToggle.value = 'no';
                                      DashboardController.to.todoMemo = '';
                                      toDoDialog(context);

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      // height: 50,
                                      child: Icon(Icons.add_circle_outline, size: 28, color: Colors.grey,),
                                    ),
                                  ),
                                ],
                              ),
                            if (menu == '출석부')
                              SizedBox(
                                height: 25,
                                child: OutlinedButton(
                                  onPressed: () {
                                    attendanceDialog(context);
                                  }, // onPressed
                                  child: Text('편집', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                                ),
                              ),
                            if (menu == '상담일지')
                              Row(
                                children: [
                                  if(ConsultController.to.whereToGo == 'Consult')
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        consultDialog(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        // height: 50,
                                        child: Icon(Icons.add_circle_outline, size: 28, color: Colors.grey,),
                                      ),
                                    ),
                                  if(ConsultController.to.whereToGo == 'ConsultDetail')
                                    OutlinedButton(
                                      onPressed: () async {
                                        if (ConsultController.to.consultInput.length > 0) {
                                          ConsultController.to.updConsult();
                                          ConsultController.to.whereToGo.value = 'Consult';
                                          ConsultController.to.consultInput = '';
                                        }
                                      }, // onPressed
                                      child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                                    ),
                                ],
                              ),

                            if (menu == '노트')
                              Row(
                                children: [
                                  if(NoteController.to.whereToGo == 'Note')
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        noteDialog(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        // height: 50,
                                        child: Icon(Icons.add_circle_outline, size: 28, color: Colors.grey,),
                                      ),
                                    ),
                                  if(NoteController.to.whereToGo == 'NoteDetail')
                                    OutlinedButton(
                                      onPressed: () async {
                                        if (NoteController.to.noteInput.length > 0) {
                                          NoteController.to.updNote();
                                          NoteController.to.whereToGo.value = 'Note';
                                          NoteController.to.noteInput = '';
                                        }
                                      }, // onPressed
                                      child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                                    ),
                                ],
                              ),

                            if (menu == '이번주')
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        ThisWeekController.to.getThisWeekAll();
                                        excelDialog(context);
                                      },
                                      child: Image.asset('assets/images/excel_icon.png', width: 25,),),
                                  SizedBox(width: 10,),
                                  SizedBox(
                                    height: 25,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        calendarDialog(context, 'thisweek');
                                      }, // onPressed
                                      child: Text('주간선택',style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 13),),
                                    ),
                                  ),
                                ],
                              ),
                            if (menu == '학사일정')
                              Row(
                                children: [

                                  Row(
                                    children: [
                                      Text('주 시작'),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          AcademicController.to.firstWeekChoice.value = 7;
                                          GetStorage().write('firstWeekChoice', 7);
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: CircleAvatar(
                                            backgroundColor: AcademicController.to.firstWeekChoice.value == 7
                                                ? Colors.orange.withOpacity(0.7)
                                                : Colors.grey.withOpacity(0.3),
                                            child: Text('일', style: TextStyle(fontSize: 11, color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          AcademicController.to.firstWeekChoice.value = 1;
                                          GetStorage().write('firstWeekChoice', 1);
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: CircleAvatar(
                                            backgroundColor: AcademicController.to.firstWeekChoice.value == 1
                                                ? Colors.orange.withOpacity(0.7)
                                                : Colors.black.withOpacity(0.6),
                                            child: Text('월', style: TextStyle(fontSize: 11, color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 25,),
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      academicDialog(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      // height: 50,
                                      child: Icon(Icons.fullscreen, size: 30, color: Colors.grey,),
                                    ),
                                  ),
                                ],
                              ),

                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1, height: 1,),
                        if (menu == '출결관리') Absent(),
                        if (menu == '월간 출결현황') AbsentSMonth(),
                        if (menu == '개인별 출결현황') AbsentSIndi(),
                        if (menu == '월간 체크현황') ChecklistSMonth(),
                        if (menu == '주간 체크현황') ChecklistSWeek(),
                        if (menu == '체크리스트' && ChecklistController.to.whereToGo.value == 'Checklist') Checklist(),
                        if (menu == '체크리스트' && ChecklistController.to.whereToGo.value == 'ChecklistFolder') ChecklistFolder(),
                        if (menu == '체크리스트' && ChecklistController.to.whereToGo.value == 'ChecklistDetail') ChecklistDetail(),
                        if (menu == '평가관리' && EstiController.to.whereToGo.value == 'Estimate') Estimate(),
                        if (menu == '평가관리' && EstiController.to.whereToGo.value == 'EstimateFolder') EstimateFolder(),
                        if (menu == '평가관리' && EstiController.to.whereToGo.value == 'EstimateDetail') EstimateDetail(),
                        if (menu == '개인별 평가현황(상중하)') EstimateSTripple(),
                        if (menu == '개인별 평가현황(점수)') EstimateSScore(),
                        if (menu == '이번주') ThisWeek(),
                        if (menu == '학사일정') Academic(),
                        if (menu == '상담일지' && ConsultController.to.whereToGo.value == 'Consult') Consult(),
                        if (menu == '상담일지' && ConsultController.to.whereToGo.value == 'ConsultDetail') ConsultDetail(),
                        if (menu == '노트' && NoteController.to.whereToGo.value == 'Note') Note(),
                        if (menu == '노트' && NoteController.to.whereToGo.value == 'NoteDetail') NoteDetail(),
                        if (menu == '할 일') ToDoView(),
                        if (menu == '시간표') TimeTable(),
                        if (menu == '출석부') Attendance(),

                      ],
                    ),
                  ),
      ],
    );
  }

  void toDoValidate(context) {
    List selectedDateTodoList = ['','오','오늘','내','내일','모','모레','월','월요','월요일','화','화요','화요일','수','수요','수요일','목','목요',
      '목요일','금','금요','금요일','토','토요','토요일','일','일요','일요일'];
    if (DashboardController.to.todoContent != '' && (selectedDateTodoList.contains(DashboardController.to.selectedDateTodo.value) || DashboardController.to.selectedDateTodo.value.length == 23)) {
      DashboardController.to.saveToDo();
      Navigator.pop(context);
    }else {
      return;
    }
  }

}




