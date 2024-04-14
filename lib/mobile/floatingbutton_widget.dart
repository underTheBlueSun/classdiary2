import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/signinup_controller.dart';

class FloatingButtonWidget extends StatelessWidget {

  void todoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return ToDoWidget();
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('저장은 엔터키', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  // OutlinedButton(
                  //   onPressed: () {
                  //     if (ChecklistController.to.title != '') {
                  //       if (MobileMainController.to.bottomNaviCurrentIndex.value == 1) {
                  //         ChecklistController.to.saveFolerFile(gubun);  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
                  //       }else {
                  //         EstiController.to.saveEsti(gubun);
                  //       }
                  //
                  //       Navigator.pop(context);
                  //     }
                  //   }, // onPressed
                  //   style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                  //   child: Text('저장', style: TextStyle(color: Colors.black),),
                  // ),
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
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 30,),
            FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: Colors.green.withOpacity(0.7),
              onPressed: () {
                todoDialog(context);
              },
              child: Text('할일', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        if (MobileMainController.to.bottomNaviCurrentIndex.value == 1 || MobileMainController.to.bottomNaviCurrentIndex.value == 2)
        Row(
          children: [
            FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.teal,
              onPressed: () {
                if (MobileMainController.to.bottomNaviCurrentIndex.value == 1) {
                  checkDialog(context, '폴더');
                }else {
                  estimateDialog(context, '폴더');
                }

              },
              child: const Icon(Icons.create_new_folder),
            ),
            SizedBox(width: 20,),
            FloatingActionButton(
              heroTag: "btn3",
              backgroundColor: Colors.orange.withOpacity(0.7).withOpacity(0.7),
              onPressed: () {
                if (MobileMainController.to.bottomNaviCurrentIndex.value == 1) {
                  checkDialog(context, '파일');
                }else {
                  estimateDialog(context, '파일');
                }
              },
              child: const Icon(Icons.add, color: Colors.white,),
            ),
          ],
        ),

      ],
    );
  }
}