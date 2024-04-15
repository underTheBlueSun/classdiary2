import 'package:classdiary2/controller/anim_list_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/signinup_controller.dart';

// ignore_for_file: prefer_const_constructors

class ToDoView extends StatelessWidget {
  const ToDoView({Key? key}) : super(key: key);

  void toDoDetailDialog(BuildContext context, item, index) {
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
                  ],),
                Container(
                  width: 500, height: 40,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    child: TextField(
                      controller: TextEditingController(text: item['content']),
                      // maxLength: 1,
                      autofocus: false,
                      style: TextStyle(height: 1.0, fontWeight: FontWeight.bold,
                      ),
                      onSubmitted: (value) {
                        toDoValidate(context, item, index);
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
                Expanded(
                  child: Container(
                    width: 500, height: 70,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      child: TextField(
                        controller: TextEditingController(text: item['memo']),
                        minLines: 4,
                        maxLines: 10,
                        style: TextStyle(fontSize: 14),
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
                SizedBox(width: 7,),
                Obx(() => Row(
                  children: [
                    // Text('만료일: ${doc['date'].toDate().toString().substring(5,10)}(${DateFormat.E('ko_KR').format(doc['date'].toDate()).toString()})'),
                    // SizedBox(width: 50,),
                    Container(
                      width: 150, height: 45,
                      child: TextField(
                        controller: TextEditingController(text: '만료일: ${DashboardController.to.selectedDateTodo.value.substring(5,10)}(${DateFormat.E('ko_KR').format(DateTime.parse(DashboardController.to.selectedDateTodo.value))})'),
                        enabled: false, // 수정 못하게
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          // FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ]'))
                        ],
                        onSubmitted: (value) {
                          toDoValidate(context, item, index);
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
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5),),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 22,
                      child: OutlinedButton(
                        onPressed: () {
                          calendarDialog(context);
                        }, // onPressed
                        child: Text('날짜선택', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                      ),
                    ),
                    /// 개발시엔 보이는데 빌드시엔 아이콘 깨짐
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   hoverColor: Colors.transparent,
                    //   splashColor: Colors.transparent,
                    //   onTap: () {
                    //     calendarDialog(context);
                    //   },
                    //   child: Container(
                    //     width: 20,
                    //     child: Icon(Icons.calendar_month, color: Colors.teal, size: 25,),
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
                          ? Icon(Icons.toggle_on, color: Colors.teal, size: 38,)
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
                          GestureDetector(
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
                          GestureDetector(
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
            DashboardController.to.isToDoDate.value == '완료' ?
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                DashboardController.to.delToDo(item.id);
                Navigator.pop(context);
              }, // onPressed
              child: Text('삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
              ),),
            ),
          ],
         ),
        ) :
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      toDoValidate(context, item, index);
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                    ),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void calendarDialog(BuildContext context) {
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
                TableCalendarWidget(gubun: 'todo',),
              ],
            ),
          ),
        );
      },
    );
  }

  void toDoValidate(context, item, index) {
    List selectedDateTodoList = ['','오','오늘','내','내일','모','모레','월','월요','월요일','화','화요','화요일','수','수요','수요일','목','목요',
      '목요일','금','금요','금요일','토','토요','토요일','일','일요','일요일'];
    if (DashboardController.to.todoContent != '' && (selectedDateTodoList.contains(DashboardController.to.selectedDateTodo.value) || DashboardController.to.selectedDateTodo.value.length == 23)) {
      DashboardController.to.updToDo(item);
      Navigator.pop(context);
    }else {
      return;
    }
  }

  Color changeCircleColor(date) {
    var _now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var _selectedDateTodo = DateTime(date.toDate().year, date.toDate().month, date.toDate().day);
    if(_selectedDateTodo.compareTo(_now) < 0 ) {
      return Colors.orange.withOpacity(0.7);
    }else if (_selectedDateTodo.compareTo(_now) == 0) {
      return Colors.teal;
    }else {
      return Colors.grey.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {

    // DashboardController.to.anilistInitCnt = 3;

    return SingleChildScrollView(
      child: Obx(() => Column(
        children: [
          /// 안하면 obx 에러남
          Text(DashboardController.to.isToDoDate.value, style: TextStyle(fontSize: 1, color: Colors.transparent),),
          SizedBox(height: 5,),
          /// 버튼들 (전체,과거,오늘,미래)
          Obx(() => Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// 전체 버튼
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    DashboardController.to.isToDoDate.value = '전체';
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(3),
                    decoration : DashboardController.to.isToDoDate.value == '전체'
                        ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                        : BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(7),),
                    child: Center(
                      child: Text('전체 ${DashboardController.to.toDoTatalCnt.value}', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                    ),
                  ),
                ),
                /// 과거 버튼
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    DashboardController.to.isToDoDate.value = '과거';
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(3),
                    decoration : DashboardController.to.isToDoDate.value == '과거'
                        ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                        : BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(7),),
                    child: Center(
                      child: Text('과거 ${DashboardController.to.toDoPrevCnt.value}', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                    ),
                  ),
                ),
                /// 오늘 버튼
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    DashboardController.to.isToDoDate.value = '오늘';
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(3),
                    decoration : DashboardController.to.isToDoDate.value == '오늘'
                        ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                        : BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(7),),
                    child: Center(
                      child: Text('오늘 ${DashboardController.to.toDoTodayCnt.value}', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                    ),
                  ),
                ),
                /// 미래 버튼
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    DashboardController.to.isToDoDate.value = '미래';
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(3),
                    decoration : DashboardController.to.isToDoDate.value == '미래'
                        ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                        : BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(7),),
                    child: Center(
                      child: Text('미래 ${DashboardController.to.toDoFutureCnt.value}', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                    ),
                  ),
                ),

                /// 완료 버튼
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    DashboardController.to.isToDoDate.value = '완료';
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.all(3),
                    decoration : DashboardController.to.isToDoDate.value == '완료'
                        ? BoxDecoration(color: Colors.teal.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                        : BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(7),),
                    child: Center(
                      child: Text('완료', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                      // child: Text('완료 ${DashboardController.to.toDoCompleteCnt.value}', style: TextStyle(color: Colors.black, fontSize: 11 ),),
                    ),
                  ),
                ),

              ],
            ),
          ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: DashboardController.to.isToDoDate.value == '완료' ?
            FirebaseFirestore.instance.collection('completetodo').where('email', isEqualTo: GetStorage().read('email'))
                .orderBy('date', descending: true).snapshots() :
            FirebaseFirestore.instance.collection('todo').where('email', isEqualTo: GetStorage().read('email')).orderBy('date', descending: true).snapshots(),
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
              DashboardController.to.getToDoCnt();
              var items;
              if (DashboardController.to.isToDoDate.value == '전체') {
                items = snapshot.data!.docs;
                /// getToDoCnt() 을 바로 위에서 부르지 않고 아래처럼 하면 빌드전에 obx를 먼저 불렀다고 에러남.
                // Future.delayed(const Duration(milliseconds: 500), () {
                //   DashboardController.to.toDoTatalCnt.value = items.length;
                // });

              }else if (DashboardController.to.isToDoDate.value == '과거') {
                items = snapshot.data!.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day)
                    .compareTo(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) < 0).toList();
                Future.delayed(const Duration(milliseconds: 500), () {
                  DashboardController.to.toDoPrevCnt.value = items.length;
                });

              }else if (DashboardController.to.isToDoDate.value == '오늘') {
                items = snapshot.data!.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day)
                    .compareTo(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) == 0).toList();

                Future.delayed(const Duration(milliseconds: 500), () {
                  DashboardController.to.toDoTodayCnt.value = items.length;
                });
              }else if (DashboardController.to.isToDoDate.value == '미래'){
                items = snapshot.data!.docs.where((doc) => doc['date'].toDate().compareTo(DateTime.now()) > 0).toList();

                Future.delayed(const Duration(milliseconds: 500), () {
                  DashboardController.to.toDoFutureCnt.value = items.length;
                });
              } else {
                items = snapshot.data!.docs.toList();
                Future.delayed(const Duration(milliseconds: 500), () {
                  DashboardController.to.toDoCompleteCnt.value = items.length;
                });
              }

              return Container(
                height: DashboardController.to.isVisibleRight.value == true ? 380 : 710,
                // height: 380,
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    var doc = items[index];
                    return Column(
                      children: [
                        Obx(() => Row(
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                DashboardController.to.clickedToDoIndex.value = index;
                                if (doc['repeat'] == 'no') {
                                  Future.delayed(const Duration(milliseconds: 400), () {
                                    DashboardController.to.clickedToDoIndex.value = null;
                                    if (DashboardController.to.isToDoDate.value == '완료') {
                                      DashboardController.to.restoreToDo(doc);
                                    }else {
                                      DashboardController.to.completeToDo(doc);
                                    }

                                    // DashboardController.to.delToDo(doc.id);
                                  });

                                }else {
                                  Future.delayed(const Duration(milliseconds: 400), () {
                                    DashboardController.to.clickedToDoIndex.value = null;
                                    DashboardController.to.repeatToDo(doc);
                                  });

                                }
                              },

                              // child: DashboardController.to.clickedToDoIndex.value == index ?
                              //   Icon(Icons.check_circle, color: changeCircleColor(doc['date'])) :
                              //   doc['repeat'] == 'no' ?
                              //   Icon(Icons.circle_outlined, color: changeCircleColor(doc['date'])) :
                              //   Icon(Icons.change_circle_outlined, color: changeCircleColor(doc['date'])),
                              child: DashboardController.to.isToDoDate.value != '완료' && DashboardController.to.clickedToDoIndex.value == index ?
                              Icon(Icons.check_circle, color: changeCircleColor(doc['date'])) :
                              DashboardController.to.isToDoDate.value == '완료' && DashboardController.to.clickedToDoIndex.value == index ?
                              Icon(Icons.circle_outlined, color: changeCircleColor(doc['date'])) :
                              DashboardController.to.isToDoDate.value != '완료' && doc['repeat'] == 'no' ?
                              Icon(Icons.circle_outlined, color: changeCircleColor(doc['date'])) :
                              DashboardController.to.isToDoDate.value == '완료' && doc['repeat'] == 'no' ?
                              Icon(Icons.check_circle, color: changeCircleColor(doc['date'])) :
                              Icon(Icons.change_circle_outlined, color: changeCircleColor(doc['date'])),
                            ),
                            SizedBox(width: 5,),
                            InkWell(

                              onTap: () {
                                DashboardController.to.todoContent = doc['content'];
                                DashboardController.to.todoMemo = doc['memo'];
                                DashboardController.to.selectedDateTodo.value = doc['date'].toDate().toString();
                                DashboardController.to.repeatToggle.value = doc['repeat'];
                                if (DashboardController.to.repeatToggle.value == 'no') {
                                  DashboardController.to.isRepeatToggle.value = false;
                                }else {
                                  DashboardController.to.isRepeatToggle.value = true;
                                }
                                toDoDetailDialog(context, doc, index);
                              },
                              child: Container(
                                width: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DashboardController.to.isToDoDate.value == '완료'  ?
                                    Text(doc['content'], overflow: TextOverflow.ellipsis,
                                      style: TextStyle(decoration: TextDecoration.lineThrough, ),
                                    ) :
                                    Text(doc['content'], overflow: TextOverflow.ellipsis,
                                      style: DashboardController.to.clickedToDoIndex.value == index
                                          ? TextStyle(decoration: TextDecoration.lineThrough,)
                                          : null,
                                    ),
                                    Text(doc['date'].toDate().toString().substring(0,10), style: TextStyle(color: Colors.grey, fontSize: 11,),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, index) {
                    return Divider(color: Colors.grey.withOpacity(0.7),);
                  },
                ),
              );
              // return Text('aaa');
            },
          ),
        ],
      ),
      ),
    );
  }
}








