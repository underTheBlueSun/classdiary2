import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/point_controller.dart';
import '../controller/signinup_controller.dart';
import 'package:get/get.dart';


class Point extends StatelessWidget {

  List popUpController_list = [CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),
    CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),
    CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),
    CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController(),CustomPopupMenuController()
  ];

  CustomPopupMenuController all_point_popUpController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     InkWell(
            //       highlightColor: Colors.transparent,
            //       hoverColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       onTap: () {
            //
            //         PointController.to.delAllPoint();
            //       },
            //       child: Container(
            //         padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            //         decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
            //         child: Row(
            //           children: [
            //             Text('전체', style: TextStyle(color: Colors.white, fontSize: 20),),
            //             SizedBox(width: 2,),
            //             Icon(Icons.remove_circle, color: Colors.white, size: 25,),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 15,),
            //     InkWell(
            //       highlightColor: Colors.transparent,
            //       hoverColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       onTap: () {
            //
            //         PointController.to.addAllPoint();
            //       },
            //       child: Container(
            //         // margin: EdgeInsets.all(4),
            //         padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            //         decoration: BoxDecoration(
            //             color: Colors.blueAccent,
            //             borderRadius: BorderRadius.circular(10)
            //         ),
            //         child: Row(
            //           children: [
            //             Text('전체', style: TextStyle(color: Colors.white, fontSize: 20),),
            //             SizedBox(width: 2,),
            //             Icon(Icons.add_circle, color: Colors.white, size: 25,),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 35,),
            //   ],
            // ),
            SizedBox(height: 10,),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                height: 100,  /// 높이 지정
              ),
              itemCount: AttendanceController.to.attendanceDocs.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomPopupMenu(
                    arrowColor: Colors.white,
                    // arrowColor: SignInUpController.to.isDarkMode.value == true ?  Color(0xFF4C4C4C) : Color(0xFFB2B2B2),
                    controller: popUpController_list[AttendanceController.to.attendanceDocs[index]['number']],
                    arrowSize: 20,
                    menuOnChange: (bool) {
                      PointController.to.point_input.value = '';
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(15)),),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(width: 10,),
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                radius: 13,
                                child: Text(AttendanceController.to.attendanceDocs[index]['number'].toString(), style: TextStyle(color: Colors.white),),
                              ),
                              SizedBox(width: 10,),
                              Text(AttendanceController.to.attendanceDocs[index]['name'],
                                style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black.withOpacity(0.5), fontFamily: 'Jua', fontSize: 20),),
                            ],
                            ),

                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                              .where('number', isEqualTo: AttendanceController.to.attendanceDocs[index]['number']).snapshots(),
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
                            }
                            int diary_point = 0;
                            int point_point = 0;
                            int coupon_point = 0;
                            int temper_point = 0;
                            int total_point = 0;

                            snapshot.data!.docs.forEach((doc) {
                              if(doc['checklist_01'] > 0) diary_point = diary_point + doc['checklist_01'] as int;
                              if(doc['checklist_02'] > 0) diary_point = diary_point + doc['checklist_02'] as int;
                              if(doc['checklist_03'] > 0) diary_point = diary_point + doc['checklist_03'] as int;
                              if(doc['checklist_04'] > 0) diary_point = diary_point + doc['checklist_04'] as int;
                              if(doc['checklist_05'] > 0) diary_point = diary_point + doc['checklist_05'] as int;
                              if(doc['checklist_06'] > 0) diary_point = diary_point + doc['checklist_06'] as int;
                              if(doc['checklist_07'] > 0) diary_point = diary_point + doc['checklist_07'] as int;
                              if(doc['checklist_08'] > 0) diary_point = diary_point + doc['checklist_08'] as int;
                              if(doc['checklist_09'] > 0) diary_point = diary_point + doc['checklist_09'] as int;
                              if(doc['checklist_10'] > 0) diary_point = diary_point + doc['checklist_10'] as int;

                            });


                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                    .where('number', isEqualTo: AttendanceController.to.attendanceDocs[index]['number']).snapshots(),
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
                                  }

                                  point_point = 0;
                                  if (snapshot.data!.docs.length > 0) {
                                    point_point = snapshot.data!.docs.first['point'];
                                  }

                                  return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('coupon_buy').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                          .where('number', isEqualTo: AttendanceController.to.attendanceDocs[index]['number']).snapshots(),
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
                                        }

                                        coupon_point = 0;
                                        snapshot.data!.docs.forEach((doc) {
                                          coupon_point = coupon_point + doc['point'] as int;
                                        });
                                        
                                        return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance.collection('temper_donation').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                                .where('number', isEqualTo: AttendanceController.to.attendanceDocs[index]['number']).snapshots(),
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
                                              }

                                              temper_point = 0;
                                              snapshot.data!.docs.forEach((doc) {
                                                temper_point = temper_point + doc['point'] as int;
                                              });
                                              
                                              total_point = diary_point + point_point - coupon_point - temper_point;

                                              return Row(children: [
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          width: 150,
                                                          child: Text(total_point.toString(), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),),
                                                        ),
                                                        SizedBox(width: 20,),


                                                      ],);
                                            }
                                        );
                                      }
                                  );
                                }
                            );

                          }
                      ),

                          ],
                        ),
                      ),
                    ),
                    menuBuilder: () => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SingleChildScrollView(
                        child: Container(
                          width: 350,
                          height: 400,
                          // color: Color(0xFFB2B2B2),
                          color: Colors.white,
                          // color: SignInUpController.to.isDarkMode.value == true ?  Color(0xFF4C4C4C) : Color(0xFFB2B2B2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  /// 1,2,3,4점
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int i = 1; i < 5; i++)
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            PointController.to.point_input.value = i.toString();
                                          },
                                          child: Container(
                                            width: 65,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                              child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                            ),
                                          ),
                                        ),

                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  /// 5,10,15,20점
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int i = 5; i < 25; i=i+5)
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          PointController.to.point_input.value = i.toString();
                                        },
                                        child: Container(
                                          width: 65,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                            child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  /// 25,30,35,40점
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int i = 25; i < 45; i=i+5)
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            PointController.to.point_input.value = i.toString();
                                          },
                                          child: Container(
                                            width: 65,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                              child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                            ),
                                          ),
                                        ),

                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Obx(() =>
                                Text(PointController.to.point_input.value, style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.orange),)
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                height: 60,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    // controller: textfield_controller,
                                    // controller: TextEditingController(text: PointController.to.point_input.value.toString()),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    cursorColor: Colors.black,
                                    autofocus: true,
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (value) {
                                      PointController.to.point_input.value = value;
                                    },
                                    style: TextStyle(color: Colors.black , fontSize: 25, ),
                                    // style: TextStyle(color: Colors.white , fontSize: 16, ),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '직접 점수 입력',
                                      hintStyle: TextStyle(fontSize: 18, color: Colors.grey.withOpacity(0.5)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey,  ),),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey,  ),),
                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /// 차감, 추가 버튼
                              Row(
                                children: [
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    PointController.to.delPoint(AttendanceController.to.attendanceDocs[index]['number'], AttendanceController.to.attendanceDocs[index]['name']);
                                    popUpController_list[AttendanceController.to.attendanceDocs[index]['number']].hideMenu();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 350/2,
                                    height: 65,
                                    color: Colors.redAccent.withOpacity(0.8),
                                    child: Text('차감', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white),),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    PointController.to.addPoint(AttendanceController.to.attendanceDocs[index]['number'], AttendanceController.to.attendanceDocs[index]['name']);
                                    popUpController_list[AttendanceController.to.attendanceDocs[index]['number']].hideMenu();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 350/2,
                                    height: 65,
                                    color: Colors.blueAccent.withOpacity(0.8),
                                    child: Text('추가', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white),),
                                  ),
                                ),
                              ],),

                              // child: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       InkWell(
                              //         highlightColor: Colors.transparent,
                              //         hoverColor: Colors.transparent,
                              //         splashColor: Colors.transparent,
                              //         onTap: () {
                              //           // PointController.to.point_input.value = i;
                              //         },
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Container(
                              //             width: 60,
                              //             alignment: Alignment.center,
                              //             decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              //               child: Text('차감', style: TextStyle(color: Colors.white, fontSize: 18),),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //         InkWell(
                              //           highlightColor: Colors.transparent,
                              //           hoverColor: Colors.transparent,
                              //           splashColor: Colors.transparent,
                              //           onTap: () {
                              //             // PointController.to.point_input.value = i;
                              //           },
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Container(
                              //               width: 60,
                              //               alignment: Alignment.center,
                              //               decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              //                 child: Text('추가', style: TextStyle(color: Colors.white, fontSize: 18),),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //
                              //     ],
                              //   ),
                              // ),
                          ],),
                        ),
                      ),
                    ),
                    pressType: PressType.singleClick,
                    verticalMargin: -10,

                  ),
                );

              },
            ),
          ],
        ),
    );

  }
}


