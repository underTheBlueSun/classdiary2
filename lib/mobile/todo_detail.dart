import 'package:classdiary2/controller/mobile_todo_controller.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:classdiary2/mobile/tablecalendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/signinup_controller.dart';

// ignore_for_file: prefer_const_constructors

class ToDoDetail extends StatelessWidget {

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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                    SizedBox(width: 10,),
                  ],),
                TableCalendarWidget(gubun: 'mobiletodo',),
              ],
            ),
          ),
        );
      },
    );
  }

  void toDoValidate(context, doc) {
    List selectedDateTodoList = ['','오','오늘','내','내일','모','모레','월','월요','월요일','화','화요','화요일','수','수요','수요일','목','목요',
      '목요일','금','금요','금요일','토','토요','토요일','일','일요','일요일'];
    if (MobileToDoController.to.todoContent != '' &&
        (selectedDateTodoList.contains(MobileToDoController.to.selectedDateTodo.value) || MobileToDoController.to.selectedDateTodo.value.length >= 23)) {
      MobileToDoController.to.updToDo(doc);
      /// back을 여기에 적으면 처음에 저장후 수정화면에서 반복을 제거하면 에러남
      // Get.back();
    }else {
      return;
    }
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true, /// back button
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey,),
        title: Text('할 일', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() =>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MobileToDoController.to.isToDoDate.value == '완료' ?
                  SizedBox() :
                  SizedBox(
                    height: 28,
                    child: OutlinedButton(
                      onPressed: () {
                        toDoValidate(context, Get.arguments);
                      }, // onPressed
                      child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                      ),),
                    ),
                  ),
                ],
              ),
              Container(
                width: 500, height: 40,
                child: TextField(
                  // controller: TextEditingController(text: '11'),
                  controller: TextEditingController(text: Get.arguments['content']),
                  autofocus: false,
                  style: TextStyle(height: 1.0, fontWeight: FontWeight.bold,
                  ),
                  onSubmitted: (value) {
                    toDoValidate(context, Get.arguments);
                  },
                  onChanged: (value) {
                    MobileToDoController.to.todoContent = value;
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
              SizedBox(height: 10,),
          Divider(color: Colors.grey.withOpacity(0.7),),
              Container(
                width: 500, height: 70,
                child: TextField(
                  controller: TextEditingController(text: Get.arguments['memo']),
                  minLines: 4,
                  maxLines: 10,
                  style: TextStyle(fontSize: 14),
                  onChanged: (value) {
                    MobileToDoController.to.todoMemo = value;
                  },
                  decoration: InputDecoration(
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
              SizedBox(height: 10,),
              Divider(color: Colors.grey.withOpacity(0.7),),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 7,),
                  Container(
                    width: 150, height: 45,
                    child: TextField(
                      controller: TextEditingController(text: '만료일: ${MobileToDoController.to.selectedDateTodo.value.substring(5,10)}(${DateFormat.E('ko_KR').format(DateTime.parse(MobileToDoController.to.selectedDateTodo.value))})'),
                      enabled: false, // 수정 못하게
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onSubmitted: (value) {
                        toDoValidate(context, Get.arguments);
                      },
                      onChanged: (value) {
                        MobileToDoController.to.selectedDateTodo.value = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
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
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      calendarDialog(context);
                    },
                    child: Container(
                      width: 30,
                      child: Icon(Icons.calendar_month, color: Colors.teal.withOpacity(0.7), size: 25,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Text('반복'),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      MobileToDoController.to.isRepeatToggle.value = !MobileToDoController.to.isRepeatToggle.value;
                    },
                    child: MobileToDoController.to.isRepeatToggle.value == true
                        ? Icon(Icons.toggle_on, color: Colors.teal.withOpacity(0.7), size: 38,)
                        : Icon(Icons.toggle_off, color: Colors.grey, size: 38,),
                  ),
                  ///  반복 토글
                  if (MobileToDoController.to.isRepeatToggle.value == true)
                    Row(
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'day';
                          },
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'day'
                                ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('매일', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'week';
                          },
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'week'
                                ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('매주', style: TextStyle(color: Colors.black, fontSize: 12 ),),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'month';
                          },
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'month'
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

            ],
          ),
        ),
      ),
      // body: Text('aaa'),
      // bottomNavigationBar: BottomNaviBarWidget(),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     SizedBox(width: 30,),
      //     FloatingActionButton(
      //       backgroundColor: Colors.green,
      //       onPressed: () {
      //         todoDialog(context);
      //       },
      //       child: const Text('할일'),
      //     ),
      //   ],
      // )
    );
  }
}









