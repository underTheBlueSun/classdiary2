import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/timetable_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'board_controller.dart';
import 'class_controller.dart';

class SignInUpController extends GetxController {
  static SignInUpController get to => Get.find();
  var authentication = FirebaseAuth.instance;

  String userID = '';
  RxBool isClickedLogin = true.obs;
  RxString email = ''.obs;
  RxString pwd = ''.obs;
  RxString pwd2 = ''.obs;
  RxString forgotPassword = ''.obs;
  RxBool isDarkMode = false.obs;
  RxBool is_invalid_message = false.obs;

  @override
  void onInit() async {
    super.onInit();

    setDarkMode();

  }

  void setDarkMode() {
    if (GetStorage().read('isDarkMode') != null) {
      isDarkMode.value = GetStorage().read('isDarkMode');
    }else {
      isDarkMode.value = false;
    }
  }

  String validate(context) {
    if (isClickedLogin == false) {
      if (email.isEmpty || !email.contains('@') || pwd.value.length < 6 || pwd2.value.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: SizedBox(
                child: Text('이메일 또는 비밀번호가 정확하지 않습니다'),
              ),
              duration: Duration(seconds: 3),
            )
        );
        return 'invalid';
      }
      if (pwd != pwd2) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: SizedBox(
                child: Text('비밀번호가 일치하지 않습니다'),
              ),
              duration: Duration(seconds: 3),
            )
        );
        return 'invalid';
      }
    }else {
      if (email.isEmpty || !email.contains('@') || pwd.value.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: SizedBox(
                child: Text('이메일 또는 비밀번호가 정확하지 않습니다'),
              ),
              duration: Duration(seconds: 3),
            )
        );
        return 'invalid';
      }
    }
    return 'valid';
  } // validate

  Future<UserCredential>  regNewUser() async{
    final userCredential = await authentication.createUserWithEmailAndPassword(email: email.value, password: pwd.value);
    GetStorage().write('email', userCredential.user!.email);
    GetStorage().write('job', 'teacher');
    GetStorage().write('name', '선생님');
    GetStorage().write('number', 0);
    if (GetStorage().read('email') != null) {
      /// 출석부 가져오기
      // AttendanceController.to.getAttendance();
      /// 시간표 세팅하기
      TimetableController.to.setTimetable();
      /// 반코드 만들기
      // await ClassController.to.setClassCode();
    }

    return userCredential;
  }

  void  setUserTemp() async{
    GetStorage().write('email', 'aaa0372@naver.com');
    GetStorage().write('job', 'teacher');
    GetStorage().write('name', '선생님');
    GetStorage().write('number', 0);
    if (GetStorage().read('email') != null) {
      /// 출석부 가져오기
      await AttendanceController.to.getAttendance();
      /// 시간표 세팅하기
      TimetableController.to.setTimetable();
    }

  }

  void  setUser() async{
    var user;
    await authentication.signInWithEmailAndPassword(email: email.value, password: pwd.value).then((UserCredential userCredential) async {
      // userID = userCredential.user!.email!;
      user = userCredential;
      GetStorage().write('email', userCredential.user!.email);
      GetStorage().write('job', 'teacher');
      GetStorage().write('name', '선생님');
      GetStorage().write('number', 0);
      if (GetStorage().read('email') != null) {
        /// 출석부 가져오기
        await AttendanceController.to.getAttendance();
        /// 시간표 세팅하기
        TimetableController.to.setTimetable();
        /// 반코드 가져오기
        /// (2024.3.1)회원가입을 하면 job=teacher로 자동으로 가지고 바로 출석부init화면을 띄움. 그래서 setUser() 로 안가서 setClassCode() 못해서 class_info 등록이 안됨.
        /// 그래서 호세피나 클릭하면 무조건 setClassCode() 로 가게 수정
        // await ClassController.to.setClassCode();

      }
    // }).catchError((error) { print(error); });
    }).catchError((error) { SignInUpController.to.is_invalid_message.value = true; });

  }

  Future<void> signOut() async{
    // GetStorage().remove('email');
    await authentication.signOut();

    // Get.to(() => SignInUpView());
  }


}