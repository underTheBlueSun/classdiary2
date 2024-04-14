import 'package:classdiary2/auction/auction_main.dart';
import 'package:classdiary2/board_main.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:classdiary2/controller/notice_controller.dart';
import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/controller/signinup_controller.dart';
import 'package:classdiary2/controller/subject_controller.dart';
import 'package:classdiary2/web/notice_detail.dart';
import 'package:classdiary2/web/signinup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/painting.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/class_controller.dart';
import '../controller/coupon_controller.dart';
import '../controller/attendance_controller.dart';
import 'dart:html' as html;
import 'dart:js' as js;

import '../controller/diary_controller.dart';
import '../controller/exam_controller.dart';
import '../controller/point_controller.dart';
import '../controller/survey_controller.dart';
import '../controller/temper_controller.dart';
import '../coupon/coupon.dart';
import '../coupon/coupon_main.dart';
import '../diary/diary_main.dart';
import '../exam/exam_main.dart';
import '../point/point.dart';
import '../point/point_main.dart';
import '../subject/subject_main.dart';
import '../survey/survey_main.dart';
import '../temperature/temperature_main.dart';

class MenuView extends StatelessWidget {
  CustomPopupMenuController gamesController = CustomPopupMenuController();

  void classCodeDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('class_info').where('email', isEqualTo: GetStorage().read('email')).snapshots(),
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

                    var docs = snapshot.data!.docs;
                    docs.sort((a, b) => b['date'].compareTo(a['date']));

