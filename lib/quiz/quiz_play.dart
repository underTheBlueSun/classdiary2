import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizPlay extends StatelessWidget {
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

  Stack buildTimerText(time) {
    return Stack(
      children: <Widget>[
        Text(time, style: TextStyle(fontSize: 60, fontFamily: 'Jua',
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.black.withOpacity(0.5),
        ),
        ),
        Text(time, style: TextStyle(fontSize: 60, fontFamily: 'Jua', color: Colors.yellow.withOpacity(0.5),),),
      ],
    );
  }

  void scoreDialog(context, number) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 25,  color: Colors.white, ),),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.9,
              color: Color(0xFF4C4C4C),
              child: Row(
                children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${number}번 문제 순위', style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 40),),
                        SizedBox(height: 20,),
                        Row(children: [
                          Container(
                              width: 60,
                              child: Text('순위', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Container(
                              width: 250,
                              child: Text('이름', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Container(
                            alignment: Alignment.center,
                              width: 100,
                              child: Text('정답', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Text('푼시간', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),),
                        ],),
                        Flexible(
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: QuizController.to.score_question_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(children: [
                                Container(
                                  width: 60,
                                  child:
                                  CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    child: Text((index+1).toString(), style: TextStyle(color: Colors.white, fontSize: 30,),),
                                  ),
                                ),
                                SizedBox(width: 50,),
                                Container(
                                    // alignment: Alignment.center,
                                    width: 250,
                                    child: Text(QuizController.to.score_question_list[index]['name'], style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),)),
                                SizedBox(width: 50,),
                                QuizController.to.score_question_list[index]['score'] == 1 ?
                                // QuizController.to.score_question_list[index]['correct'] == 'O' ?
                                Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    child: Icon(Icons.circle_outlined, color: Colors.green, size: 40,)) :
                                Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    child: Icon(Icons.clear, color: Colors.red, size: 40,)),
                                SizedBox(width: 50,),
                                Text('${QuizController.to.score_question_list[index]['time'].substring(5,7)}초 ${QuizController.to.score_question_list[index]['time'].substring(8,11)}',
                                  style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),),
                              ],);
                            },
                            //  Divider 로 구분자 추가.
                            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.white.withOpacity(0.5),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(QuizController.to.total_list[0]['name'], style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 40),),
                        // Text(QuizController.to.total_list[0]['score'].toString(), style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 40),),
                        // Text(QuizController.to.total_list[0]['time'].toString(), style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 40),),
                        Text('전체 순위', style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 40),),
                        SizedBox(height: 20,),
                        Row(children: [
                          Container(
                              width: 60,
                              child: Text('순위', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Container(
                              // alignment: Alignment.center,
                              width: 250,
                              child: Text('이름', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Container(
                              alignment: Alignment.center,
                              width: 100,
                              child: Text('맞춘갯수', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),)),
                          SizedBox(width: 50,),
                          Text('푼시간', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 30),),
                        ],),
                        Flexible(
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: QuizController.to.total_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(children: [
                                Container(
                                  width: 60,
                                  child:
                                  CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    child: Text((index+1).toString(), style: TextStyle(color: Colors.white, fontSize: 30,),),
                                  ),
                                ),
                                SizedBox(width: 50,),
                                Container(
                                    // alignment: Alignment.center,
                                    width: 250,
                                    child: Text(QuizController.to.total_list[index]['name'], overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),)),
                                SizedBox(width: 50,),
                                Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    child: Text(QuizController.to.total_list[index]['score'].toString(), style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),)),
                                SizedBox(width: 50,),
                                QuizController.to.total_list[index]['time'].toString().substring(QuizController.to.total_list[index]['time'].toString().indexOf('.')+1).length > 4 ?
                                Text('${QuizController.to.total_list[index]['time'].toString().substring(0, QuizController.to.total_list[index]['time'].toString().indexOf('.'))}초 '
                                    '${QuizController.to.total_list[index]['time'].toString().substring(QuizController.to.total_list[index]['time'].toString().indexOf('.')+1,
                              QuizController.to.total_list[index]['time'].toString().indexOf('.')+4 )}',
                                  style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),) :
                                    /// 틀리면 time = 0
                                QuizController.to.total_list[index]['time'].toString().substring(QuizController.to.total_list[index]['time'].toString().indexOf('.')+1).length == 1 ?
                                Text(QuizController.to.total_list[index]['time'].toString(), style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),) :
                                Text('${QuizController.to.total_list[index]['time'].toString().substring(0, QuizController.to.total_list[index]['time'].toString().indexOf('.'))}초 '
                                    '${QuizController.to.total_list[index]['time'].toString().substring(QuizController.to.total_list[index]['time'].toString().indexOf('.')+1 )}',
                                  style: TextStyle(fontFamily: 'Jua', fontSize: 40, color: Colors.white),)
                              ],);
                            },
                            //  Divider 로 구분자 추가.
                            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.white.withOpacity(0.5),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],),
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    if (QuizController.to.quiz_quiz_type.value == '개인') {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
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
              DocumentSnapshot score_doc = score_docs.last;
              if (score_doc['state'] == 'active') {
                QuizController.to.is_visible_timer.value = true;
              }

              DocumentSnapshot doc = QuizController.to.questions.where((doc) => doc['number'] == score_doc['question_number']).first  ;

              /// (24.3.25) 문제 다 풀고 닫기버튼 안눌러도 delScore하게
              if (doc['number'] == QuizController.to.question_cnt) {
                Future.delayed(Duration(minutes: 5), () {
                  QuizController.to.delScore();
                });
              }


              return Obx(() => Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Column(children: [
                          /// 질문
                          Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                child:
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Center(
                                    child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 35,),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
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
                                            r'' + doc['question'].split('\n')[index].split('. ')[index2].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                // .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                                // .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}') + r'',
                                            mathStyle: MathStyle.display,
                                            textStyle: TextStyle(fontSize: 50, ),
                                          ),
                                        // Math.tex(
                                        //   r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                        //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                        //   mathStyle: MathStyle.display,
                                        //   textStyle: TextStyle(fontSize: 50, color: Colors.black,),
                                        // ),
                                    ],
                                  )
                              ) :
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Math.tex(
                                  r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                      // .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                      // .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}')+ r'',
                                  mathStyle: MathStyle.display,
                                  textStyle: TextStyle(fontSize: 50, ),
                                ),
                              ) :
                              Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: Text(doc['question'], style: TextStyle(fontFamily: 'NanumGothic', fontWeight: FontWeight.bold, fontSize: 60,  ),)),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 답지
                                  doc['question_type'] == '단답형' ?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 28),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 1200, height: 100,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Visibility(
                                              visible: QuizController.to.is_visible_answer.value,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Container(
                                                      width: 900,
                                                      child:  Text(doc['answer'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 55,  fontWeight: FontWeight.bold),),
                                                  ),
                                                  Spacer(),
                                                  CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.black,
                                                      child: Text(QuizController.to.select_answer_1.value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],),
                                  ) :
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 28),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 1200,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal, size: 40,) :
                                                doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 55),) : SizedBox(),
                                                // doc['question_type'] == 'OX형' ? Icon(Icons.circle_outlined, color: Colors.teal, size: 45,) : SizedBox(),
                                                SizedBox(width: 10,),
                                                doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                                    || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                                Math.tex(
                                                  r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(fontSize: 45, ),
                                                ) :
                                                Container(
                                                    width: 880,
                                                    child: Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 55,  fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                doc['answer'] == '1' ? Icon(Icons.circle_outlined, color: QuizController.to.is_visible_answer.value == true ? Colors.green : Colors.transparent, size: 45,) :
                                                Icon(Icons.clear, color: QuizController.to.is_visible_answer.value == true ? Colors.red : Colors.transparent, size: 55,),
                                                SizedBox(width: 30,),
                                                Visibility(
                                                  visible: QuizController.to.is_visible_answer.value,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.black,
                                                      child: Text(QuizController.to.select_answer_1.value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                  // child: Text('1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],),
                                  ),
                                  doc['question_type'] != '단답형' ?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 28),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 1200,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 40,) : Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 55),),
                                                // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 40,) : Icon(Icons.clear, color: Colors.red, size: 45,),
                                                SizedBox(width: 10,),
                                                doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                                    || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                                Math.tex(
                                                  r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(fontSize: 45, ),
                                                ) :
                                                Container(
                                                    width: 880,
                                                    child: Text(doc['answer2'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 55,  fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                doc['answer'] == '2' ? Icon(Icons.circle_outlined, color: QuizController.to.is_visible_answer.value == true ? Colors.green : Colors.transparent, size: 45,) :
                                                Icon(Icons.clear, color: QuizController.to.is_visible_answer.value == true ? Colors.red : Colors.transparent, size: 55,),
                                                SizedBox(width: 30,),

                                                Visibility(
                                                  visible: QuizController.to.is_visible_answer.value,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.black,
                                                      child: Text(QuizController.to.select_answer_2.value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],),
                                  ) : SizedBox(),
                                  doc['question_type'] == '선택형' ?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 28),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 1200,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.filter_3, color: Colors.blue, size: 40,),
                                                SizedBox(width: 10,),
                                                doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                                    || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                                Math.tex(
                                                  r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(fontSize: 45, ),
                                                ) :
                                                Container(
                                                    width: 880,
                                                    child: Text(doc['answer3'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 55,  fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                doc['answer'] == '3' ? Icon(Icons.circle_outlined, color: QuizController.to.is_visible_answer.value == true ? Colors.green : Colors.transparent, size: 45,) :
                                                Icon(Icons.clear, color: QuizController.to.is_visible_answer.value == true ? Colors.red : Colors.transparent, size: 55,),
                                                SizedBox(width: 30,),

                                                Visibility(
                                                  visible: QuizController.to.is_visible_answer.value,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.black,
                                                      child: Text(QuizController.to.select_answer_3.value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],),
                                  ) : SizedBox(),
                                  doc['question_type'] == '선택형' ?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 28),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 1200,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(8),),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.filter_4, color: Colors.orange, size: 40,),
                                                SizedBox(width: 10,),
                                                doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                                    || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                                Math.tex(
                                                  r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(fontSize: 45, ),
                                                ) :
                                                Container(
                                                    width: 880,
                                                    child: Text(doc['answer4'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 55,  fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                doc['answer'] == '4' ? Icon(Icons.circle_outlined, color: QuizController.to.is_visible_answer.value == true ? Colors.green : Colors.transparent, size: 45,) :
                                                Icon(Icons.clear, color: QuizController.to.is_visible_answer.value == true ? Colors.red : Colors.transparent, size: 55,),
                                                SizedBox(width: 30,),

                                                Visibility(
                                                  visible: QuizController.to.is_visible_answer.value,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.black,
                                                      child: Text(QuizController.to.select_answer_4.value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,),)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],),
                                  ) : SizedBox(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                              SizedBox(width: 30,),
                              /// 이미지
                              Visibility(
                                // visible: true,
                                visible: doc['question_image_url'].length > 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    // child: Image.asset('assets/images/quiz_background2.png', fit: BoxFit.cover, width: 300,),
                                    child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 400,),
                                  ),
                                ),
                              ),
                            ],),
                        ],),

                        Container(
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 50,),
                              /// 다음문제
                              Container(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                                  onPressed: () async{
                                    if (doc['number'] != QuizController.to.question_cnt) {
                                      QuizController.to.updQuestionState(doc['number'], 'ready');
                                      // await QuizController.to.updActiveQuestion(doc['number'], 'ready');
                                      QuizController.to.is_visible_timer.value = false;
                                      QuizController.to.is_visible_count_down.value = true;
                                      QuizController.to.is_visible_answer.value = false;
                                    }

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.play_circle, color: Colors.white, size: 25,),
                                        SizedBox(width: 10,),
                                        doc['number'] != QuizController.to.question_cnt ?
                                        Text('다음문제',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),) :
                                        Text('끝',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),), 
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,),
                              /// 순위보기
                              Container(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                                  onPressed: () async{
                                    await QuizController.to.scoreQuestion(doc['number'], doc['answer']);
                                    await QuizController.to.scoreTotal();
                                    scoreDialog(context, doc['number']);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bar_chart, color: Colors.white, size: 25,),
                                        SizedBox(width: 10,),
                                        Text('순위보기',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 500,),
                              /// 남은시간
                              Container(
                                width: 250,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('남은시간',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.grey),),
                                    SizedBox(width: 10,),
                                    Obx(() => Visibility(
                                      visible: QuizController.to.is_visible_timer.value,
                                      child: Countdown(
                                        // seconds: 5,
                                        seconds: int.parse(QuizController.to.quiz_indi_timer.value),
                                        build: (BuildContext context, double time) {
                                          return Container(
                                            // alignment: Alignment.topRight,
                                            width: 60,
                                            child: Text(time.toString(), style: TextStyle(color: Colors.orange, fontSize: 35),),
                                          );
                                        },
                                        interval: Duration(milliseconds: 1000),
                                        onFinished: () async{
                                          if (doc['question_type'] == '단답형' ) {
                                            await QuizController.to.cntSelectQuestion2(doc['number']);
                                          }else{
                                            await QuizController.to.cntSelectQuestion(doc['number']);
                                          }

                                          QuizController.to.is_visible_answer.value = true;
                                        },
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
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
                        QuizController.to.updQuestionState(doc['number'], 'active');
                        // QuizController.to.updActiveQuestion(doc['number'], 'active');
                        QuizController.to.is_visible_count_down.value = false;
                        // QuizController.to.is_visible_timer.value = false;
                      },
                    ),
                  ),
                  ),
                ],),
              );


            } else {
              return SizedBox();
            }






          }
      );
    } else {  /// 모둠
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('quiz_id', isEqualTo: QuizController.to.quiz_id).snapshots(),
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
            if (snapshot.data!.docs.length > 0) {
              List total_list = [];
              List<Map> list_map = [];
              snapshot.data!.docs.forEach((doc) {
                /// 같은 이름은 삭제(버튼 연타 대비)
                List remove_dupli_list = [];
                remove_dupli_list = doc['submitter'];
                if (remove_dupli_list.length > 1) {
                  remove_dupli_list.removeWhere((a) => a != remove_dupli_list.firstWhere((b) => b['name'] == a['name'] ));
                }

                /// score = 0 제외
                // remove_dupli_list.removeWhere((a) => a['score'] == 0 );

                for (int index = 0; index < remove_dupli_list.length; index++) {
                  list_map.add(remove_dupli_list[index]);
                }

              });

              var total_map = groupBy(list_map, (Map obj) => obj['name']).map(
                      (k, v) => MapEntry(k, v.map((item) { item.remove('name'); return item;}).toList()));

              total_map.forEach((key, value) {
                int? score = 0;
                int? score_sum = 0;
                // String? time = '';
                double time_sum = 0.0;
                for (int index = 0; index < value.length; index++) {
                  score = value[index]['score'] as int;
                  score_sum = (score! + score_sum!);
                  if (score == 1) {
                    time_sum = double.parse(value[index]['time'].substring(5,11))! + time_sum!;
                  }

                }
                total_list.add({'name': key, 'score': score_sum, 'time': time_sum,});
                total_list.sort((a,b)=> a['name'].compareTo(b['name']));
              });

              return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: total_list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(color:Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                      // color: index.isOdd ? Colors.grey.withOpacity(0.5) : Colors.white,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${total_list[index]['name']}모둠', style: TextStyle(color: Colors.grey, fontSize: 35, fontFamily: 'Jua'),),
                                Text('${total_list[index]['name']}모둠', style: TextStyle(color: Colors.grey, fontSize: 35, fontFamily: 'Jua'),),
                                // Text('${total_list[index]['name']}모둠', style: TextStyle(color: index.isEven ? Colors.grey : Colors.white, fontSize: 28, fontFamily: 'Jua'),),
                                // Text('${total_list[index]['name']}모둠', style: TextStyle(color: index.isEven ? Colors.grey : Colors.white, fontSize: 28, fontFamily: 'Jua'),),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width * 0.95 * ( total_list[index]['score'] / snapshot.data!.docs.length),
                                // width: MediaQuery.of(context).size.width * 0.8 * ( total_list[index]['score'] / snapshot.data!.docs.length),
                                child: Image.asset('assets/images/angry_bird_01.png', width: 180,),
                                // child: Image.asset('assets/images/${QuizController.to.angry_birds[index]}.png', width: 180,),
                              ),
                              Expanded(
                                child: Container(
                                  child: Icon(Icons.cancel, color: Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ],

                      ),
                    ),
                  );
                },

              );

            } else {
              return SizedBox();
            }






          }
      );

    }

  }
}


