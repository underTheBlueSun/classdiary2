import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizPlayMobile extends StatelessWidget {
  CustomPopupMenuController popup_create_question_controller = CustomPopupMenuController();

  Stack buildCountDowntText(time) {
    if (time == '0') {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 300,
            child: Text('출발!', style: TextStyle(fontSize: 150, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              width: 300,
              child: Text('출발!', style: TextStyle(fontSize: 150, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }else {
      return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: 200,
            child: Text(time, style: TextStyle(fontSize: 150, fontFamily: 'Jua',
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
              child: Text(time, style: TextStyle(fontSize: 150, fontFamily: 'Jua', color: Colors.orange,),)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: QuizController.to.quiz_class_code)
            .where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('state', isEqualTo: 'active').snapshots(),
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
          var score_doc;
          if (score_docs.length > 0) {
            score_doc = score_docs.last;
            // if (score_doc['state'] == 'active') {
            //   QuizController.to.is_visible_timer.value = true;
            // }

            DocumentSnapshot doc = QuizController.to.questions.where((doc) => doc['number'] == score_doc['question_number']).first  ;

            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Countdown(
                          seconds: int.parse(QuizController.to.quiz_indi_timer.value),
                          build: (BuildContext context, double time) {
                            QuizController.to.remain_time = time; /// 타이머 다 돌기전에 선택지 클릭시
                            return Container(
                                width: 50,
                                child: Text(time.toString() + '초', style: TextStyle(color: Colors.black,),),
                            );
                          },
                          interval: Duration(milliseconds: 1000),
                          onFinished: () {
                            QuizController.to.active_screen_mobile.value = 'score';
                            QuizController.to.number = doc['number'];
                            QuizController.to.answer.value = doc['answer'];
                          },
                        ),

                        SizedBox(height: 10,),
                        /// 질문
                        doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                            || doc['question'].contains('times') || doc['question'].contains('div') ?
                        TeXView(
                          child: TeXViewDocument(r'' + doc['question'].replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
                              .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)'),
                            style: TeXViewStyle(contentColor: Colors.black, fontStyle: TeXViewFontStyle(fontSize: 22), padding: TeXViewPadding.all(5), ),),
                          // style: TeXViewStyle(contentColor: Colors.black, fontStyle: TeXViewFontStyle(fontSize: 19), padding: TeXViewPadding.all(15), backgroundColor: Colors.white,),),
                        ) :
                        Text(doc['question'], style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Jua'),),

                        SizedBox(height: 10,),
                        /// 이미지
                        Visibility(
                          // visible: true,
                          visible: doc['question_image_url'].length > 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              // child: Image.asset('assets/images/quiz_background2.png', fit: BoxFit.cover, width: 400,),
                              child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 400,),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        /// 답지
                        InkWell(
                          onTap: () {
                            /// 버튼 연타때문에 async 뺌
                            QuizController.to.end_date = DateTime.now().toString();
                            QuizController.to.updUserScore('1', doc['answer']);
                            // await QuizController.to.updUserScore('1', doc['answer']);
                            QuizController.to.active_screen_mobile.value = 'score';
                            QuizController.to.number = doc['number'];
                            QuizController.to.answer.value = doc['answer'];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal, size: 30,) :
                                      doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) : SizedBox(),
                                      // doc['question_type'] == 'OX형' ? Icon(Icons.circle_outlined, color: Colors.teal, size: 30,) : SizedBox(),
                                      SizedBox(width: 10,),
                                      doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                          || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                      Math.tex(
                                        r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                            .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      ) :
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.75,
                                          child: Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                      // Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                        ),
                        SizedBox(height: 15,),
                        doc['question_type'] != '단답형' ?
                        InkWell(
                          onTap: () {
                            QuizController.to.end_date = DateTime.now().toString();
                            QuizController.to.updUserScore('2', doc['answer']);
                            QuizController.to.active_screen_mobile.value = 'score';
                            QuizController.to.number = doc['number'];
                            QuizController.to.answer.value = doc['answer'];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) :
                                      Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),),
                                      // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) : Icon(Icons.clear, color: Colors.red, size: 30,),
                                      SizedBox(width: 10,),
                                      doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                          || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                      Math.tex(
                                        r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                            .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      ) :
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.75,
                                          child: Text(doc['answer2'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                        ) : SizedBox(),
                        SizedBox(height: 15,),
                        doc['question_type'] == '선택형' ?
                        InkWell(
                          onTap: () {
                            QuizController.to.end_date = DateTime.now().toString();
                            QuizController.to.updUserScore('3', doc['answer']);
                            QuizController.to.active_screen_mobile.value = 'score';
                            QuizController.to.number = doc['number'];
                            QuizController.to.answer.value = doc['answer'];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_3, color: Colors.blue, size: 30,),
                                      SizedBox(width: 10,),
                                      doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                          || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                      Math.tex(
                                        r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                            .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      ) :
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.75,
                                          child: Text(doc['answer3'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                        ) : SizedBox(),
                        SizedBox(height: 15,),
                        doc['question_type'] == '선택형' ?
                        InkWell(
                          onTap: () {
                            QuizController.to.end_date = DateTime.now().toString();
                            QuizController.to.updUserScore('4', doc['answer']);
                            QuizController.to.active_screen_mobile.value = 'score';
                            QuizController.to.number = doc['number'];
                            QuizController.to.answer.value = doc['answer'];
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_4, color: Colors.orange, size: 30,),
                                      SizedBox(width: 10,),
                                      doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                          || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                      Math.tex(
                                        r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                            .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                      ) :
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.75,
                                          child: Text(doc['answer4'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                        ) : SizedBox(),
                        SizedBox(height: 15,),
                      ],),
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
                      // QuizController.to.updQuestionState(doc['number'], 'active');
                      // QuizController.to.is_visible_count_down.value = false;
                    },
                  ),
                ),
                ),
              ],);

          }else {
            return SizedBox();
          }




        }
    );
  }
}


