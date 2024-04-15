import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/dashboard_controller.dart';
import '../controller/temper_controller.dart';

class Temperature2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('temper_point').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
              // TemperController.to.award_list = snapshot.data!.docs.toList();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 오른쪽 보상 리스트
                  Column(
                    children: [
                      SizedBox(height: 43,),
                      Container(
                        width: 100,
                        // color: Colors.blue,
                        child: ListView.builder(
                          reverse: true,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            String award_title = '';
                            switch (index) {
                              case 0:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 2).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 2).first['award_title'];
                                }
                                break;
                              case 1:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 4).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 4).first['award_title'];
                                }
                                break;
                              case 2:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 6).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 6).first['award_title'];
                                }
                                break;
                              case 3:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 8).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 8).first['award_title'];
                                }
                                break;
                              case 4:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 10).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 10).first['award_title'];
                                }
                                break;
                              case 5:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 12).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 12).first['award_title'];
                                }
                                break;
                              case 6:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 14).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 14).first['award_title'];
                                }
                                break;
                              case 7:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 16).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 16).first['award_title'];
                                }
                                break;
                            // case 8:
                            //   if (TemperController.to.award_list.where((doc) => doc['award_number'] == 18).length > 0) {
                            //     award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 18).first['award_title'];
                            //   }
                            //   break;
                            }
                            if (award_title.length > 0) {
                              return Bubble(
                                margin: BubbleEdges.only(bottom: 24),
                                nip: BubbleNip.rightTop,
                                color: Colors.teal,
                                child: Text(award_title, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                              );
                            }else {
                              return Bubble(
                                margin: BubbleEdges.only(bottom: 24),
                                nip: BubbleNip.rightTop,
                                borderColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                color: Colors.transparent,
                                child: Text(award_title, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                              );
                            }

                          },

                        ),
                      ),
                      SizedBox(height: 52,),
                      GestureDetector(
                        onTap: () {
                          TemperController.to.removePoint();
                        },
                        child: Icon(Icons.remove_circle, color: Colors.white, size: 50,),
                      )
                    ],
                  ),
                  /// 온도계 이미지 와 구슬들
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Image.asset('assets/images/temper.png', height: 650,),
                      Image.asset('assets/images/temper.png', height: MediaQuery.of(context).size.height*0.8,),
                      Column(
                        children: [
                          SizedBox(height: 30,),
                          Container(
                            // color: Colors.blue,
                            width: 120,
                            height: 475,
                            // child: ListView.builder(
                            child: GridView.builder(
                              // reverse: true,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
                              ),
                              itemCount: 80,
                              itemBuilder: (context, index) {
                                if (snapshot.data!.docs.length > 0) {
                                  if ((81-(index+1)) <= snapshot.data!.docs.first['point']) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                      child: CircleAvatar(radius: 200, backgroundColor: Colors.redAccent,),
                                    );
                                  }else {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                      child: CircleAvatar(radius: 200, backgroundColor: Colors.redAccent.withOpacity(0.1),),
                                    );
                                  }
                                }else {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                    child: CircleAvatar(radius: 200, backgroundColor: Colors.redAccent.withOpacity(0.1),),
                                  );
                                }


                              },
                            ),
                          ),

                        ],
                      ),
                    ],),
                  /// 왼쪽 보상 리스트
                  Column(
                    children: [
                      SizedBox(height: 74,),
                      Container(
                        width: 100,
                        // color: Colors.blue,
                        child: ListView.builder(
                          reverse: true,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            String award_title = '';
                            switch (index) {
                              case 0:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 1).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 1).first['award_title'];
                                }
                                break;
                              case 1:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 3).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 3).first['award_title'];
                                }
                                break;
                              case 2:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 5).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 5).first['award_title'];
                                }
                                break;
                              case 3:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 7).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 7).first['award_title'];
                                }
                                break;
                              case 4:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 9).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 9).first['award_title'];
                                }
                                break;
                              case 5:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 11).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 11).first['award_title'];
                                }
                                break;
                              case 6:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 13).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 13).first['award_title'];
                                }
                                break;
                              case 7:
                                if (TemperController.to.award_list.where((doc) => doc['award_number'] == 15).length > 0) {
                                  award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 15).first['award_title'];
                                }
                                break;
                            // case 8:
                            //   if (TemperController.to.award_list.where((doc) => doc['award_number'] == 17).length > 0) {
                            //     award_title = TemperController.to.award_list.where((doc) => doc['award_number'] == 17).first['award_title'];
                            //   }
                            //   break;
                            }


                            if (award_title.length > 0) {
                              return Bubble(
                                margin: BubbleEdges.only(bottom: 24),
                                nip: BubbleNip.leftTop,
                                color: Colors.teal,
                                child: Text(award_title, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                              );
                            }else {
                              return Bubble(
                                margin: BubbleEdges.only(bottom: 24),
                                nip: BubbleNip.leftTop,
                                borderColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                color: Colors.transparent,
                                child: Text(award_title, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                              );
                            }

                          },

                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          TemperController.to.addPoint();
                        },
                        child: Icon(Icons.add_circle, color: Colors.white, size: 50,),
                      )
                    ],
                  ),
                ],

              );
            }
        )
    );

  }
}


