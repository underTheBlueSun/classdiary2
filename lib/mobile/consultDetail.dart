
import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/mobile/consult.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/services.dart';

import '../controller/signinup_controller.dart';


class ConsultDetail extends StatelessWidget {

  void delDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Container(
                      child: Center(child: Text('정말 삭제하시겠습니까?'))),
                ),
              ],
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
                      ConsultController.to.delConsult();
                      Get.to(() => Consult());
                      // Navigator.pop(context);
                      // ConsultController.to.whereToGo.value = 'Consult';
                    }, // onPressed
                    child: Text('삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                    ),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true, /// back button
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey,),
        title: Text('상담일지', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // ConsultController.to.delConsult();
                      delDialog(context);
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.grey,),
                  ),
                  SizedBox(
                    height: 28,
                    child: OutlinedButton(
                      onPressed: () {
                        if (ConsultController.to.consultInput.length > 0 && Get.arguments == 'add') {
                          ConsultController.to.saveConsult();
                        }else if (ConsultController.to.consultInput.length > 0 && Get.arguments == 'update') {
                          ConsultController.to.updConsult();
                        }
                        Get.to(() => Consult());

                      }, // onPressed
                      child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                      ),),
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  // autofocus: true,
                  controller: TextEditingController(text: ConsultController.to.consultInput),
                  onChanged: (value) {
                    ConsultController.to.consultInput = value;
                  },
                  minLines: 6,
                  maxLines: 35,
                  style: TextStyle(fontSize: 17.0,),
                  decoration: InputDecoration(
                    hintText: "내용을 입력하세요",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }
}


