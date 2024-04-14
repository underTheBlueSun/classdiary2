import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/web/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';
import '../controller/board_controller.dart';
import '../controller/class_controller.dart';
import '../controller/signinup_controller.dart';

class QuizTopMenu extends StatelessWidget {
  CustomPopupMenuController popupController = CustomPopupMenuController();

  void exitDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('닫기', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
                ),
              ),
            ],),
          content: Container(
            width: 500, height: 700,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Container(
                      height: 40,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: BoardController.to.kDefaultRainbowColors,
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.transparent
                      ),
                    ),);
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        width: 500, height: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFF4C4C4C),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                  width: 500,
                                  child: Center(child: Text('출석부가 존재하지 않습니다', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.orangeAccent),))),
                              SizedBox(height: 25,),
                              Text('(추측1) 링크주소가 잘못되었다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
                              SizedBox(height: 15,),
                              Text('(추측2) 선생님이 출석부를 아직 만들지 않으셨다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }else{
                    // List attendanceList = snapshot.data!.docs.first['attendance'];
                    // attendanceList.sort((a, b) => a['number'].compareTo(b['number']));
                    List attendanceList = AttendanceController.to.attendanceList;
                    List visitList = snapshot.data!.docs.first['visit'];
                    return
                      SingleChildScrollView(
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                            childAspectRatio: 5 / 1, //item 의 가로, 세로 의 비율
                          ),
                          itemCount: attendanceList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
                                      || index + 1 == AttendanceController.to.attendanceCnt.value
                                      ? BorderSide(width: 1, color: Colors.transparent,)
                                      : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
                                  right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      child:
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Jua',),),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18,),),
                                    Spacer(),
                                    visitList.any((e) => mapEquals(e, attendanceList[index])) ?
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,),
                                        onPressed: () {
                                          ClassController.to.exitClassByTeacher(attendanceList[index]['number'], attendanceList[index]['name'], snapshot.data!.docs.first.id);
                                        }, // onPressed
                                        child: Text('퇴장', style: TextStyle(color: Colors.white),),
                                      ),
                                    ) :
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text('입장안함', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          },

                        ),
                      );
                  }

                }
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          /// 홈
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              Get.off(() => Dashboard());
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  // Image.asset('assets/images/quiz_home_icon.png', height: 33,),
                  Icon(Icons.house_siding, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('학급다이어리', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                ],
              ),
            ),
          ),
          SizedBox(width: 30,),
          /// 전체
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              QuizController.to.active_screen.value = 'all';
              QuizController.to.before_screen.value = 'all';
              QuizController.to.search_grade = '학년'.obs;
              QuizController.to.search_semester = '학기'.obs;
              QuizController.to.search_subject = '과목'.obs;
              QuizController.to.search_gubun = 'all'; // (24.3.22)검색때문에 추가
              QuizController.to.grade_list = ['전체','1학년','2학년','3학년','4학년','5학년','6학년'];
              QuizController.to.semester_list = ['전체','1학기', '2학기'];
              QuizController.to.subject_list = ['전체','국어','수학','사회','과학','영어','실과','체육','음악','미술','창체'];
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.people_alt_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  // Image.asset('assets/images/quiz_all_icon.png', height: 33,),
                  SizedBox(height: 10,),
                  Text('전체', style: TextStyle(fontFamily: 'Jua', fontSize: 13,color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),)
                ],
              ),
            ),
          ),
          SizedBox(width: 30,),
          /// 나의퀴즈
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              QuizController.to.active_screen.value = 'myquiz';
              QuizController.to.before_screen.value = 'myquiz';
              QuizController.to.search_grade = '학년'.obs;
              QuizController.to.search_semester = '학기'.obs;
              QuizController.to.search_subject = '과목'.obs;
              QuizController.to.search_gubun = 'all'; // (24.3.22)검색때문에 추가
              QuizController.to.grade_list = ['전체','1학년','2학년','3학년','4학년','5학년','6학년'];
              QuizController.to.semester_list = ['전체','1학기', '2학기'];
              QuizController.to.subject_list = ['전체','국어','수학','사회','과학','영어','실과','체육','음악','미술','창체'];
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  // Image.asset('assets/images/quiz_myquiz_icon.png', height: 33,),
                  Icon(Icons.quiz_outlined, size: 35,color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('나의퀴즈', style: TextStyle(fontFamily: 'Jua', fontSize: 13,color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),)
                ],
              ),
            ),
          ),
          SizedBox(width: 30,),
          /// 즐겨찾기
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              QuizController.to.active_screen.value = 'favorite';
              QuizController.to.before_screen.value = 'favorite';
              QuizController.to.search_grade = '학년'.obs;
              QuizController.to.search_semester = '학기'.obs;
              QuizController.to.search_subject = '과목'.obs;
              QuizController.to.search_gubun = 'all'; // (24.3.22)검색때문에 추가
              QuizController.to.grade_list = ['전체','1학년','2학년','3학년','4학년','5학년','6학년'];
              QuizController.to.semester_list = ['전체','1학기', '2학기'];
              QuizController.to.subject_list = ['전체','국어','수학','사회','과학','영어','실과','체육','음악','미술','창체'];
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.workspace_premium, size: 35,color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  // Image.asset('assets/images/quiz_favorite_icon.png', height: 33, ),
                  SizedBox(height: 10,),
                  Text('즐겨찾기', style: TextStyle(fontFamily: 'Jua', fontSize: 13,color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),)
                ],
              ),
            ),
          ),
          SizedBox(width: 70,),
          /// 퀴즈만들기
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff76B8C3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
            onPressed: () {},
            child: CustomPopupMenu(
              controller: popupController,
              arrowSize: 20,
              menuOnChange: (bool) {
                if (bool == true) {
                  QuizController.to.quiz_title = '';
                  QuizController.to.quiz_description = '';
                  QuizController.to.quiz_grade.value = '1학년';
                  QuizController.to.quiz_semester.value = '1학기';
                  QuizController.to.quiz_subject.value = '국어';
                  QuizController.to.quiz_quiz_type.value = '개인';
                  // QuizController.to.quiz_question_type.value = '선택형';
                  QuizController.to.quiz_indi_timer.value = '10';
                  QuizController.to.quiz_modum_total_timer.value = '1';
                  QuizController.to.quiz_modum_indi_timer.value = '10';
                  QuizController.to.quiz_public_type.value = '공개';
                }

              },
              child: Padding(
                padding: const EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.wechat_rounded, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('퀴즈 만들기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white),),
                  ],
                ),
              ),
              menuBuilder: () => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView(
                  child: Container(
                    width: 540,
                    height: MediaQuery.of(context).size.height*0.8,
                    color: Color(0xFF4C4C4C),
                    child: Obx(() => Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: TextButton(
                                  style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                                  onPressed: () {
                                    if (QuizController.to.quiz_title.trim().length > 0) {
                                      QuizController.to.createQuiz();
                                      popupController.hideMenu();
                                    }
                                  },
                                  child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            width: 500,
                            height: 33,
                            child: TextField(
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
                              onChanged: (value) {
                                QuizController.to.quiz_description = value;
                              },
                              style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
                              minLines: 5,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: '설명을 입력하세요',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),

                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          /// 학년
                          Container(
                            width: 500,height: 50,
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
                                          Text(grade,style: TextStyle(color: Colors.white, fontSize: 15),),
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
                            width: 500,height: 50,
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
                                          Text(semester,style: TextStyle(color: Colors.white, fontSize: 15),),
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
                            width: 500,height: 90,
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
                                              Text(subject,style: TextStyle(color: Colors.white, fontSize: 15),),
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
                            width: 500,height: 50,
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
                                          Text(quiz_type,style: TextStyle(color: Colors.white, fontSize: 15),),
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
                            width: 500,height: 50,
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
                                          Text(public_type,style: TextStyle(color: Colors.white, fontSize: 15),),
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
              ),
              pressType: PressType.singleClick,
              verticalMargin: -10,

            ),
          ),

        ],),
        Row(children: [
          /// 입퇴장
          SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                exitDialog(context);
              }, // onPressed
              child: Text('입/퇴장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 17),),
            ),
          ),

        ],),

      ],);

  }
}


