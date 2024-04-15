import 'dart:html';

import 'package:classdiary2/board_first.dart';
import 'package:classdiary2/board_main.dart';
import 'package:classdiary2/class_entrance.dart';
import 'package:classdiary2/controller/academic_controller.dart';
import 'package:classdiary2/controller/anim_list_controller.dart';
import 'package:classdiary2/controller/board_controller.dart';
import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/controller/mobile_todo_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:classdiary2/controller/notice_controller.dart';
import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:classdiary2/mobile/absent.dart';
import 'package:classdiary2/job_select.dart';
import 'package:classdiary2/mobile/mobile_signinup_view.dart';
import 'package:classdiary2/quiz/quiz_main.dart';
import 'package:classdiary2/quiz/quiz_main_anonymous.dart';
import 'package:classdiary2/quiz/quiz_main_real.dart';
import 'package:classdiary2/quiz/quiz_name_entrance.dart';
import 'package:classdiary2/web/dashboard.dart';
import 'package:classdiary2/web/signinup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auction/auction_main.dart';
import 'controller/attendance_controller.dart';
import 'controller/checklist_controller.dart';
import 'controller/class_controller.dart';
import 'controller/coupon_controller.dart';
import 'controller/dashboard_controller.dart';
import 'controller/diary_controller.dart';
import 'controller/exam_controller.dart';
import 'controller/point_controller.dart';
import 'controller/signinup_controller.dart';
import 'controller/subject_controller.dart';
import 'controller/temper_controller.dart';
import 'controller/temper_controller.dart';
import 'controller/timetable_controller.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/mobile_main_controller.dart';

import 'dart:js' as js;
import 'dart:convert';

/// qr code로 파라미터 받기위해
var paramClassCode;
var paramEmail;
var paramGubun;
var paramIsRealName;
var paramQuizId;
var paramQuizType;
var paramTimer;
var paramModumTotalTimer;
var paramModumIndiTimer;

void getParams() {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  if (params['paramClassCode'] != null) {
    paramClassCode = params['paramClassCode'];
  }

  if (params['paramEmail'] != null) {
    paramEmail = params['paramEmail'];
    /// if 처리 안해주면 classdiary2.app으로만 리로드하면 이메일 널값 됨
    GetStorage().write('email', paramEmail);  // getAttendance()에 필요한 이메일
  }
  if (params['paramGubun'] != null) {
    paramGubun = params['paramGubun'];
  }

  if (params['paramQuizId'] != null) {
    paramQuizId = params['paramQuizId'];
  }

  if (params['paramIsRealName'] != null) {
    paramIsRealName = params['paramIsRealName'];
  }

  if (params['paramQuizType'] != null) {
    paramQuizType = params['paramQuizType'];
  }

  if (params['paramTimer'] != null) {
    paramTimer = params['paramTimer'];
  }

  if (params['paramModumTotalTimer'] != null) {
    paramModumTotalTimer = params['paramModumTotalTimer'];
  }

  if (params['paramModumIndiTimer'] != null) {
    paramModumIndiTimer = params['paramModumIndiTimer'];
  }

}

