import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/controller/mobile_todo_controller.dart';
import 'package:classdiary2/mobile/tablecalendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/signinup_controller.dart';

class ToDoWidget extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    MobileToDoController.to.isSelectedDate.value = false;
    MobileToDoController.to.isRepeatToggle.value = false;
    MobileToDoController.to.repeatToggle.value = 'no';
    MobileToDoController.to.selectedDateTodo.value = DateTime.now().toString().substring(0,23);
    return  AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        height: 250,
        child: Obx(() =>
            Column(
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
                ],
              ),
              Container(
                width: 500, height: 40,
                child: TextField(
                  autofocus: true,
                  style: TextStyle(fontSize: 17,),
                  onSubmitted: (value) {
                    toDoValidate(context);
                  },
                  onChanged: (value) {
                    MobileToDoController.to.todoContent = value;
                  },
                  decoration: InputDecoration(
                    hintText: '할 일을 입력하세요',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  width: 500, height: 30,
                  child: TextField(
                    minLines: 2,
                    maxLines: 5,
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
              ),
              Row(
                children: [
                  // SizedBox(width: 2,),
                  if (MobileToDoController.to.isSelectedDate.value == false)
                    Container(
                      width: 50, height: 35,
                      child: TextField(
                        // controller: TextEditingController(text: DateTime.now().toString().substring(5,10)),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onSubmitted: (value) {
                          toDoValidate(context);
                        },
                        onChanged: (value) {
                          MobileToDoController.to.selectedDateTodo.value = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: DateTime.now().toString().substring(5,10),
                          counterText: '',
                          hintStyle: const TextStyle(fontSize: 16.0,),
                        ),
                        // decoration: InputDecoration(filled: true,),
                      ),
                    ),
                  if (MobileToDoController.to.isSelectedDate.value == true)
                    Container(
                      width: 50, height: 45,
                      child: TextField(
                        controller: TextEditingController(text: MobileToDoController.to.selectedDateTodo.value.substring(5,10)),
                        enabled: false, // 수정 못하게
                        onSubmitted: (value) {
                          toDoValidate(context);
                        },
                        onChanged: (value) {
                          MobileToDoController.to.selectedDateTodo.value = value;
                        },
                        decoration: InputDecoration(border: InputBorder.none, counterText: '',),
                      ),
                    ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      calendarDialog(context, 'mobiletodo');
                    },
                    child: Container(
                      width: 20,
                      child: Icon(Icons.calendar_month, color: Colors.teal.withOpacity(0.7), size: 25,),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 2,),
                  Text('반복', style: TextStyle(color: Colors.grey),),
                  InkWell(
                    onTap: () {
                      MobileToDoController.to.isRepeatToggle.value = !MobileToDoController.to.isRepeatToggle.value;
                    },
                    child: MobileToDoController.to.isRepeatToggle.value == true
                        ? Icon(Icons.toggle_on, color: Colors.teal.withOpacity(0.7), size: 40,)
                        : Icon(Icons.toggle_off, color: Colors.grey, size: 40,),
                  ),
                  ///  반복 토글
                  if (MobileToDoController.to.isRepeatToggle.value == true)
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'day';
                          },
                          child: Container(
                            width: 40, height: 25,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'day'
                                ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('매일', style: TextStyle(fontSize: 12 ),),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'week';
                          },
                          child: Container(
                            width: 40, height: 25,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'week'
                                ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('매주', style: TextStyle( fontSize: 12 ),),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            MobileToDoController.to.repeatToggle.value = 'month';
                          },
                          child: Container(
                            width: 40, height: 25,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(3),
                            decoration : MobileToDoController.to.repeatToggle.value == 'month'
                                ? BoxDecoration(color: Colors.orange.withOpacity(0.7),borderRadius: BorderRadius.circular(7),)
                                : BoxDecoration(color: Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(7),),
                            child: Center(
                              child: Text('매월', style: TextStyle(fontSize: 12 ),),
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
      actions: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: SizedBox()),
              // Text('만료일: 내,내일,모,모레,월~금 입력가능', style: TextStyle(fontSize: 10),),
              SizedBox(
                height: 28,
                child: OutlinedButton(
                  onPressed: () {
                    MobileToDoController.to.todoMemo = '';
                    toDoValidate(context);
                  }, // onPressed
                  child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                  ),),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void toDoValidate(context) {
    List selectedDateTodoList = ['','오','오늘','내','내일','모','모레','월','월요','월요일','화','화요','화요일','수','수요','수요일','목','목요',
      '목요일','금','금요','금요일','토','토요','토요일','일','일요','일요일'];
    if (MobileToDoController.to.todoContent != '' && (selectedDateTodoList.contains(MobileToDoController.to.selectedDateTodo.value)
        || MobileToDoController.to.selectedDateTodo.value.length == 23)) {

      MobileToDoController.to.saveToDo();
      Navigator.pop(context);
    }else {
      return;
    }
  }
  
}