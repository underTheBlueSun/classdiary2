import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/quiz/quiz_add_question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'quiz_upd_question.dart';

class QuizDetail extends StatelessWidget {
  CustomPopupMenuController popup_create_question_controller = CustomPopupMenuController();


  void createQustionDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SingleChildScrollView(
            child: Container(
              width: 1000,
              // height: MediaQuery.of(context).size.height*0.8,
              // color: Color(0xFF4C4C4C),
              child: QuizAddQuestion(),
            ),
          ),
        );
      },
    );

  }

  void updQustionDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SingleChildScrollView(
            child: Container(
              width: 1000,
              // width: 700,
              // height: MediaQuery.of(context).size.height*0.8,
              // color: Color(0xFF4C4C4C),
              child: QuizUpdQuestion(),
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 왼쪽
        Container(
          // width: 280,
          width: MediaQuery.of(context).size.width*0.15,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.5),width: 2,),), ),
          child: Column(children: [
            /// 문제만들기
            QuizController.to.class_code == GetStorage().read('class_code') ?
            Container(
              width: 184, // 2048/0.09 = 184.32,
              // width: MediaQuery.of(context).size.width*0.09,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xff76B8C3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                onPressed: () {
                  createQustionDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
                  child: Row(
                    children: [
                      Icon(Icons.wechat_rounded, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('문제 만들기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ) : SizedBox(),
            SizedBox(height: 15,),
            Container(
              // width: 245,
              width: MediaQuery.of(context).size.width*0.14,
              height: 600,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1,),),
              // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1,),),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  /// 제목
                  Container(
                    // width: 205,
                    width: MediaQuery.of(context).size.width*0.13,
                    height: 80,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(QuizController.to.quiz_title, style: TextStyle(fontSize: 13,),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  /// 설명
                  Container(
                    // width: 205, // 2048/0.1 = 204.8,
                    width: MediaQuery.of(context).size.width*0.13,
                    height: 150,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(QuizController.to.quiz_description, style: TextStyle(fontSize: 13,),),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  /// 학년,학기,과목
                  Container(
                    // width: 205, // 2048/0.1 = 204.8,
                    width: MediaQuery.of(context).size.width*0.13,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(QuizController.to.quiz_grade.value + ' / ' + QuizController.to.quiz_semester.value + ' / ' +
                          QuizController.to.quiz_subject.value, style: TextStyle(fontSize: 13,),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  /// 퀴즈유형
                  Container(
                    width: MediaQuery.of(context).size.width*0.13,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('퀴즈유형 : ', style: TextStyle(fontSize: 13,),),
                        SizedBox(width: 10,),
                        Text(QuizController.to.quiz_quiz_type.value, style: TextStyle( fontSize: 13,),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  QuizController.to.quiz_quiz_type.value == '개인' ?
                  Column(children: [
                    /// 문제당 시간
                    Container(
                      // width: 205, // 2048/0.1 = 204.8,
                      width: MediaQuery.of(context).size.width*0.13,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          // Icon(Icons.access_time, color: Colors.black),
                          Text('문제당 시간(초) : ', style: TextStyle( fontSize: 13,),),
                          SizedBox(width: 10,),
                          Text(QuizController.to.quiz_indi_timer.value == 'X' ? '시간제한 없음' : QuizController.to.quiz_indi_timer.value + '초', style: TextStyle(fontSize: 13,),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],) :
                  Column(children: [
                    /// 퀴즈 총시간
                    // Container(
                    //   width: MediaQuery.of(context).size.width*0.13,
                    //   height: 40,
                    //   decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
                    //   child: Row(
                    //     children: [
                    //       SizedBox(width: 10,),
                    //       // Icon(Icons.access_time, color: Colors.black),
                    //       Text('퀴즈 총시간 : ', style: TextStyle(color: Colors.black, fontSize: 13,),),
                    //       SizedBox(width: 10,),
                    //       Text(QuizController.to.quiz_modum_total_timer.value + '분', style: TextStyle(color: Colors.black, fontSize: 13,),),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 15,),
                    /// 개인당 시간
                    Container(
                      width: MediaQuery.of(context).size.width*0.13,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          // Icon(Icons.access_time, color: Colors.black),
                          Text('개인당 시간 : ', style: TextStyle( fontSize: 13,),),
                          SizedBox(width: 10,),
                          Text(QuizController.to.quiz_modum_indi_timer.value + '초', style: TextStyle( fontSize: 13,),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],),
                  /// 공개여부
                  Container(
                    // width: 205, // 2048/0.1 = 204.8,
                    width: MediaQuery.of(context).size.width*0.13,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.share, ),
                        SizedBox(width: 10,),
                        Text(QuizController.to.quiz_public_type.value, style: TextStyle( fontSize: 13,),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],),
        ),
        /// 오른쪽
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: QuizController.to.quiz_id).snapshots(),
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
              docs.sort((a,b)=> a['date'].compareTo(b['date']));
              return Flexible(
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width > 1700 ? 2/1 : 2/1.5,
                    // childAspectRatio: MediaQuery.of(context).size.width > 1800 ? 2/1 : 2/1.5,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.85/2,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1,),),
                        // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                        //   border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1,),
                        //   boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 3, offset: Offset(1, 1),)],
                        // ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 19,
                                            child:
                                            CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Center(
                                                child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          /// 질문
                                          doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                                              || doc['question'].contains('times') || doc['question'].contains('div') ?
                                          (doc['question'].contains('\n') || doc['question'].contains('. ')) ?
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                for (int index = 0; index < doc['question'].split('\n').length; index++)
                                                  for (int index2 = 0; index2 < doc['question'].split('\n')[index].split('. ').length; index2++)
                                                    Math.tex(
                                                      r'' + doc['question'].split('\n')[index].split('. ')[index2].replaceAll('/', r'\over').replaceAll(' ', r'\space')
                                                          .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', r'\times').replaceAll('div', '÷') + r'',
                                                          // .replaceAll('^2', r'{^2}').replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                                          // .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}') + r'',
                                                      mathStyle: MathStyle.display,
                                                      textStyle: TextStyle(fontSize: 17, ),
                                                    ),

                                                  /// 모바일은 TeXView 사용. 왜냐 TeXView는 한 화면에 여러개 사용하면 꼬임. 근데 TeXView는 자동으로 줄바꿔주어서 좋음(안드는 안되서 사용안함)
                                                  // Math.tex(
                                                  //   r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                  //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                  //   mathStyle: MathStyle.display,
                                                  //   textStyle: TextStyle(fontSize: 17, color: Colors.black),
                                                  // ),
                                              ],
                                            ),
                                          ) :
                                          Container(
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Math.tex(
                                                r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                    .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}')
                                                    // .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                                    + r'',
                                                    // .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}')+ r'',
                                                mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 17, ),
                                              ),
                                            ),
                                          ):
                                          Container(
                                              width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                              child: Text(doc['question'], style: TextStyle(fontFamily: 'NanumGothic',  fontSize: 17,  ),),
                                          ),

                                        ],
                                      ),
                                    ),
                                    /// 답지
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: doc['question_type'] == '단답형' ?
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.25,
                                                child: Text(doc['answer'], style: TextStyle(fontSize: 15,  ),),
                                              ) :
                                              Row(
                                                children: [
                                                  doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal,) :
                                                  doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),) : SizedBox(),
                                                  SizedBox(width: 10,),
                                                  doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                                      || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                                  Math.tex(
                                                    r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                        .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 16, ),
                                                  ) :
                                                  Container(
                                                    width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
                                                    child: Text(doc['answer1'], style: TextStyle(fontSize: 15,  ),),
                                                  ),
                                                  Spacer(),
                                                  doc['answer'] == '1' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                                ],
                                              )
                                            ),
                                          ),
                                        ],),
                                    ),
                                    doc['question_type'] != '단답형' ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) :
                                                  Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                                  // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) : Icon(Icons.clear  , color: Colors.red,),
                                                  SizedBox(width: 10,),
                                                  doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                                      || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                                  Math.tex(
                                                    r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                        .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 16, ),
                                                  ) :
                                                  Container(
                                                    width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
                                                    child: Text(doc['answer2'], style: TextStyle(fontSize: 15,  ),),
                                                  ),
                                                  Spacer(),
                                                  doc['answer'] == '2' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],),
                                    ) : SizedBox(),
                                    doc['question_type'] == '선택형' ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.filter_3, color: Colors.blue,),
                                                  SizedBox(width: 10,),
                                                  doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                                      || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                                  Math.tex(
                                                    r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                        .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 16, ),
                                                  ) :
                                                  Container(
                                                      width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
                                                      child: Text(doc['answer3'], style: TextStyle(fontSize: 15,  ),)),
                                                  Spacer(),
                                                  doc['answer'] == '3' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],),
                                    ) : SizedBox(),
                                    doc['question_type'] == '선택형' ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.filter_4, color: Colors.orange,),
                                                  SizedBox(width: 10,),
                                                  doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                                      || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                                  Math.tex(
                                                    r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                        .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 16, ),
                                                  ) :
                                                  Container(
                                                      width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
                                                      child: Text(doc['answer4'], style: TextStyle(fontSize: 15,  ),)),
                                                  Spacer(),
                                                  doc['answer'] == '4' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],),
                                    ) : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: doc['question_image_url'].length > 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 180,),
                                ),
                              ),
                            ),
                            /// 편집,삭제 버튼
                            QuizController.to.class_code == GetStorage().read('class_code') ?
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.5),width: 1,),), ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      QuizController.to.question_id = doc.id;
                                      QuizController.to.question.value = doc['question'];
                                      QuizController.to.answer1.value = doc['answer1'];
                                      QuizController.to.answer2.value = doc['answer2'];
                                      QuizController.to.answer3.value = doc['answer3'];
                                      QuizController.to.answer4.value = doc['answer4'];
                                      QuizController.to.answer.value = doc['answer'];
                                      QuizController.to.question_image_url.value = doc['question_image_url'];
                                      QuizController.to.answer1_image_url = doc['answer1_image_url'];
                                      QuizController.to.answer2_image_url = doc['answer2_image_url'];
                                      QuizController.to.answer3_image_url = doc['answer3_image_url'];
                                      QuizController.to.answer4_image_url = doc['answer4_image_url'];
                                      QuizController.to.question_type.value = doc['question_type'];

                                      /// quiz_upd_question에서 visibility에 띄우기 위해
                                      QuizController.to.question_tex.value = r'' + QuizController.to.question.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                          .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'';

                                      updQustionDialog(context);
                                    },
                                    child: SizedBox(
                                        width: 50, height: 50,
                                        child: Icon(Icons.edit, )),
                                  ),
                                  Divider(color: Colors.grey.withOpacity(0.5),thickness: 1,),
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      QuizController.to.delQuestion(doc);
                                    },
                                    child: SizedBox(
                                        width: 50, height: 50,
                                        child: Icon(Icons.delete_forever, )),
                                  ),
                                ],
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                    );

                  },

                ),
              );

            }
        ),

      ],
    );

  }
}


