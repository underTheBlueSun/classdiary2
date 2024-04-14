
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import 'package:flutter/material.dart';

import '../controller/signinup_controller.dart';
import '../controller/temper_controller.dart';


class TemperatureEdit extends StatelessWidget {

  void editDialog(context, award_number, award_title) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: TextField(
                      // maxLength: 7,
                      controller: TextEditingController(text: award_title),
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      // textAlign: TextAlign.center,
                      onChanged: (value) {
                        TemperController.to.award_title = value;
                      },
                      style: TextStyle(fontFamily: 'Jua', color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 20, ),
                      // minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              TemperController.to.award_title = '';
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              TemperController.to.award_number = award_number;
              TemperController.to.saveAward();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('temper_award').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
          List award_list = [];

          for (int i = 0; i < 16; i++) {
            award_list.add('');
          }

          snapshot.data!.docs.forEach((doc) {
            award_list[doc['award_number']] = doc['award_title'];
          });

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 왼쪽 보상
              Container(
                alignment: Alignment.center,
                // color: Colors.blue,
                width: 200,
                height: MediaQuery.of(context).size.height*0.65,
                child: GridView.builder(
                  reverse: true,
                  // physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  // padding: EdgeInsets.all(15),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 3,
                    height: 35,  /// 높이 지정
                  ),
                  // SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 5,
                  //   childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
                  // ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return
                      index % 2 == 0 ?
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          editDialog(context, index, award_list[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.teal,),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                          ),
                        ),
                        // child: Bubble(
                        //   // margin: BubbleEdges.only(bottom: 24),
                        //   nip: BubbleNip.rightCenter,
                        //   color: Colors.teal,
                        //   child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                        //   // child: Text('${index.toString()} : ${award_list[index]}', style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                        // ),
                      ) : SizedBox();
                  },
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset('assets/images/temper.png', height: MediaQuery.of(context).size.height*0.85,),
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: MediaQuery.of(context).size.height*0.65,
                    child: GridView.builder(
                      // reverse: true,
                      // physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      // padding: EdgeInsets.all(15),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 3,
                        height: 35,  /// 높이 지정
                      ),
                      // SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 5,
                      //   childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
                      // ),
                      itemCount: 80,
                      itemBuilder: (context, index) {
                        return Container(decoration: BoxDecoration(border: Border.all(color: Colors.redAccent), shape: BoxShape.circle,),);
                        // return CircleAvatar(radius: 200, backgroundColor: Colors.redAccent.withOpacity(0.5),);
                      },
                    ),
                  ),
                ],),
              /// 오른쪽 보상
              Container(
                alignment: Alignment.center,
                // color: Colors.blue,
                width: 200,
                height: MediaQuery.of(context).size.height*0.65,
                child: GridView.builder(
                  reverse: true,
                  // physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  // padding: EdgeInsets.all(15),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 3,
                    height: 35,  /// 높이 지정
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return
                      index % 2 == 1 ?
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          editDialog(context, index, award_list[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.teal,),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                          ),
                        ),
                        // child: Bubble(
                        //   // margin: BubbleEdges.only(bottom: 24),
                        //   nip: BubbleNip.leftCenter,
                        //   color: Colors.teal,
                        //   child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                        //   // child: Text('${index.toString()} : ${award_list[index]}', style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                        // ),
                      ) : SizedBox();
                  },
                ),
              ),
            ],

          );
        }
    );

  }
}


