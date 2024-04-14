import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/frac_test2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizMyQuiz extends StatelessWidget {

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

  void updDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 540,
            height: MediaQuery.of(context).size.height*0.8,
            color: Color(0xFF4C4C4C),
            child: Obx(() => SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                        ),
                        Spacer(),
                        TextButton(
                          style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                          onPressed: () {
                            delDialog(context);
                            // Navigator.pop(context);
                          },
                          child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                        ),

                        TextButton(
                          style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                          onPressed: () {
                            QuizController.to.updQuiz();
                            Navigator.pop(context);
                          },
                          child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 500,
                      height: 40,
                      child: TextField(
                        controller: TextEditingController(text: QuizController.to.quiz_title),
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          QuizController.to.quiz_title = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
                        // minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '제목을 입력하세요',
                          hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    SizedBox(
                      width: 500, height: 80,
                      child: TextField(
                        controller: TextEditingController(text: QuizController.to.quiz_description),
                        onChanged: (value) {
                          QuizController.to.quiz_description = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
                        minLines: 5,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '설명을 입력하세요',
                          hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),

                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    /// 학년
                    Container(
                      width: 500,height: 60,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          for ( var grade in QuizController.to.grades )
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                QuizController.to.quiz_grade.value = grade;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [ QuizController.to.quiz_grade.value == grade ?
                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                  Icon(Icons.circle_outlined, color: Colors.grey,),
                                    SizedBox(width: 3,),
                                    Text(grade,style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    /// 학기
                    Container(
                      width: 500,height: 60,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          for ( var semester in QuizController.to.semesters )
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                QuizController.to.quiz_semester.value = semester;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [ QuizController.to.quiz_semester.value == semester ?
                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                  Icon(Icons.circle_outlined, color: Colors.grey,),
                                    SizedBox(width: 3,),
                                    Text(semester,style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    /// 과목
                    Container(
                      width: 500,height: 100,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              for ( var subject in QuizController.to.subjects1 )
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    QuizController.to.quiz_subject.value = subject;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [ QuizController.to.quiz_subject.value == subject ?
                                      Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                      Icon(Icons.circle_outlined, color: Colors.grey,),
                                        SizedBox(width: 3,),
                                        Text(subject,style: TextStyle(color: Colors.white, fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              for ( var subject in QuizController.to.subjects2 )
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    QuizController.to.quiz_subject.value = subject;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [ QuizController.to.quiz_subject.value == subject ?
                                      Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                      Icon(Icons.circle_outlined, color: Colors.grey,),
                                        SizedBox(width: 3,),
                                        Text(subject,style: TextStyle(color: Colors.white, fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    /// 퀴즈유형
                    Container(
                      width: 500,
                      child: Text('  퀴즈유형', style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 3,),
                    Container(
                      width: 500,height: 60,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          for ( var quiz_type in QuizController.to.quiz_types )
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                QuizController.to.quiz_quiz_type.value = quiz_type;
                                if (QuizController.to.quiz_quiz_type.value == '개인') {
                                  QuizController.to.is_visible_indi_timer.value = true;
                                  QuizController.to.is_visible_modum_total_timer.value = false;
                                  QuizController.to.is_visible_modum_indi_timer.value = false;
                                }else{
                                  QuizController.to.is_visible_indi_timer.value = false;
                                  QuizController.to.is_visible_modum_total_timer.value = true;
                                  QuizController.to.is_visible_modum_indi_timer.value = true;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [ QuizController.to.quiz_quiz_type.value == quiz_type ?
                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                  Icon(Icons.circle_outlined, color: Colors.grey,),
                                    SizedBox(width: 3,),
                                    Text(quiz_type,style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(
                      visible: QuizController.to.is_visible_indi_timer.value,
                      child: Column(children: [
                        /// 문제당 시간
                        Container(
                          width: 500,
                          child: Text('  문제당 시간(초)', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(height: 3,),
                        Container(
                          width: 500,height: 50,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              for ( var timer in QuizController.to.indi_timers )
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    QuizController.to.quiz_indi_timer.value = timer;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(shape: BoxShape.circle,
                                        color: QuizController.to.quiz_indi_timer.value == timer ? Colors.orangeAccent : Colors.transparent,
                                        border: Border.all(color: Colors.grey, width: 1),
                                      ),
                                      child: Text(timer, style: TextStyle(color: Colors.white, fontSize: 13,),),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],),
                    ),

                    // Visibility(
                    //   visible: QuizController.to.is_visible_modum_total_timer.value,
                    //   child: Column(children: [
                    //     /// 퀴즈 총시간
                    //     Container(
                    //       width: 500,
                    //       child: Text('  퀴즈 총시간(분)', style: TextStyle(color: Colors.white),),
                    //     ),
                    //     SizedBox(height: 3,),
                    //     Container(
                    //       width: 500,height: 50,
                    //       decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    //       child: Row(
                    //         children: [
                    //           for ( var timer in QuizController.to.modum_total_timers )
                    //             InkWell(
                    //               highlightColor: Colors.transparent,
                    //               hoverColor: Colors.transparent,
                    //               splashColor: Colors.transparent,
                    //               onTap: () {
                    //                 QuizController.to.quiz_modum_total_timer.value = timer;
                    //               },
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Container(
                    //                   alignment: Alignment.center,
                    //                   width: 25,
                    //                   height: 25,
                    //                   decoration: BoxDecoration(shape: BoxShape.circle,
                    //                     color: QuizController.to.quiz_modum_total_timer.value == timer ? Colors.orangeAccent : Colors.transparent,
                    //                     border: Border.all(color: Colors.grey, width: 1),
                    //                   ),
                    //                   child: Text(timer, style: TextStyle(color: Colors.white, fontSize: 13,),),
                    //                 ),
                    //               ),
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(height: 15,),
                    //   ],),
                    // ),

                    Visibility(
                      visible: QuizController.to.is_visible_modum_indi_timer.value,
                      child: Column(children: [
                        /// 개인당 시간
                        Container(
                          width: 500,
                          child: Text('  개인당 시간(초)', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(height: 3,),
                        Container(
                          width: 500,height: 50,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              for ( var timer in QuizController.to.modum_indi_timers )
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    QuizController.to.quiz_modum_indi_timer.value = timer;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(shape: BoxShape.circle,
                                        color: QuizController.to.quiz_modum_indi_timer.value == timer ? Colors.orangeAccent : Colors.transparent,
                                        border: Border.all(color: Colors.grey, width: 1),
                                      ),
                                      child: Text(timer, style: TextStyle(color: Colors.white, fontSize: 13,),),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],),
                    ),
                    /// 공개여부
                    Container(
                      width: 500,height: 60,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          for ( var public_type in QuizController.to.public_types )
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                QuizController.to.quiz_public_type.value = public_type;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [ QuizController.to.quiz_public_type.value == public_type ?
                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                  Icon(Icons.circle_outlined, color: Colors.grey,),
                                    SizedBox(width: 3,),
                                    Text(public_type,style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                  ]
              ),
            ),
            ),
          ),
        );
      },
    );

  }

  void delDialog(parentContext) {
    showCupertinoDialog(
      context: parentContext,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 120,
            child: Material(
              color: Colors.transparent,
              child: Center(child: Text('정말 삭제하시겠습니까?', style: TextStyle(fontFamily: 'Jua', fontSize: 20),)),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('취소'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('삭제'), onPressed: () {
              QuizController.to.delQuiz();
              Navigator.pop(context);
              Navigator.pop(parentContext);
            })

          ],
        );
      },
    );

  }

  void delDialog2(parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 100,
            height: 100,
            color: Color(0xFF4C4C4C),
            child: Column(
              children: [
                Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('취소', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
                    ),
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        QuizController.to.delQuiz();
                        Navigator.pop(context);
                        Navigator.pop(parentContext);
                      },
                      child: Text('삭제', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

  }

  void qrDialog(context, quiz_id) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 700,
            height: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.black, width: 3), shape: BoxShape.circle,),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.close, size: 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: QrImageView(
                    data: 'https://classdiary2.web.app/?paramClassCode=${GetStorage().read('class_code')}&paramEmail=${GetStorage().read('email')}&paramQuizId=${quiz_id}&paramIsRealName=no&paramGubun=quiz',
                    version: QrVersions.auto,
                    size: 650.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }

  void choiceNameDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 700,
            height: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              InkWell(
                onHover: (is_hover) {
                  if (is_hover == true) {
                    QuizController.to.is_hover_choice_real.value = true;
                  }else{
                    QuizController.to.is_hover_choice_real.value = false;
                  }
                },
                onTap: () {
                  QuizController.to.is_real_name = true;
                  QuizController.to.active_screen.value = 'ready';
                  Navigator.pop(context);
                },
                child: Obx(() => Container(
                    decoration: BoxDecoration(color: QuizController.to.is_hover_choice_real.value ? Colors.teal : Colors.transparent, borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset('assets/images/quiz_capture_real.png', width: 300, height: 300, ),
                          ),
                        ),
                        Text('출석부에 명단이 존재하는 경우 선택하세요', style: TextStyle(color: Colors.white, fontFamily: 'Jua'),),
                      ],
                    ),
                  ),
                ),
              ),
                InkWell(
                  onHover: (is_hover) {
                    if (is_hover == true) {
                      QuizController.to.is_hover_choice_anonymous.value = true;
                    }else{
                      QuizController.to.is_hover_choice_anonymous.value = false;
                    }
                  },
                  onTap: () {
                    QuizController.to.is_real_name = false;
                    QuizController.to.active_screen.value = 'ready';
                    Navigator.pop(context);
                  },
                  child: Obx(() => Container(
                    decoration: BoxDecoration(color: QuizController.to.is_hover_choice_anonymous.value ? Colors.orange : Colors.transparent, borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset('assets/images/quiz_capture_anonymous.png', width: 300, height: 300,),
                          ),
                        ),
                        Text('출석부에 명단이 없는 경우 선택하세요', style: TextStyle(color: Colors.white, fontFamily: 'Jua'),),
                      ],
                    ),
                  ),
                  ),
                ),
            ],),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 검색을 하기 위한 더미
          Text(QuizController.to.dummy_search_date.value, style: TextStyle( fontSize: 0,),),
          Text('나의 퀴즈', style: TextStyle(color: Color(0xff76B8C3), fontFamily: 'Jua', fontWeight: FontWeight.bold, fontSize: 35,),),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('quiz_main').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
                /// 검색
                if (QuizController.to.search_gubun != 'all') {
                  if (QuizController.to.search_title.trim().length == 0) {
                    docs = docs.where((doc) => QuizController.to.grade_list.contains(doc['grade'])).where((doc) => QuizController.to.semester_list.contains(doc['semester']))
                        .where((doc) => QuizController.to.subject_list.contains(doc['subject'])).toList();
                  }else {
                    docs = docs.where((doc) => doc['title'].contains(QuizController.to.search_title)).where((doc) => QuizController.to.grade_list.contains(doc['grade'])).where((doc) => QuizController.to.semester_list.contains(doc['semester']))
                        .where((doc) => QuizController.to.subject_list.contains(doc['subject'])).toList();
                  }

                }
                docs.sort((a,b)=> b['date'].compareTo(a['date']));

                return
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisCount: 8,
                      crossAxisCount : (MediaQuery.of(context).size.width/250).floor(),
                      // crossAxisCount : MediaQuery.of(context).size.width > 2000 ? 8 :
                      // MediaQuery.of(context).size.width < 1000 ? 5: 6,
                      /// 0.78인 이유는 singlescrollview 할때 끝에 잘리지 않게 하기위해
                      childAspectRatio: 1 / 0.78,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20, right: 20),
                        child: Container(
                          // width: 200,
                          // height: 150,
                          color: Color(0xff76B8C3),
                          // decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/quiz_background2.png'), fit: BoxFit.cover, ), borderRadius: BorderRadius.circular(8),),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    QuizController.to.quiz_id = doc.id;
                                    QuizController.to.quiz_title = doc['title'];
                                    QuizController.to.quiz_description = doc['description'];
                                    QuizController.to.quiz_grade.value = doc['grade'];
                                    QuizController.to.quiz_semester.value = doc['semester'];
                                    QuizController.to.quiz_subject.value = doc['subject'];
                                    QuizController.to.quiz_quiz_type.value = doc['quiz_type'];
                                    QuizController.to.quiz_quiz_title.value = doc['title'];
                                    // QuizController.to.quiz_question_type.value = doc['question_type'];
                                    QuizController.to.quiz_indi_timer.value = doc['indi_timer'];
                                    QuizController.to.quiz_modum_total_timer.value = doc['modum_total_timer'];
                                    QuizController.to.quiz_modum_indi_timer.value = doc['modum_indi_timer'];
                                    QuizController.to.quiz_public_type.value = doc['public'];
                                    QuizController.to.quiz_date = doc['date'].toDate();
                                    QuizController.to.class_code = doc['class_code']; // (24.3.25) 전체,즐겨찾기에서 '문제만들기' 버튼 비활성화위해

                                    QuizController.to.active_screen.value = 'detail';
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.sizeOf(context).width,
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(doc['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17,),),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.cloud_download, size: 18, color: Colors.white,),
                                            // Icon(Icons.favorite_border, size: 18, color: Colors.white,),
                                            SizedBox(width: 3,),
                                            Text(doc['like'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                          ],
                                        ),

                                        Text(DateFormat('yy.MM.dd').format(doc['date'].toDate()).toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                        // Text(doc['date'].toDate().year.toString()+'.'+doc['date'].toDate().month.toString()+'.'+doc['date'].toDate().day.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                        Text(GetStorage().read('email').substring(0, GetStorage().read('email').indexOf('@')), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                      ],
                                    ),
                                  ),
                                  Obx(() => Container(
                                    decoration: BoxDecoration(color: Colors.white,
                                      border: Border(top: BorderSide(color: Color(0xFFF7F7F7),width: 2,)),
                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                    ),
                                    // width: 200,
                                    height: 50,
                                    // alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                                      children: [
                                        InkWell(
                                          onHover: (isHovering) {
                                            if (isHovering) {
                                              QuizController.to.is_hover_edit.value = index;
                                            } else {
                                              QuizController.to.is_hover_edit.value = 99999;
                                            }
                                          },
                                          onTap: () {
                                            QuizController.to.quiz_id = doc.id;
                                            QuizController.to.quiz_title = doc['title'];
                                            QuizController.to.quiz_description = doc['description'];
                                            QuizController.to.quiz_grade.value = doc['grade'];
                                            QuizController.to.quiz_semester.value = doc['semester'];
                                            QuizController.to.quiz_subject.value = doc['subject'];
                                            QuizController.to.quiz_quiz_type.value = doc['quiz_type'];
                                            QuizController.to.quiz_quiz_title.value = doc['title'];
                                            QuizController.to.quiz_indi_timer.value = doc['indi_timer'];
                                            QuizController.to.quiz_modum_total_timer.value = doc['modum_total_timer'];
                                            QuizController.to.quiz_modum_indi_timer.value = doc['modum_indi_timer'];
                                            QuizController.to.quiz_public_type.value = doc['public'];
                                            QuizController.to.quiz_date = doc['date'].toDate();

                                            if (QuizController.to.quiz_quiz_type.value == '개인') {
                                              QuizController.to.is_visible_indi_timer.value = true;
                                              QuizController.to.is_visible_modum_total_timer.value = false;
                                              QuizController.to.is_visible_modum_indi_timer.value = false;
                                            }else {
                                              QuizController.to.is_visible_indi_timer.value = false;
                                              QuizController.to.is_visible_modum_total_timer.value = true;
                                              QuizController.to.is_visible_modum_indi_timer.value = true;
                                            }

                                            updDialog(context);
                                          },
                                          child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Icon(Icons.edit, size: QuizController.to.is_hover_edit.value == index ? 30 : 25,
                                                color: QuizController.to.is_hover_edit.value == index ? Colors.orange : Colors.black.withOpacity(0.5),),
                                          ),
                                        ),
                                        VerticalDivider(color: Colors.grey, thickness: 1,),
                                        /// 시작버튼
                                        InkWell(
                                          onHover: (isHovering) {
                                            if (isHovering) {
                                              QuizController.to.is_hover_start.value = index;
                                            } else {
                                              QuizController.to.is_hover_start.value = 99999;
                                            }
                                          },
                                          onTap: () {
                                            QuizController.to.quiz_id = doc.id;
                                            QuizController.to.quiz_title = doc['title'];
                                            QuizController.to.quiz_description = doc['description'];
                                            QuizController.to.quiz_grade.value = doc['grade'];
                                            QuizController.to.quiz_semester.value = doc['semester'];
                                            QuizController.to.quiz_subject.value = doc['subject'];
                                            QuizController.to.quiz_quiz_type.value = doc['quiz_type'];
                                            QuizController.to.quiz_quiz_title.value = doc['title'];
                                            // QuizController.to.quiz_question_type.value = doc['question_type'];
                                            QuizController.to.quiz_indi_timer.value = doc['indi_timer'];
                                            QuizController.to.quiz_modum_total_timer.value = doc['modum_total_timer'];
                                            QuizController.to.quiz_modum_indi_timer.value = doc['modum_indi_timer'];
                                            QuizController.to.quiz_public_type.value = doc['public'];
                                            QuizController.to.quiz_date = doc['date'].toDate();

                                            QuizController.to.getQuestionCnt(); /// 마지막 문제에서 더이상 안넘어가기 위해 필요
                                            QuizController.to.delScore();
                                            QuizController.to.is_visible_answer.value = false;
                                            // QuizController.to.updScoreReadyToActive();  /// 모둠때문에 추가
                                            // if (QuizController.to.quiz_quiz_type.value == '모둠') {
                                            //   QuizController.to.updQuestionStateModum1();
                                            // }


                                            /// 실명, 익명 분기
                                            // choiceNameDialog(context);

                                            QuizController.to.is_real_name = true;
                                            QuizController.to.active_screen.value = 'ready';
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                child: Icon(Icons.play_circle, size: QuizController.to.is_hover_start.value == index ? 30 : 25,
                                                  color: QuizController.to.is_hover_start.value == index ? Colors.orange : Colors.black,),
                                              ),
                                              SizedBox(
                                                width: 50,
                                                child: Text('준비', style: TextStyle(color: QuizController.to.is_hover_start.value == index ? Colors.orange : Colors.black,
                                                  fontFamily: 'Jua', fontSize: QuizController.to.is_hover_start.value == index ? 25: 20,),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                            ],),
                        ),
                      );
                    },

                  );
              }
          ),

        ],),
    );

  }
}


