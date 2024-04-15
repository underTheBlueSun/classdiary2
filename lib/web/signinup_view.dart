import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/signinup_controller.dart';
import 'package:classdiary2/web/attendance_init.dart';
import 'package:classdiary2/web/attendance_reg.dart';
import 'package:classdiary2/web/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'dart:html';
import 'package:get_storage/get_storage.dart';

import 'forgotPassword.dart';

// ignore_for_file: prefer_const_constructors

class SignInUpView extends StatelessWidget {

  void regDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 350,
            height: 700,
            child: AttendanceInit(),
          ),
        );
      },
    );
  }

  void passwordDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            width: 350,
            height: 350,
            child: ForgotPassword(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (GetStorage().read('email') != null) {
      SignInUpController.to.email.value = GetStorage().read('email');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text('학급다이어리', style: TextStyle(color: Colors.white),),
            // Text(MediaQuery.of(context).size.width.toString(), style: TextStyle(color: Colors.white),),
            // Text(Get.width.toString(), style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
      body: Obx(
            () => Center(
              child: Container(
                width: 350,
                child: Container(
                  height: 600,
                  child: Column(
                    children: [
                      SignInUpController.to.isDarkMode.value == true ?
                    Image.asset("assets/images/logo_big_dark.png", width: 130,) :
                    Image.asset("assets/images/logo_big_light.png", width: 130,),

                      SizedBox(height: 50,),
                      /// 로그인, 회원가입 선택
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              SignInUpController.to.isClickedLogin.value = true;
                            },
                            child: Column(
                              children: [
                                Text('로그인'),
                                if (SignInUpController.to.isClickedLogin == true)
                                  Container(
                                    height: 2.0,
                                    width: 40.0,
                                    color: Colors.orange.withOpacity(0.7),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              SignInUpController.to.isClickedLogin.value = false;
                            },
                            child: Column(
                              children: [
                                Text('회원가입'),
                                if (SignInUpController.to.isClickedLogin.value ==
                                    false)
                                  Container(
                                    height: 2.0,
                                    width: 50.0,
                                    color: Colors.orange.withOpacity(0.7),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Form(
                          child: Column(
                            children: [
                              buildTextFormField('이메일', (value) {SignInUpController.to.email.value = value;}, context),
                              SizedBox(height: 15,),
                              buildTextFormField('비밀번호(6자리이상)', (value) {SignInUpController.to.pwd.value = value;}, context),
                              SizedBox(
                                height: 15,
                              ),
                              if (SignInUpController.to.isClickedLogin.value == false)
                                buildTextFormField('비밀번호 확인', (value) {SignInUpController.to.pwd2.value = value;}, context),
                              SizedBox(height: 20,),
                              Obx(() => Visibility(
                                    visible: SignInUpController.to.is_invalid_message.value,
                                    child: Text('비밀번호가 일치하지 않습니다', style: TextStyle(color: Colors.red),),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 350,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    validLogin(context);
                                  }, // onPressed
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    SignInUpController.to.isClickedLogin.value == false
                                        ? '가입하기'
                                        : '로그인하기',
                                    // style: TextStyle(fontSize: 24,),
                                  style: TextStyle(fontWeight: FontWeight.bold,),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                          onTap: () {
                            passwordDialog(context);
                          },
                          child: Text('비밀번호재설정', style: TextStyle(decoration: TextDecoration.underline,), ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void validLogin(context) async{
    ///  회원가입
    if (SignInUpController.to.isClickedLogin.value == false && SignInUpController.to.validate(context) == 'valid') {
      try {
        ///  정상적으로 사용자가 등록되면
        UserCredential userCredential = await SignInUpController.to.regNewUser();
        if (userCredential.user != null) {
          regDialog(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SizedBox(
            child: Text('이메일 또는 비밀번호를 다시 확인하세요'),
          ),
          duration: Duration(seconds: 3),
        ));
      } // catch
    } else if (SignInUpController.to.isClickedLogin.value == true && SignInUpController.to.validate(context) == 'valid') {
      try {
        ///  정상적으로 로그인 되면
        SignInUpController.to.is_invalid_message.value = false;
        SignInUpController.to.setUser();
      } catch (e) {
        SignInUpController.to.is_invalid_message.value = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SizedBox(
            child: Text('이메일 또는 비밀번호를 다시 확인하세요'),
          ),
          duration: Duration(seconds: 3),
        ),
        );
      } // catch
    }
  }

  buildTextFormField(text, Function(String)? onChanged, context) {
    return TextFormField(
    controller: TextEditingController(text: text == '이메일' ? GetStorage().read('email') : ''),
      onFieldSubmitted: (value) {
        validLogin(context);
      },
      keyboardType: TextInputType.emailAddress,
      obscureText: text == '이메일' ? false : true,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(
          text == '이메일' ? Icons.email : Icons.lock,
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(35.0),
          ),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }


}




