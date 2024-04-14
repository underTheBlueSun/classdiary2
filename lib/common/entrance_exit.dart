import 'package:classdiary2/controller/class_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/attendance_controller.dart';
import '../controller/board_controller.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;


class EntranceExit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500, height: 700,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Container(
                height: 40,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: BoardController.to.kDefaultRainbowColors,
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.transparent
                ),
              ),);
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Container(
                  width: 500, height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF4C4C4C),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Container(
                            width: 500,
                            child: Center(child: Text('출석부가 존재하지 않습니다', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.orangeAccent),))),
                        SizedBox(height: 25,),
                        Text('(추측1) 링크주소가 잘못되었다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
                        SizedBox(height: 15,),
                        Text('(추측2) 선생님이 출석부를 아직 만들지 않으셨다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              );
            }else{
              // List attendanceList = snapshot.data!.docs.first['attendance'];
              // attendanceList.sort((a, b) => a['number'].compareTo(b['number']));
              List attendanceList = AttendanceController.to.attendanceList;
              List visitList = snapshot.data!.docs.first['visit'];
              return
                SingleChildScrollView(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                      childAspectRatio: 5 / 1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: attendanceList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                                || index + 1 == AttendanceController.to.attendanceCnt.value
                                ? BorderSide(width: 1, color: Colors.transparent,)
                                : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                            right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                child:
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Jua',),),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18,),),
                              Spacer(),
                              visitList.any((e) => mapEquals(e, attendanceList[index])) ?
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,),
                                  onPressed: () {
                                    ClassController.to.exitClassByTeacher(attendanceList[index]['number'], attendanceList[index]['name'], snapshot.data!.docs.first.id);
                                  }, // onPressed
                                  child: Text('퇴장', style: TextStyle(color: Colors.white),),
                                ),
                              ) :
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text('입장안함', style: TextStyle(color: Colors.grey, fontSize: 12),),
                              ),
                            ],
                          ),
                        ),
                      );

                    },

                  ),
                  // child: ListView.separated(
                  //   primary: false,
                  //   shrinkWrap: true,
                  //   // padding: const EdgeInsets.all(10),
                  //   itemCount: attendanceList.length,
                  //   itemBuilder: (context, index) {
                  //     /// visitList.contains(attendanceList[index]), visitList.contains({'number': 2, 'name': '강현우'}) 이거 안됨
                  //     return
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Container(
                  //           width: 20,
                  //           child:
                  //           CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Jua',),),
                  //           ),
                  //         ),
                  //         SizedBox(width: 20,),
                  //         Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18,),),
                  //         SizedBox(width: 50,),
                  //         visitList.any((e) => mapEquals(e, attendanceList[index])) ?
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             ClassController.to.exitClassByTeacher(attendanceList[index]['number'], attendanceList[index]['name']);
                  //           }, // onPressed
                  //           child: Text('퇴장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                  //         ) :
                  //             SizedBox(),
                  //       ],
                  //     );
                  //   },
                  //   separatorBuilder: (BuildContext context, int index) => const Divider(),
                  // ),
                );
            }

          }
      ),
    );
  }
}


