import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/attendance_controller.dart';
import 'package:intl/intl.dart';

// ignore_for_file: prefer_const_constructors

class ChecklistDetail extends StatelessWidget {

  void calendarDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 450,
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
                  ],
                ),
                TableCalendarWidget(gubun: 'checklist',),
              ],
            ),
          ),
        );
      },
    );
  }

  void updTitleDialog(BuildContext context, title) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 150.0,
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
                Text('제목 수정'),
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    controller: TextEditingController(text: title),
                    // onChanged: (value) {
                    //   ChecklistController.to.title.value = value;
                    // },
                    onSubmitted: (value) {
                      if (value != '') {
                        ChecklistController.to.title.value = value;
                        ChecklistController.to.updTitle();
                        Navigator.pop(context);
                      }
                    },
                    // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
          ),
          // 액션을 빼는 이유는 타이틀 수정하고 x 눌러도 반영이 되어서
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.all(20.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         OutlinedButton(
          //           onPressed: () {
          //             if (ChecklistController.to.title != '') {
          //               ChecklistController.to.updTitle();  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
          //               Navigator.pop(context);
          //             }
          //           }, // onPressed
          //           style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
          //           child: Text('수정', style: TextStyle(color: Colors.black),),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        );
      },
    );
  }

  void delDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(
                  child: Container(
                      child: Center(child: Text('정말 삭제하시겠습니까?'))),
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
                      ChecklistController.to.delChecklist('파일');
                      Navigator.pop(context);
                    }, // onPressed
                    style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                    child: Text('삭제', style: TextStyle(color: Colors.black),),
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
    // 출석부 명단이 없으면 출석부로 이동하게 메시지 뿌림
    // AttendanceController.to.getAttendanceCnt();
    return Obx(() => SingleChildScrollView(
      child: Column(
        children: [
          if (ChecklistController.to.whoCall == 'Thisweek')
            Column(
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
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    updTitleDialog(context, ChecklistController.to.title.value);
                  },
                  child: Container(
                    width: 200,
                    child: Center(child: Text(ChecklistController.to.title.value, style: TextStyle(), overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          if (ChecklistController.to.whoCall != 'Thisweek')
          Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (ChecklistController.to.whoCall == 'ChecklistFolder') {
                        ChecklistController.to.whereToGo.value = 'ChecklistFolder';
                        DashboardController.to.isSearchSubmit.value = false;
                        DashboardController.to.isSearchFolded.value = true;
                      }else {
                        ChecklistController.to.whereToGo.value = 'Checklist';
                        DashboardController.to.isSearchSubmit.value = false;
                        DashboardController.to.isSearchFolded.value = true;
                      }
                    },
                    icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey,),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      updTitleDialog(context, ChecklistController.to.title.value);
                    },
                      child: Container(
                        width: 200,
                          child: Center(child: Text(ChecklistController.to.title.value, style: TextStyle(), overflow: TextOverflow.ellipsis,)),
                      ),
                  ),
                  IconButton(
                    onPressed: () {
                      delDialog(context);
                      // ChecklistController.to.delChecklist('파일');
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.grey,),
                  ),
                ],
              ),

              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  calendarDialog(context);
                },
                child: Text(
                  ChecklistController.to.selectedDate.substring(5,7) + '월 ' +
                      ChecklistController.to.selectedDate.substring(8,10) + '일(' +
                      DateFormat.E('ko_KR').format(DateTime.parse(ChecklistController.to.selectedDate.value)) + ')',
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.7)),
                  ),
                  SizedBox(width: 5,),
                  Text('체크 ${ChecklistController.to.checkCnt.value}'),
                ],
              ),

            ],
          ),
          SizedBox(height: 20,),
          Container(
            height: 550,
            child: StreamBuilder<QuerySnapshot>(
              /// 1월, 2월은 전학년도로 처리
                stream: FirebaseFirestore.instance
                    .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
                    // .where('yyyy', isEqualTo: DateTime.now().year.toString())
                    .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
                (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                    .orderBy('number', descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                  }
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 5 / 1, //item 의 가로, 세로 의 비율
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    // AttendanceController.to.getAbsentOrNot(doc['number']);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                              || index + 1 == AttendanceController.to.attendanceCnt.value
                              ? BorderSide(width: 1, color: Colors.transparent)
                              : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                          right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                        ),
                      ),
                      child: Container(
                        // width: 100,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 3,),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('checklist').doc(ChecklistController.to.id).snapshots(),
                                builder: (BuildContext context1, AsyncSnapshot<DocumentSnapshot> snapshot2) {
                                  if (!snapshot2.hasData) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                                  }

                                  if (snapshot2.data!.exists) {
                                    ChecklistController.to.getCheckCnt(ChecklistController.to.id);
                                    return InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        if (doc['name'] == '') {
                                          return;
                                        }
                                        if (snapshot2.data!['numArray'].contains(index + 1)) {
                                          ChecklistController.to.updNumArray(index+1, true);
                                        }else {
                                          ChecklistController.to.updNumArray(index+1, false);
                                        }

                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          Container(
                                            width: 19,
                                            child:
                                            CircleAvatar(
                                              backgroundColor: !snapshot2.data!['numArray'].contains(index + 1)
                                                  ? Colors.black.withOpacity(0.4)
                                                  : Colors.orange.withOpacity(0.7),
                                              child: Center(
                                                child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 65,
                                            child: Text(doc['name'], ),

                                          ),
                                        ],
                                      ),
                                    );
                                  }else {
                                    return SizedBox();
                                  }

                                }
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                );
              }
            ),
          ),
        ],
      ),
    ),
    );
  }

}




