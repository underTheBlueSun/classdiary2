import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class QuizReadyMobile extends StatelessWidget {

  Stack buildCountDowntText(time) {
    if (time == '0') {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 200,
            child: Text('출발!', style: TextStyle(fontSize: 100, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              width: 200,
              child: Text('출발!', style: TextStyle(fontSize: 100, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }else {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 200,
            child: Text(time, style: TextStyle(fontSize: 100, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              width: 200,
              child: Text(time, style: TextStyle(fontSize: 100, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 문제를 stream하지 않고 list에서 바로 부르기 위해
    QuizController.to.createQuestionList();
    /// 입장하면 true
    QuizController.to.updIsActiveTrue();

    return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: QuizController.to.quiz_class_code)
              .where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('state', isEqualTo: 'ready').snapshots(),
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
            List score_docs = snapshot.data!.docs.toList();
            score_docs.sort((a,b)=> a['question_number'].compareTo(b['question_number']));
            if (score_docs.length > 0) {
              DocumentSnapshot score_doc = score_docs.last;
              QuizController.to.score_doc_id = score_doc.id;  /// updUserScore() 에 사용
              if (score_doc['state'] == 'ready') {
                QuizController.to.is_visible_loading.value = false;
                QuizController.to.is_visible_count_down.value = true;
              }
            }

            return Center(
              child: Column(
                children: [
                  SizedBox(height: 80,),
                  Image.asset('assets/images/quiz_logo.png', fit: BoxFit.cover, width: 200,),
                  SizedBox(height: 50,),
                  Text('대기중...', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                  SizedBox(height: 5,),
                  Text('모두가 입장할 때까지\n잠시 기다려주세요.', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                  SizedBox(height: 15,),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_loading.value,
                    child: Container(
                      height: 40,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: QuizController.to.kDefaultRainbowColors,
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.transparent
                      ),
                    ),
                  ),
                  ),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_count_down.value,
                    child: Countdown(
                      seconds: 3,
                      build: (BuildContext context, double time) {
                        return buildCountDowntText(time.toString());
                      },
                      interval: Duration(milliseconds: 1000),
                      onFinished: () {
                        QuizController.to.is_visible_count_down.value = false;
                        QuizController.to.active_screen_mobile.value = 'active';
                        QuizController.to.start_date = DateTime.now().toString();
                      },
                    ),
                  ),
                  ),
                ],
              ),
            );


          }
      );

  }

}






