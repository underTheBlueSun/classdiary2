import 'package:classdiary2/controller/signinup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel)),
            Icon(Icons.cancel, color: Colors.transparent,),
        ],),
        SizedBox(height: 30,),
        Text('이메일을 입력하시면\n비밀번호 초기화 메일을 전송합니다.'),
        SizedBox(height: 50,),
        TextField(
          autofocus: true,
          onChanged: (value) {
            SignInUpController.to.forgotPassword.value = value.trim();
          },
          maxLines: 1,
          style: TextStyle(fontSize: 15.0,),
          decoration: InputDecoration(
            // filled: true, //<-- SEE HERE
            // fillColor: Colors.grey.withOpacity(0.5),
            hintText: "이메일을 입력하세요",
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 30,),

        Container(
          width: 350,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (SignInUpController.to.forgotPassword.value.length > 0) {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: SignInUpController.to.forgotPassword.value);
                      Navigator.pop(context);
              }
            }, // onPressed
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('비밀번호초기화 메일 전송',
              style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),

    ],);
  }

}



