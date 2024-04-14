import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QuizAll extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 검색을 하기 위한 더미
          Text(QuizController.to.dummy_search_date.value, style: TextStyle( fontSize: 0,),),

          Text('전체', style: TextStyle(color: Color(0xff76B8C3), fontFamily: 'Jua', fontWeight: FontWeight.bold, fontSize: 35,),),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('quiz_main').where('public', isEqualTo: '공개').snapshots(),
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
                /// 나의퀴즈, 즐겨찾기 빼기
                List docs = snapshot.data!.docs.where((doc) => doc['email'] != GetStorage().read('email')).where((doc) => !doc['favorites'].contains(GetStorage().read('class_code')) ).toList();
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
                          // decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/quiz_background2.png'), fit: BoxFit.cover, ),borderRadius: BorderRadius.circular(8),),
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
                                    // QuizController.to.active_screen.value = 'all_detail';
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
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.workspace_premium, size: 15, color: Colors.white,),
                                                // Icon(Icons.favorite_border, size: 18, color: Colors.white,),
                                                SizedBox(width: 3,),
                                                Text(doc['favorites'].length.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.cloud_download, size: 15, color: Colors.white,),
                                                // Icon(Icons.favorite_border, size: 18, color: Colors.white,),
                                                SizedBox(width: 3,),
                                                Text(doc['download'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                              ],
                                            ),
                                          ],
                                        ),

                                        Text(DateFormat('yy.MM.dd').format(doc['date'].toDate()).toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                        // Text(doc['date'].toDate().year.toString()+'.'+doc['date'].toDate().month.toString()+'.'+doc['date'].toDate().day.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                        Text(doc['email'].substring(0, doc['email'].indexOf('@')), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                      ],
                                    ),
                                  ),
                                  Obx(() => Container(
                                    decoration: BoxDecoration(color: Colors.white,
                                      border: Border(top: BorderSide(color: Color(0xFFF7F7F7),width: 2,)),
                                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8),),
                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                    ),
                                    // width: 200,
                                    height: 50,
                                    // alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            QuizController.to.quiz_id_other = doc.id;
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

                                            // QuizController.to.active_screen.value = 'detail';

                                            QuizController.to.updDownload();
                                            QuizController.to.getOtherQuizMain();

                                          },
                                          child: Text('가져오기', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 13),),
                                        ),
                                        VerticalDivider(color: Colors.grey, thickness: 1,),
                                        InkWell(
                                          onTap: () {
                                            QuizController.to.quiz_id = doc.id;
                                            QuizController.to.active_screen.value = 'favorite';
                                            QuizController.to.updQuizFavorite(doc['favorites']);

                                          },
                                          child: Text('즐겨찾기', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 13),),
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


