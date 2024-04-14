import 'package:classdiary2/controller/anim_list_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/mobile_todo_controller.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:classdiary2/mobile/floatingbutton_widget.dart';
import 'package:classdiary2/mobile/popupmenu_widget.dart';
import 'package:classdiary2/mobile/todo_detail.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore_for_file: prefer_const_constructors

class ToDo extends StatelessWidget {

  Color changeCircleColor(date) {
    var _now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var _selectedDateTodo = DateTime(date.toDate().year, date.toDate().month, date.toDate().day);
    if(_selectedDateTodo.compareTo(_now) < 0 ) {
      return Colors.orange;
    }else if (_selectedDateTodo.compareTo(_now) == 0) {
      return Colors.teal.withOpacity(0.7);
    }else {
      return Colors.grey.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    MobileToDoController.to.isSelectedDate.value = false;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        title: Text('할 일', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          PopUpMenuWidget(),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// 안하면 obx 에러남
              Text(MobileToDoController.to.isToDoDate.value, style: TextStyle(fontSize: 1, color: Colors.transparent),),
              SizedBox(height: 5,),
              /// 버튼들 (전체,과거,오늘,미래)
              Obx(() => Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// 전체 버튼
                    InkWell(
                      onTap: () {
                        MobileToDoController.to.isToDoDate.value = '전체';
                      },
                      child: Container(
                        width: 53,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(3),
                        decoration : MobileToDoController.to.isToDoDate.value == '전체'
                            ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                            : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                        child: Center(
                          child: Text('전체 ${MobileToDoController.to.toDoTatalCnt.value}', style: TextStyle(color: Colors.black, fontSize: 14 ),),
                        ),
                      ),
                    ),
                    /// 과거 버튼
                    InkWell(
                      onTap: () {
                        MobileToDoController.to.isToDoDate.value = '과거';
                      },
                      child: Container(
                        width: 53,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(3),
                        decoration : MobileToDoController.to.isToDoDate.value == '과거'
                            ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                            : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                        child: Center(
                          child: Text('과거 ${MobileToDoController.to.toDoPrevCnt.value}', style: TextStyle(color: Colors.black, fontSize: 14 ),),
                        ),
                      ),
                    ),
                    /// 오늘 버튼
                    InkWell(
                      onTap: () {
                        MobileToDoController.to.isToDoDate.value = '오늘';
                      },
                      child: Container(
                        width: 53,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(3),
                        decoration : MobileToDoController.to.isToDoDate.value == '오늘'
                            ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                            : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                        child: Center(
                          child: Text('오늘 ${MobileToDoController.to.toDoTodayCnt.value}', style: TextStyle(color: Colors.black, fontSize: 14 ),),
                        ),
                      ),
                    ),
                    /// 미래 버튼
                    InkWell(
                      onTap: () {
                        MobileToDoController.to.isToDoDate.value = '미래';
                      },
                      child: Container(
                        width: 53,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(3),
                        decoration : MobileToDoController.to.isToDoDate.value == '미래'
                            ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                            : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                        child: Center(
                          child: Text('미래 ${MobileToDoController.to.toDoFutureCnt.value}', style: TextStyle(color: Colors.black, fontSize: 14 ),),
                        ),
                      ),
                    ),

                    /// 완료 버튼
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        MobileToDoController.to.isToDoDate.value = '완료';
                      },
                      child: Container(
                        width: 59,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(3),
                        decoration : MobileToDoController.to.isToDoDate.value == '완료'
                            ? BoxDecoration(color: Colors.teal.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                            : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                        child: Center(
                          child: Text('완료 ${MobileToDoController.to.toDoCompleteCnt.value}', style: TextStyle(color: Colors.black, fontSize: 14 ),),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              ),
              SizedBox(height: 20,),
              StreamBuilder<QuerySnapshot>(
                stream: MobileToDoController.to.isToDoDate.value == '완료' ?
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
                  MobileToDoController.to.getToDoCnt();
                  var items;
                  if (MobileToDoController.to.isToDoDate.value == '전체') {
                    items = snapshot.data!.docs;
                    /// getToDoCnt() 을 바로 위에서 부르지 않고 아래처럼 하면 빌드전에 obx를 먼저 불렀다고 에러남.
                    // Future.delayed(const Duration(milliseconds: 500), () {
                    //   MobileToDoController.to.toDoTatalCnt.value = items.length;
                    // });

                  }else if (MobileToDoController.to.isToDoDate.value == '과거') {
                    items = snapshot.data!.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day)
                        .compareTo(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) < 0).toList();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      MobileToDoController.to.toDoPrevCnt.value = items.length;
                    });

                  }else if (MobileToDoController.to.isToDoDate.value == '오늘') {
                    items = snapshot.data!.docs.where((doc) => DateTime(doc['date'].toDate().year, doc['date'].toDate().month, doc['date'].toDate().day)
                        .compareTo(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) == 0).toList();

                    Future.delayed(const Duration(milliseconds: 500), () {
                      MobileToDoController.to.toDoTodayCnt.value = items.length;
                    });
                  }else if (MobileToDoController.to.isToDoDate.value == '미래') {
                    items = snapshot.data!.docs.where((doc) => doc['date'].toDate().compareTo(DateTime.now()) > 0).toList();

                    Future.delayed(const Duration(milliseconds: 500), () {
                      MobileToDoController.to.toDoFutureCnt.value = items.length;
                    });
                  } else {
                    items = snapshot.data!.docs.toList();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      MobileToDoController.to.toDoCompleteCnt.value = items.length;
                    });
                  }

                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      var doc = items[index];
                      return Column(
                        children: [
                          Obx(() => Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  MobileToDoController.to.clickedToDoIndex.value = index;
                                  if (doc['repeat'] == 'no') {
                                    // Future.delayed(const Duration(milliseconds: 400), () {
                                    //   MobileToDoController.to.clickedToDoIndex.value = null;
                                    //   MobileToDoController.to.delToDo(doc.id);
                                    // });

                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      MobileToDoController.to.clickedToDoIndex.value = null;
                                      if (MobileToDoController.to.isToDoDate.value == '완료') {
                                        MobileToDoController.to.restoreToDo(doc);
                                      }else {
                                        MobileToDoController.to.completeToDo(doc);
                                      }

                                      // MobileToDoController.to.delToDo(doc.id);
                                    });


                                  }else {
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      MobileToDoController.to.clickedToDoIndex.value = null;
                                      MobileToDoController.to.repeatToDo(doc);
                                    });

                                  }
                                },

                                // child: MobileToDoController.to.clickedToDoIndex.value == index
                                //     ? Icon(Icons.check_circle, color: changeCircleColor(doc['date']), size: 32,)
                                //     : doc['repeat'] == 'no'
                                //     ? Icon(Icons.circle_outlined, color: changeCircleColor(doc['date']), size: 32,)
                                //     : Icon(Icons.change_circle_outlined, color: changeCircleColor(doc['date']), size: 32,),

                                child: MobileToDoController.to.isToDoDate.value != '완료' && MobileToDoController.to.clickedToDoIndex.value == index ?
                                Icon(Icons.check_circle, color: changeCircleColor(doc['date']), size: 32,) :
                                MobileToDoController.to.isToDoDate.value == '완료' && MobileToDoController.to.clickedToDoIndex.value == index ?
                                Icon(Icons.circle_outlined, color: changeCircleColor(doc['date']), size: 32,) :
                                MobileToDoController.to.isToDoDate.value != '완료' && doc['repeat'] == 'no' ?
                                Icon(Icons.circle_outlined, color: changeCircleColor(doc['date']), size: 32,) :
                                MobileToDoController.to.isToDoDate.value == '완료' && doc['repeat'] == 'no' ?
                                Icon(Icons.check_circle, color: changeCircleColor(doc['date']), size: 32,) :
                                Icon(Icons.change_circle_outlined, color: changeCircleColor(doc['date']), size: 32,),
                                
                                
                              ),
                              SizedBox(width: 5,),
                              InkWell(
                                onTap: () {
                                  MobileToDoController.to.todoContent = doc['content'];
                                  MobileToDoController.to.todoMemo = doc['memo'];
                                  MobileToDoController.to.selectedDateTodo.value = doc['date'].toDate().toString();
                                  MobileToDoController.to.repeatToggle.value = doc['repeat'];
                                  if (MobileToDoController.to.repeatToggle.value == 'no') {
                                    MobileToDoController.to.isRepeatToggle.value = false;
                                  }else {
                                    MobileToDoController.to.isRepeatToggle.value = true;
                                  }
                                  // toDoDetailDialog(context, doc, index);
                                  Get.to(() => ToDoDetail(), arguments: doc);
                                },
                                child: Container(
                                  width: 320,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MobileToDoController.to.isToDoDate.value == '완료'  ?
                                      Text(doc['content'], overflow: TextOverflow.ellipsis,
                                        style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 17),
                                      ) :
                                      Text(doc['content'], overflow: TextOverflow.ellipsis,
                                        style: MobileToDoController.to.clickedToDoIndex.value == index
                                            ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 17)
                                            : TextStyle(fontSize: 17),
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
                      return Divider(color: Colors.grey.withOpacity(0.3),);
                    },
                  );
                  // return Text('aaa');
                },
              ),
              SizedBox(height: 80,),
            ],
          ),
        ),
        ),
      ),
      bottomNavigationBar: BottomNaviBarWidget(),
      floatingActionButton: FloatingButtonWidget(),
    );
  }
}








