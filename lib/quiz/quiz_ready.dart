import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QuizReady extends StatelessWidget {

  Stack buildCountDowntText(time) {
    if (time == '0') {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 400,
            child: Text('출발!', style: TextStyle(fontSize: 200, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              width: 400,
              child: Text('출발!', style: TextStyle(fontSize: 200, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }else {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 400,
            child: Text(time, style: TextStyle(fontSize: 200, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              width: 400,
              child: Text(time, style: TextStyle(fontSize: 200, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    /// 모둠때문에 추가
    QuizController.to.is_visible_count_down.value = false;

    /// 문제를 stream하지 않고 list에서 바로 부르기 위해
    QuizController.to.createQuestionList();

    /// 입장을 모두 false
    QuizController.to.updIsActiveFalse();
    return
      Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        // color: Color(0xFFF7F7F7),
        child:
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Container(
                  height: 40,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: QuizController.to.kDefaultRainbowColors,
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent
                  ),
                ),);
              }

              List docs = snapshot.data!.docs.toList();
              docs.sort((a,b)=> a['name'].compareTo(b['name']));
              List modum_docs = snapshot.data!.docs.where((doc) => doc['is_active'] == true).toList();
              modum_docs.sort((a,b)=> a['name'].compareTo(b['name']));

              return SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  // height: 500,

                  child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column(
                            //   children: [
                            //     Text('호세피나 앱을 설치하지 않은 경우 QR 코드를 사용하면 됩니다', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),),
                            //     QrImageView(
                            //       data: 'https://classdiary2.web.app/?paramClassCode=${GetStorage().read('class_code')}&paramEmail=${GetStorage().read('email')}'
                            //           '&paramQuizId=${QuizController.to.quiz_id}&paramIsRealName=yes&paramGubun=quiz&paramQuizType=${QuizController.to.quiz_quiz_type}'
                            //           '&paramTimer=${QuizController.to.quiz_indi_timer}&paramModumTotalTimer=${QuizController.to.quiz_modum_total_timer}&paramModumIndiTimer=${QuizController.to.quiz_modum_indi_timer}',
                            //       version: QrVersions.auto,
                            //       size: MediaQuery.of(context).size.width*0.4,
                            //     ),
                            //   ],
                            // ),
                            QuizController.to.quiz_quiz_type.value == '개인' ?
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              height: MediaQuery.of(context).size.height*0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 2 / 1.1,
                                    ),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc = docs[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Container(
                                          decoration: BoxDecoration(color: doc['is_active'] == true ? Colors.orange : Colors.grey, borderRadius: BorderRadius.circular(20),),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(doc['name'],  style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 30,),),
                                                ),
                                                SizedBox(width: 5,),
                                                doc['is_active'] == true ? Icon(Icons.circle_outlined, color: Colors.green, size: 35,) : Icon(Icons.clear, color: Colors.red, size: 35,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                    },

                                  ),
                                  /// 시작 버튼
                                  Container(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                                      onPressed: () async{
                                        QuizController.to.updQuestionState(0, 'ready');
                                        QuizController.to.is_visible_count_down.value = true;

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:20, right: 20, top: 20, bottom: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.play_circle, color: Colors.white, size: 30,),
                                            SizedBox(width: 10,),
                                            Text('시작',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) :
                            Container(  /// 모둠
                              width: MediaQuery.of(context).size.width*0.5,
                              height: MediaQuery.of(context).size.height*0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 2 / 2,
                                    ),
                                    itemCount: modum_docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc = modum_docs[index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                        Image.asset('assets/images/angry_bird_01.png', width: 200,),
                                        // Image.asset('assets/images/${QuizController.to.angry_birds[index]}.png', width: 200,),
                                        Text('${doc['name']}모둠', style: TextStyle(color: Colors.black, fontSize: 35, fontFamily: 'Jua'),),
                                      ],);
                                      // return Stack(
                                      //           children: [
                                      //             Image.asset('assets/images/rocket.png', width: 200,),
                                      //             // Image.asset('assets/images/rocket.png', width: 200,),
                                      //             Positioned(
                                      //               top: 45,
                                      //               left: 28,
                                      //               child: Text('${doc['name']}팀', style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'Jua'),),
                                      //               // child: Text(doc['name'].substring(doc['name'].length-2, doc['name'].length)+'팀', style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'Jua'),),
                                      //             ),
                                      //           ],
                                      //         );

                                    },

                                  ),
                                  Container(
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                                      onPressed: () async{
                                        if (QuizController.to.quiz_quiz_type.value == '개인') {
                                          QuizController.to.updQuestionState(0, 'ready');
                                        }else {
                                          QuizController.to.updQuestionStateModum('ready');
                                          // QuizController.to.updQuestionStateModum2();
                                        }

                                        QuizController.to.is_visible_count_down.value = true;

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:20, right: 20, top: 20, bottom: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.play_circle, color: Colors.white, size: 30,),
                                            SizedBox(width: 10,),
                                            Text('시작',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Obx(() => Visibility(
                          visible: QuizController.to.is_visible_count_down.value,
                          child: Positioned(
                            top: MediaQuery.of(context).size.height*0.3,
                            left: MediaQuery.of(context).size.width*0.4,
                            child: Countdown(
                              seconds: 3,
                              build: (BuildContext context, double time) {
                                return buildCountDowntText(time.toString());
                              },
                              interval: Duration(milliseconds: 1000),
                              onFinished: () async{
                                if (QuizController.to.quiz_quiz_type.value == '개인') {
                                  await QuizController.to.updQuestionState(0, 'active');
                                }else{
                                  await QuizController.to.updQuestionStateModum('active');
                                }

                                QuizController.to.is_visible_count_down.value = false;
                                QuizController.to.active_screen.value = 'play';
                              },
                            ),
                          ),
                        ),
                        ),
                      ]
                  ),
                ),
              );

            }
        ),
      );


  }

}