void main_temp() async {
  /// 밑에 적으면 null 반환함
  await GetStorage.init();

  /// qr code로 파라미터 받기위해
  /// http://localhost:52695/?origin=pointA&destiny=pointB
  getParams();

  // getDeviceType();

  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  GetStorage().write('isMobile', defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  Get.put(AttendanceController());
  Get.put(SignInUpController());
  Get.put(DashboardController());
  Get.put(TimetableController());
  Get.put(ChecklistController());
  Get.put(ThisWeekController());
  Get.put(AcademicController());
  Get.put(ConsultController());
  Get.put(NoteController());
  Get.put(AnimListController());
  Get.put(EstiController());
  Get.put(MobileMainController());
  Get.put(MobileToDoController());
  Get.put(NoticeController());
  // Get.put(SubjectController());
  Get.put(ClassController());
  Get.put(BoardController());
  Get.put(QuizController());
  Get.put(TemperController());
  Get.put(DiaryController());
  Get.put(CouponController());
  Get.put(PointController());
  Get.put(SubjectController());
  Get.put(ExamController());



  if (GetStorage().read('isMobile')) {
    MobileMainController.to.bottomNaviCurrentIndex.value = 0;
  }

  runApp(MyApp(),);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (paramClassCode == null && GetStorage().read('job') != 'student') {
      return Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '학급다이어리',
          theme:
          ThemeData(
            appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontSize: 20,  color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: SignInUpController.to.isDarkMode.value == true ?  Brightness.dark : Brightness.light),
          ),
          home:
          MediaQuery.of(context).size.width < 600 ?
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  /// 로그아웃이 다른 화면으로 네비게이터가 되면 그다음부턴 안먹힘.
                  /// 로그인된 상태에서 앱 삭제하고 다시 설치하면 email이 null 값을 가지고 absent에서 모든 데이터값을 다가져옴
                  /// isEqualTo: null 은 모든 값을 다가져오는 것 같음
                  if (GetStorage().read('email') == null) {
                    FirebaseAuth.instance.signOut();
                    return MobileSignInUpView();
                  }else {
                    return Absent();
                  }

                }else {
                  return MobileSignInUpView();
                }
              }
          ) :
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Dashboard();
                }
                return SignInUpView();
              }
          ),
        ),
      );
    }else if(paramClassCode != null && paramGubun == 'board') {
      /// 퇴장시 보드, 경매,퀴즈 분기를 위해
      BoardController.to.param_gubun = paramGubun;
      return Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '학급보드',
          theme:
          ThemeData(
            appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontSize: 20,  color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: SignInUpController.to.isDarkMode.value == true ?  Brightness.dark : Brightness.light),
          ),
          home:
          (paramClassCode != null && GetStorage().read('class_code') == null) ||
              (paramClassCode != null && (paramClassCode != GetStorage().read('class_code')) ) ?  // 퇴장 안하고 다른 paramclasscode로 입장시도
          ClassEntrance(paramClassCode) :
          BoardMain(),
        ),
      );
    }else if(paramClassCode != null && paramGubun == 'quiz') {
      /// 퇴장시 보드, 경매,퀴즈 분기를 위해
      BoardController.to.param_gubun = paramGubun;
      QuizController.to.quiz_class_code = paramClassCode;
      QuizController.to.quiz_id = paramQuizId;
      QuizController.to.quiz_quiz_type.value = paramQuizType;
      QuizController.to.quiz_indi_timer.value = paramTimer;
      QuizController.to.quiz_modum_total_timer.value = paramModumTotalTimer;
      QuizController.to.quiz_modum_indi_timer.value = paramModumIndiTimer;
      QuizController.to.is_real_name = paramIsRealName == 'yes' ? true : false;
      return Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '퀴즈',
          theme:
          ThemeData(
            appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(fontSize: 20,  color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black)),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white, brightness: SignInUpController.to.isDarkMode.value == true ?  Brightness.dark : Brightness.light, ),
          ),
          home:
          (paramClassCode != null && GetStorage().read('class_code') == null) ||
              (paramClassCode != null && (paramClassCode != GetStorage().read('class_code')) ) ?  // 퇴장 안하고 다른 paramclasscode로 입장시도
          ClassEntrance(paramClassCode) :
          paramIsRealName == 'yes' ? QuizMainReal() : QuizMainAnonymous(),

        ),
      );
    }else if(paramClassCode != null && paramGubun == 'auction') {
      /// 퇴장시 보드, 경매,퀴즈 분기를 위해
      BoardController.to.param_gubun = paramGubun;
      return Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '경매놀이',
          theme:
          ThemeData(
            appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(fontSize: 20,  color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black)),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white, brightness: SignInUpController.to.isDarkMode.value == true ?  Brightness.dark : Brightness.light, ),
          ),
          home:
          (paramClassCode != null && GetStorage().read('class_code') == null) ||
              (paramClassCode != null && (paramClassCode != GetStorage().read('class_code')) ) ?  // 퇴장 안하고 다른 paramclasscode로 입장시도
          ClassEntrance(paramClassCode) :
          AuctionMain(),
        ),
      );
    } else {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: '새로고침,뒤로가기',
        theme:
        ThemeData(
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(fontSize: 20,  color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black)),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, brightness: SignInUpController.to.isDarkMode.value == true ?  Brightness.dark : Brightness.light, ),
        ),
        home:
        Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: Center(child: Text('QR 코드를 다시 찍고 들어오세요', style: TextStyle(color: Colors.black, fontFamily: 'Jua',fontSize: 20),)),
        ),
      );
    }
  }
}


