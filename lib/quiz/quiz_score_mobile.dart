import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class QuizScoreMobile extends StatelessWidget {

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
    /// 타이머 다 돌기전에 클릭시
    Future.delayed( Duration(milliseconds: QuizController.to.remain_time.toInt()*1000 + 1000), () async{ // 1초정도 더 늦게 결과값 받아오는게 안전하지않을까 싶어서
      await QuizController.to.scoreQuestion(QuizController.to.number, QuizController.to.answer.value);
      await QuizController.to.scoreTotal();
      await QuizController.to.scoreMobile();
      QuizController.to.is_visible_score.value = true;
    });

    return
      MediaQuery.of(context).size.width < 600 ?
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
                QuizController.to.is_visible_count_down.value = true;
              }
            }

            return Obx(() => Center(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    QuizController.to.is_visible_score.value == false ?
                    Column(
                      children: [
                        Text('문제 풀이시간이 아직 끝나지 않았습니다.', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                        SizedBox(height: 10,),
                        Text('잠시 기다려주세요', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                        SizedBox(height: 30,),
                        Container(
                          height: 40,
                          child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              colors: QuizController.to.kDefaultRainbowColors,
                              strokeWidth: 2,
                              backgroundColor: Colors.transparent,
                              pathBackgroundColor: Colors.transparent
                          ),
                        ),
                      ],
                    ) :
                    Column(
                      children: [
                        QuizController.to.correct == 'O' ?
                        Column(
                          children: [
                            Image.asset('assets/images/marie_02.png', width: 100,),
                            SizedBox(height: 30,),
                            Text('정답입니다', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 40),),
                          ],
                        ) :
                        Column(
                          children: [
                            Image.asset('assets/images/marie_01.png', width: 100,),
                            SizedBox(height: 30,),
                            Text('오답입니다', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 40),),
                          ],
                        ),
                        // Text('정답입니다', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 40),) :
                        // Text('오답입니다', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 40),),
                        SizedBox(height: 10,),
                        Divider(color: Colors.grey,),
                        SizedBox(height: 20,),
                        Text('나의 ${QuizController.to.number}번 문제 순위', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                        Text(QuizController.to.rank_question_index == -1 ?
                        QuizController.to.score_question_list.length.toString() + '/' + QuizController.to.score_question_list.length.toString() :
                        QuizController.to.rank_question_index.toString() + '/' + QuizController.to.score_question_list.length.toString(),
                          style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 30),),
                        SizedBox(height: 20,),
                        Text('나의 전체 순위', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                        Text(QuizController.to.rank_tatal_index.toString() + '/' + QuizController.to.total_list.length.toString(), style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 30),),
                      ],
                    ),
                    SizedBox(height: 15,),
                    // Obx(() => Visibility(
                    //   visible: QuizController.to.is_visible_score.value,
                    //   child: Text(QuizController.to.aaa),
                    // ),
                    // ),
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
                          QuizController.to.is_visible_score.value = false;

                        },
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            );


          }
      ) :
      Container(
        child: Text('태블릿 대기화면'),
      );

  }

}