                    return Column(
                      children: [
                        Text('반코드는 호세피나에서 필요합니다.\n반코드가 안보이는 경우 윗쪽 호세피나를 클릭하세요', style: TextStyle(fontSize: 12),),
                        Divider(),
                        ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(25),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var doc = docs[index];
                              return Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(doc['school_year'] + '학년도', ),
                                  ),
                                  Container(
                                    width: 60,
                                    child: SelectableText(doc['class_code'], style: TextStyle(fontSize: 18,  color: Colors.redAccent),),
                                  ),
                                ],
                              ) ;
                            },
                            separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1, color: Colors.grey.withOpacity(0.3),); }

                        ),
                      ],
                    );
                  }
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  void adminDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 500,
            width: 400,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    // FirebaseFirestore.instance.collection('academic').get().then(
                    //       (value) => value.docs.forEach((element) {
                    //     var docRef = FirebaseFirestore.instance.collection('academic').doc(element.id);
                    //     docRef.update({'color': 'color1'});
                    //   },
                    //   ),
                    // );
                  }, // onPressed
                  child: Text('학사일정 color필드 추가', ),
                ),
                SizedBox(height: 20,),

                OutlinedButton(
                  onPressed: () {
                    var authentication = FirebaseAuth.instance;
                    authentication.sendPasswordResetEmail(email: 'wind7129@naver.com')
                        .then((value) => print('발송완료'))
                        .catchError((error) { print(error); });
                  }, // onPressed
                  child: Text('비번 재설정', ),
                ),

                SizedBox(height: 20,),

                OutlinedButton(
                  onPressed: () async{
                    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('todo').get();
                    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
                    print(_myDocCount.length);  /// 542


                    // FirebaseFirestore.instance.collection('todo').get().then(
                    //       (value) => value.docs.forEach((element) {
                    //     var docRef = FirebaseFirestore.instance.collection('academic').doc(element.id);
                    //     docRef.update({'color': 'color1'});
                    //   },
                    //   ),
                    // );
                  }, // onPressed
                  child: Text('할일 complete필드 추가', ),
                ),

                SizedBox(height: 20,),

                OutlinedButton(
                  onPressed: () async{

                    FirebaseFirestore.instance.collection('attendance')
                    // .where('email', isEqualTo: 'tjddk1379@naver.com').where('yyyy', isEqualTo: '2023').get().then(
                        .where('email', isEqualTo: 'umssam00@gmail.com').where('yyyy', isEqualTo: '2023').get().then(
                          (value) => value.docs.forEach((element) {
                        FirebaseFirestore.instance.collection('attendance').doc(element.id).delete();
                      },
                      ),
                    );

                  }, // onPressed
                  child: Text('2023 출석부 삭제1', ),
                ),

                SizedBox(height: 20,),

                OutlinedButton(
                  onPressed: () async{

                    FirebaseFirestore.instance.collection('completetodo')
                        .where('email', isEqualTo: 'umssam00@gmail.com').get().then(
                          (value) => value.docs.forEach((element) {
                        FirebaseFirestore.instance.collection('completetodo').doc(element.id).delete();
                      },
                      ),
                    );

                  }, // onPressed
                  child: Text('완료 삭제', ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  void noticeAddDialog(BuildContext context) {
    NoticeController.to.noticeInput = '';
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: SingleChildScrollView(
            child: Container(
              height: 700, width: 400,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close_outlined, color: Colors.grey,),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),

                  TextField(
                    onChanged: (value) {NoticeController.to.noticeInput = value;},
                    maxLines: 20,
                    style: TextStyle(fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "내용을 입력하세요", border: InputBorder.none,),
                  ),

                  TextField(
                    onChanged: (value) {NoticeController.to.image_url1 = value;},
                    style: TextStyle(color: Colors.black, fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "이미지 url1 입력", border: InputBorder.none,),
                  ),
                  TextField(
                    onChanged: (value) {NoticeController.to.image_url2 = value;},
                    style: TextStyle(color: Colors.black, fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "이미지 url2 입력", border: InputBorder.none,),
                  ),
                  TextField(
                    onChanged: (value) {NoticeController.to.image_url3 = value;},
                    style: TextStyle(color: Colors.black, fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "이미지 url3 입력", border: InputBorder.none,),
                  ),
                  TextField(
                    onChanged: (value) {NoticeController.to.image_url4 = value;},
                    style: TextStyle(color: Colors.black, fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "이미지 url4 입력", border: InputBorder.none,),
                  ),
                  TextField(
                    onChanged: (value) {NoticeController.to.image_url5 = value;},
                    style: TextStyle(color: Colors.black, fontSize: 15.0,),
                    decoration: InputDecoration(hintText: "이미지 url5 입력", border: InputBorder.none,),
                  ),

                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (NoticeController.to.noticeInput.length > 0) {
                        NoticeController.to.saveNotice();
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장',),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void noticeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 400,
            height: 550,

            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                    Text('알림'),
                    GetStorage().read('email') == 'umssam00@gmail.com'
                        ? InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        noticeAddDialog(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 30,
                        // height: 50,
                        child: Icon(Icons.add_circle_outline, size: 28, color: Colors.grey,),
                      ),
                    )
                        : SizedBox(),

                  ],
                ),

                SizedBox(height: 10,),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('notice').orderBy('date', descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                      }
                      return Container(
                        padding: EdgeInsets.only(top: 20),
                        height: 500,
                        child: ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child:
                              InkWell(
                                onTap: () {
                                  NoticeController.to.id = doc.id;
                                  NoticeController.to.doc = doc;
                                  NoticeController.to.noticeInput = doc['content'];
                                  noticeDetailDialog(context);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Text((index+1).toString(), style: TextStyle(fontSize: 11, color: Colors.white),),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 310,
                                          child: Text(doc['content'], overflow: TextOverflow.ellipsis, maxLines: 1),
                                        ),
                                        Text(doc['date'].toDate().toString().substring(2,4) + '.' + doc['date'].toDate().toString().substring(5,7)
                                            + '.' + doc['date'].toDate().toString().substring(8,10) + '(' +
                                            DateFormat.E('ko_KR').format(doc['date'].toDate()) + ')',
                                          style: TextStyle(fontSize: 12, color: Colors.grey,),
                                        ),
                                      ],
                                    ),
                                    GetStorage().read('email') == 'umssam00@gmail.com' ?
                                    Text(doc['cnt'].toString()) :
                                    SizedBox(),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) {
                            return Divider(color: Colors.grey.withOpacity(0.7),);
                          },

                        ),
                      );
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void noticeDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0),),),
          content: Container(
            width: 500,
            height: 750,
            child: NoticeDetail(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CustomPopupMenuController gamesController = CustomPopupMenuController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 20,),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                "assets/images/logo.png",
                width: 40,
                // height: 30,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Row(children: [
                Text('학급', style: TextStyle(color: Colors.orange.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 13),),
                Text('다이어리', style: TextStyle(color: Colors.teal.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 13),),
              ],),
              /// 1월, 2월 처리
              DateTime.now().month == 1 || DateTime.now().month == 2 ?
              Text(' (${(DateTime.now().year - 1).toString()} 학년도)', style: TextStyle(color: Colors.white),) :
              Text(' (${(DateTime.now().year).toString()} 학년도)', style: TextStyle(color: Colors.white),),
              // Text('(${GetStorage().read('email')})', style: TextStyle(color: Colors.white, fontSize: 13),),
              // Text('(${SignInUpController.to.userID})', style: TextStyle(color: Colors.white, fontSize: 13),),
            ],),


          ],
        ),
        Row(
          children: [
            buildMenu('출결관리', context),
            SizedBox(width: 35,),
            buildMenu('체크리스트', context),
            SizedBox(width: 30,),
            buildMenu('평가관리', context),
            SizedBox(width: 35,),
            buildMenu('이번주', context),
            // SizedBox(width: 35,),
            // buildMenu('학사일정'),기
            SizedBox(width: 35,),
            buildMenu('상담일지', context),
            SizedBox(width: 35,),
            buildMenu('노트', context),
            SizedBox(width: 35,),
            // GetStorage().read('email') == 'umssam00@gmail.com' ?
            // buildMenu('학급보드', context) : SizedBox(),
            // SizedBox(width: 35,),
            // GetStorage().read('email') == 'umssam00@gmail.com' ?
            // buildMenu('   퀴즈   ', context) : SizedBox(),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('hosefina_access').where('email', isEqualTo: GetStorage().read('email')).snapshots(),
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
                    // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                  }
                  if (snapshot.data!.docs.length > 0) {
                    return CustomPopupMenu(
                      menuOnChange: (bool) {
                        DashboardController.to.isHoverBoard.value = false;
                        DashboardController.to.isHoverQuiz.value = false;
                        DashboardController.to.isHoverAuction.value = false;
                        DashboardController.to.isHoverMemento.value = false;
                        DashboardController.to.isHoverMoney.value = false;
                        DashboardController.to.isHoverTrade.value = false;
                        DashboardController.to.isHoverThermostat.value = false;
                        DashboardController.to.isHoverDiary.value = false;
                        DashboardController.to.isHoverExam.value = false;
                        DashboardController.to.isHoverPoint.value = false;
                        DashboardController.to.isHoverCoupon.value = false;
                        DashboardController.to.isHoverSubject.value = false;

                        /// 교사가 회원가입을 하고 학급보드를 클릭하면 출석부정보를 가져오지 못히니 로그인하게 만듬,
                        /// 또는 job이 없으면(예전부터 학다 사용자가가 로그인없이 들어올때 setUser() 다시 콜 안하다 싶어서
                        // if (AttendanceController.to.attendanceList.length == 0 || GetStorage().read('job') == null ) {
                        //   SignInUpController.to.signOut();
                        // }

                        /// (2024.3.1)회원가입을 하면 job=teacher로 자동으로 가지고 바로 출석부init화면을 띄움. 그래서 setUser() 로 안가서 setClassCode() 못해서 class_info 등록이 안됨.
                        /// 그래서 호세피나 클릭하면 무조건 setClassCode() 로 가게 수정
                        ClassController.to.setClassCode();

                      },
                      controller: gamesController,
                      arrowSize: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/hosefina_icon.png', width: 47,),
                          // Icon(Icons.videogame_asset, color: Colors.orangeAccent,),
                          Text('호세피나', style: TextStyle(color: Colors.white,),),
                        ],
                      ),
                      menuBuilder: () => ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        child: Obx(() => Container(
                          width: 400,
                          // width: 350,
                          height: 150,
                          color: Color(0xFF4C4C4C),
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          /// 오늘 날짜로 보여주기
                                          String month = DateFormat('MM').format(DateTime.now());
                                          String day = DateFormat('dd').format(DateTime.now());
                                          String dayofweek = DateFormat('EEE', 'ko_KR').format(DateTime.now());
                                          DiaryController.to.current_page_index.value = DiaryController.to.diary_days.indexOf('${month}월 ${day}일(${dayofweek})');

                                          gamesController.hideMenu();
                                          DiaryController.to.active_screen.value = 'diary';
                                          Get.to(() => DiaryMain());
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverDiary.value = true;
                                          }else{
                                            DashboardController.to.isHoverDiary.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.note_alt_outlined, color: DashboardController.to.isHoverDiary.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('생활공책', style: TextStyle(color: DashboardController.to.isHoverDiary.value == true ? Colors.tealAccent : Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async{
                                          /// 주제목록 가져오기
                                          SubjectController.to.mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
                                          await SubjectController.to.getSubjects();
                                          gamesController.hideMenu();
                                          SubjectController.to.active_screen.value = 'subject';
                                          Get.to(() => SubjectMain());

                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverSubject.value = true;
                                          }else{
                                            DashboardController.to.isHoverSubject.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.menu_book_outlined, color: DashboardController.to.isHoverSubject.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('주제일기', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          Get.to(() => BoardMain());
                                          // html.window.open('http://localhost:4756/?paramTab=board', 'new tab');
                                          DashboardController.to.game_gubun = '보드';

                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverBoard.value = true;
                                          }else{
                                            DashboardController.to.isHoverBoard.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.event_note, color: DashboardController.to.isHoverBoard.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('학급보드', style: TextStyle(color: DashboardController.to.isHoverBoard.value == true ? Colors.tealAccent : Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          QuizController.to.active_screen.value = 'myquiz';
                                          QuizController.to.setPlayer();
                                          DashboardController.to.game_gubun = '퀴즈';

                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverQuiz.value = true;
                                          }else{
                                            DashboardController.to.isHoverQuiz.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.wechat_rounded, color: DashboardController.to.isHoverQuiz.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('퀴즈', style: TextStyle(color: DashboardController.to.isHoverQuiz.value == true ? Colors.tealAccent : Colors.white,),),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          CouponController.to.active_screen.value = 'coupon';
                                          Get.to(() => CouponMain());

                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverCoupon.value = true;
                                          }else{
                                            DashboardController.to.isHoverCoupon.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.airplane_ticket_outlined, color: DashboardController.to.isHoverCoupon.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('쿠폰가게', style: TextStyle(color: DashboardController.to.isHoverCoupon.value == true ? Colors.tealAccent : Colors.white,),),
                                          ],
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          TemperController.to.active_screen.value = 'temperature';
                                          Get.to(() => TemperatureMain());
                                          // DashboardController.to.game_gubun = '학급온도계';
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverThermostat.value = true;
                                          }else{
                                            DashboardController.to.isHoverThermostat.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.device_thermostat, color: DashboardController.to.isHoverThermostat.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('학급온도계', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          PointController.to.active_screen.value = 'point';
                                          Get.to(() => PointMain());
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverPoint.value = true;
                                          }else{
                                            DashboardController.to.isHoverPoint.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.star_border_outlined, color: DashboardController.to.isHoverPoint.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('포인트', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          ExamController.to.active_screen.value = 'exam_all';
                                          Get.to(() => ExamMain());
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isRelation.value = true;
                                          }else{
                                            DashboardController.to.isRelation.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.people, color: DashboardController.to.isRelation.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('교우관계', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          SurveyController.to.active_screen.value = 'survey';
                                          Get.to(() => SurveyMain());
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isSurvey.value = true;
                                          }else{
                                            DashboardController.to.isSurvey.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.bar_chart_rounded, color: DashboardController.to.isSurvey.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('설문지', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          gamesController.hideMenu();
                                          ExamController.to.active_screen.value = 'exam_all';
                                          Get.to(() => ExamMain());
                                        },
                                        onHover: (isHovering) {
                                          if(isHovering) {
                                            DashboardController.to.isHoverExam.value = true;
                                          }else{
                                            DashboardController.to.isHoverExam.value = false;
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.calculate_outlined, color: DashboardController.to.isHoverExam.value == true ? Colors.tealAccent : Colors.white,),
                                            Text('진단평가', style: TextStyle(color: Colors.white,),),
                                          ],
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                              ]
                          ),
                        ),
                        ),
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                    );
                  }else {
                    return SizedBox(width: 60,);
                  }
                }
            ),
            // (GetStorage().read('email') == 'umssam00@gmail.com' || GetStorage().read('email') == 'wind7129@naver.com' || GetStorage().read('email') == 'wind1111@naver.com') ?
            // CustomPopupMenu(
            //   menuOnChange: (bool) {
            //     DashboardController.to.isHoverBoard.value = false;
            //     DashboardController.to.isHoverQuiz.value = false;
            //     DashboardController.to.isHoverAuction.value = false;
            //     DashboardController.to.isHoverMemento.value = false;
            //     DashboardController.to.isHoverMoney.value = false;
            //     DashboardController.to.isHoverTrade.value = false;
            //     DashboardController.to.isHoverThermostat.value = false;
            //     DashboardController.to.isHoverDiary.value = false;
            //     DashboardController.to.isHoverExam.value = false;
            //     DashboardController.to.isHoverPoint.value = false;
            //     DashboardController.to.isHoverCoupon.value = false;
            //     DashboardController.to.isHoverSubject.value = false;
            //
            //     /// 교사가 회원가입을 하고 학급보드를 클릭하면 출석부정보를 가져오지 못히니 로그인하게 만듬,
            //     /// 또는 job이 없으면(예전부터 학다 사용자가가 로그인없이 들어올때 setUser() 다시 콜 안하다 싶어서
            //     // if (AttendanceController.to.attendanceList.length == 0 || GetStorage().read('job') == null ) {
            //     //   SignInUpController.to.signOut();
            //     // }
            //
            //     /// (2024.3.1)회원가입을 하면 job=teacher로 자동으로 가지고 바로 출석부init화면을 띄움. 그래서 setUser() 로 안가서 setClassCode() 못해서 class_info 등록이 안됨.
            //     /// 그래서 호세피나 클릭하면 무조건 setClassCode() 로 가게 수정
            //     ClassController.to.setClassCode();
            //
            //   },
            //   controller: gamesController,
            //   arrowSize: 20,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Image.asset('assets/images/hosefina_icon.png', width: 47,),
            //       // Icon(Icons.videogame_asset, color: Colors.orangeAccent,),
            //       Text('호세피나', style: TextStyle(color: Colors.white,),),
            //     ],
            //     ),
            //   menuBuilder: () => ClipRRect(
            //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            //     child: Obx(() => Container(
            //         width: 350,
            //         height: 150,
            //         color: Color(0xFF4C4C4C),
            //         child: Column(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(20),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     InkWell(
            //                       onTap: () {
            //                         /// 오늘 날짜로 보여주기
            //                         String month = DateFormat('MM').format(DateTime.now());
            //                         String day = DateFormat('dd').format(DateTime.now());
            //                         String dayofweek = DateFormat('EEE', 'ko_KR').format(DateTime.now());
            //                         DiaryController.to.current_page_index.value = DiaryController.to.diary_days.indexOf('${month}월 ${day}일(${dayofweek})');
            //
            //                         gamesController.hideMenu();
            //                         DiaryController.to.active_screen.value = 'diary';
            //                         Get.to(() => DiaryMain());
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverDiary.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverDiary.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.note_alt_outlined, color: DashboardController.to.isHoverDiary.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('생활공책', style: TextStyle(color: DashboardController.to.isHoverDiary.value == true ? Colors.tealAccent : Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //                     InkWell(
            //                       onTap: () async{
            //                         /// 주제목록 가져오기
            //                         SubjectController.to.mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
            //                         await SubjectController.to.getSubjects();
            //                         gamesController.hideMenu();
            //                         SubjectController.to.active_screen.value = 'subject';
            //                         Get.to(() => SubjectMain());
            //
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverSubject.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverSubject.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.menu_book_outlined, color: DashboardController.to.isHoverSubject.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('주제일기', style: TextStyle(color: Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //                     InkWell(
            //                         onTap: () {
            //                           gamesController.hideMenu();
            //                           Get.to(() => BoardMain());
            //                           // html.window.open('http://localhost:4756/?paramTab=board', 'new tab');
            //                           DashboardController.to.game_gubun = '보드';
            //
            //                         },
            //                         onHover: (isHovering) {
            //                            if(isHovering) {
            //                              DashboardController.to.isHoverBoard.value = true;
            //                            }else{
            //                              DashboardController.to.isHoverBoard.value = false;
            //                            }
            //                         },
            //                         child: Column(
            //                           mainAxisAlignment: MainAxisAlignment.end,
            //                           children: [
            //                             Icon(Icons.event_note, color: DashboardController.to.isHoverBoard.value == true ? Colors.tealAccent : Colors.white,),
            //                             Text('학급보드', style: TextStyle(color: DashboardController.to.isHoverBoard.value == true ? Colors.tealAccent : Colors.white,),),
            //                           ],
            //                         ),
            //                     ),
            //                     InkWell(
            //                       onTap: () {
            //                         gamesController.hideMenu();
            //                         QuizController.to.active_screen.value = 'myquiz';
            //                         QuizController.to.setPlayer();
            //                         DashboardController.to.game_gubun = '퀴즈';
            //
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverQuiz.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverQuiz.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.wechat_rounded, color: DashboardController.to.isHoverQuiz.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('퀴즈', style: TextStyle(color: DashboardController.to.isHoverQuiz.value == true ? Colors.tealAccent : Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //
            //
            //                   ],
            //
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 20, right: 20),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     InkWell(
            //                       onTap: () {
            //                         gamesController.hideMenu();
            //                         CouponController.to.active_screen.value = 'coupon';
            //                         Get.to(() => CouponMain());
            //
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverCoupon.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverCoupon.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.airplane_ticket_outlined, color: DashboardController.to.isHoverCoupon.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('쿠폰가게', style: TextStyle(color: DashboardController.to.isHoverCoupon.value == true ? Colors.tealAccent : Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //                     InkWell(
            //                       onTap: () {
            //                         gamesController.hideMenu();
            //                         TemperController.to.active_screen.value = 'temperature';
            //                         Get.to(() => TemperatureMain());
            //                         // DashboardController.to.game_gubun = '학급온도계';
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverThermostat.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverThermostat.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.device_thermostat, color: DashboardController.to.isHoverThermostat.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('학급온도계', style: TextStyle(color: Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //                     InkWell(
            //                       onTap: () {
            //                         gamesController.hideMenu();
            //                         PointController.to.active_screen.value = 'point';
            //                         Get.to(() => PointMain());
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverPoint.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverPoint.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.star_border_outlined, color: DashboardController.to.isHoverPoint.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('포인트', style: TextStyle(color: Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //
            //                     InkWell(
            //                       onTap: () {
            //                         gamesController.hideMenu();
            //                         ExamController.to.active_screen.value = 'exam_all';
            //                         Get.to(() => ExamMain());
            //                       },
            //                       onHover: (isHovering) {
            //                         if(isHovering) {
            //                           DashboardController.to.isHoverExam.value = true;
            //                         }else{
            //                           DashboardController.to.isHoverExam.value = false;
            //                         }
            //                       },
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Icon(Icons.calculate_outlined, color: DashboardController.to.isHoverExam.value == true ? Colors.tealAccent : Colors.white,),
            //                           Text('진단평가', style: TextStyle(color: Colors.white,),),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //
            //                 ),
            //               ),
            //             ]
            //         ),
            //       ),
            //     ),
            //   ),
            //   pressType: PressType.singleClick,
            //   verticalMargin: -10,
            // )
            //     : SizedBox(),

            SizedBox(width: 60,),
            /// 다크모드
            Obx(
                  () => Column(children: [
                SizedBox(height: 15,),
                Row(
                  children: [
                    Icon(Icons.dark_mode, color: SignInUpController.to.isDarkMode.value == true ? Colors.grey : Colors.white,),
                    Switch(
                      activeColor: Colors.amber,
                      activeTrackColor: Colors.cyan,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      value: SignInUpController.to.isDarkMode.value,
                      onChanged: (value) {
                        SignInUpController.to.isDarkMode.value = value;
                        GetStorage().write('isDarkMode', value);
                      },
                    ),

                  ],
                ),
              ],),
            ),

          ],
        ),
        Row(
          children: [
            /// 반코드
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('hosefina_access').where('email', isEqualTo: GetStorage().read('email')).snapshots(),
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
                    // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                  }
                  if (snapshot.data!.docs.length > 0) {
                    return InkWell(
                      onTap: () {
                        classCodeDialog(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.handshake_outlined, color: Colors.white,),
                          Text('반코드', style: TextStyle(color: Colors.white,),),
                        ],
                      ),
                    );
                  }else {
                    return SizedBox(width: 60,);
                  }
                }
            ),
            // if(GetStorage().read('email') == 'umssam00@gmail.com')
            //   buildMenu('반코드', context),
            SizedBox(width: 30,),
            if(GetStorage().read('email') == 'umssam00@gmail.com')
              buildMenu('관리자', context),
            SizedBox(width: 30,),
            buildMenu('알림', context),
            // StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance.collection('notice').snapshots(),
            //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (!snapshot.hasData) {
            //         return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
            //       }
            //       var results = snapshot.data!.docs.where((doc) => doc['email'].contains(GetStorage().read('email'))).toList().length;
            //       NoticeController.to.noReadCnt.value = snapshot.data!.docs.length - results;
            //     return Container(
            //       width: 35,
            //       child: Stack(
            //         children: [
            //           buildMenu('알림', context),
            //           if(NoticeController.to.noReadCnt.value != 0)
            //           Positioned(
            //             top: 10,
            //             left: 14,
            //             child: Container(
            //               width: 18, height: 18,
            //               child: CircleAvatar(
            //                 backgroundColor: Colors.red,
            //                 child: Center(
            //                   child: Text(NoticeController.to.noReadCnt.value.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }
            // ),
            SizedBox(width: 30,),
            buildMenu('로그아웃', context),
            SizedBox(width: 40,),
          ],
        ),
      ],
    );
  }

  InkWell buildMenu(menu, context) {
    return InkWell(
      onTap: () async{
        if (menu == '로그아웃') {
          SignInUpController.to.signOut();
          GetStorage().remove('job');
        }else if (menu == '알림'){
          noticeDialog(context);
        }
        // else if (menu == '반코드'){
        //   classCodeDialog(context);
        // }
        else if (menu == '관리자'){
          adminDialog(context);
        }else if (menu == '학급보드') {
          /// 교사가 회원가입을 하고 학급보드를 클릭하면 출석부정보를 가져오지 못히니 로그인하게 만듬,
          /// 또는 job이 없으면(예전부터 학다 사용자가가 로그인없이 들어올때 setUser() 다시 콜 안하다 싶어서
          if (AttendanceController.to.attendanceList.length == 0 ||
              GetStorage().read('job') == null ) {
            SignInUpController.to.signOut();
          }else {
            Get.to(() => BoardMain());
          }
        }else if (menu == '   퀴즈   ') {
          QuizController.to.active_screen.value = 'all';
          QuizController.to.setPlayer();
        }else {
          DashboardController.to.setClickedMenu(menu);
        }

      },
      onHover: (isHovering) {
        if (isHovering) {
          switch(menu) {
            case '출결관리' : DashboardController.to.isHoverAbsent.value = true; break;
            case '체크리스트' : DashboardController.to.isHoverCheck.value = true; break;
            case '평가관리' : DashboardController.to.isHoverEval.value = true; break;
            case '이번주' : DashboardController.to.isHoverThisWeek.value = true; break;
            case '학사일정' : DashboardController.to.isHoverAcademic.value = true; break;
            case '상담일지' : DashboardController.to.isHoverConsult.value = true; break;
            case '노트' : DashboardController.to.isHoverNote.value = true; break;
            case '알림' : DashboardController.to.isHoverShortcut.value = true; break;
            case '로그아웃' : DashboardController.to.isHoverLogout.value = true; break;
            case '학급보드' : DashboardController.to.isHoverBell.value = true; break;
            case '   퀴즈   ' : DashboardController.to.isHoverQuiz.value = true; break;
          }
        } else {
          switch(menu) {
            case '출결관리' : DashboardController.to.isHoverAbsent.value = false; break;
            case '체크리스트' : DashboardController.to.isHoverCheck.value = false; break;
            case '평가관리' : DashboardController.to.isHoverEval.value = false; break;
            case '이번주' : DashboardController.to.isHoverThisWeek.value = false; break;
            case '학사일정' : DashboardController.to.isHoverAcademic.value = false; break;
            case '상담일지' : DashboardController.to.isHoverConsult.value = false; break;
            case '노트' : DashboardController.to.isHoverNote.value = false; break;
            case '알림' : DashboardController.to.isHoverShortcut.value = false; break;
            case '로그아웃' : DashboardController.to.isHoverLogout.value = false; break;
            case '학급보드' : DashboardController.to.isHoverBell.value = false; break;
            case '   퀴즈   ' : DashboardController.to.isHoverQuiz.value = false; break;
          }
        }
      },
      child: Obx(
            () => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(changeMenuIcon(menu), color: changeMenuColor(menu),),
            Text(menu, style: TextStyle(color: changeMenuColor(menu),),),
          ],
        ),
      ),
    );
  }

  IconData changeMenuIcon(menu) {
    switch(menu) {
    // case '출결관리' : return Icons.groups_rounded; break;
      case '출결관리' : return Icons.people_outline; break;
      case '체크리스트' : return Icons.task_alt; break;
    // case '평가관리' : return Icons.library_add_check; break;
      case '평가관리' : return Icons.style_outlined; break;
      case '이번주' : return Icons.today_outlined; break;
      case '학사일정' : return Icons.calendar_month_outlined; break;
    // case '상담일지' : return Icons.people_alt; break;
      case '상담일지' : return Icons.sentiment_very_dissatisfied; break;
      case '노트' : return Icons.drive_file_rename_outline_outlined; break;
      case '알림' : return Icons.notifications; break;
      case '로그아웃' : return Icons.logout_outlined; break;
      case '학급보드' : return Icons.event_note; break;
      case '   퀴즈   ' : return Icons.wechat_rounded; break;
      // case '반코드' : return Icons.handshake_outlined; break;
      case '관리자' : return Icons.admin_panel_settings_outlined; break;
      default : return Icons.groups_rounded; break;
    }
  }

  Color changeMenuColor(menu) {
    if (DashboardController.to.isHoverAbsent == true && menu == '출결관리' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverCheck == true  && menu == '체크리스트' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverEval == true  && menu == '평가관리' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverThisWeek == true  && menu == '이번주' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverAcademic == true  && menu == '학사일정' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverConsult == true  && menu == '상담일지' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverNote == true  && menu == ' 노트 ' ) {
      return Colors.orange.withOpacity(0.7);
    }
    // else if(DashboardController.to.isHoverShortcut == true  && menu == '단축키소개' ) {
    //   return Colors.orange.withOpacity(0.7);
    // }
    else if(DashboardController.to.isHoverLogout == true  && menu == '로그아웃' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverBell == true  && menu == '학급보드' ) {
      return Colors.orange.withOpacity(0.7);
    }else if(DashboardController.to.isHoverQuiz == true  && menu == '   퀴즈   ' ) {
      return Colors.orange.withOpacity(0.7);
    }
    else{
      return Colors.white;
    }
  }

}



