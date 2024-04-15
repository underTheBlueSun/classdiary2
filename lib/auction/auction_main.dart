import 'package:classdiary2/controller/class_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../board_indi.dart';
import '../controller/board_controller.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../board_modum.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;

import '../controller/signinup_controller.dart';
import 'auction_indi.dart';

class AuctionMain extends StatelessWidget {
  CustomPopupMenuController popupShareController = CustomPopupMenuController();

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
                        // child: ListView.separated(
                        //   primary: false,
                        //   shrinkWrap: true,
                        //   // padding: const EdgeInsets.all(10),
                        //   itemCount: attendanceList.length,
                        //   itemBuilder: (context, index) {
                        //     /// visitList.contains(attendanceList[index]), visitList.contains({'number': 2, 'name': '강현우'}) 이거 안됨
                        //     return
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Container(
                        //           width: 20,
                        //           child:
                        //           CircleAvatar(
                        //             backgroundColor: Colors.white,
                        //             child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Jua',),),
                        //           ),
                        //         ),
                        //         SizedBox(width: 20,),
                        //         Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18,),),
                        //         SizedBox(width: 50,),
                        //         visitList.any((e) => mapEquals(e, attendanceList[index])) ?
                        //         ElevatedButton(
                        //           onPressed: () {
                        //             ClassController.to.exitClassByTeacher(attendanceList[index]['number'], attendanceList[index]['name']);
                        //           }, // onPressed
                        //           child: Text('퇴장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                        //         ) :
                        //             SizedBox(),
                        //       ],
                        //     );
                        //   },
                        //   separatorBuilder: (BuildContext context, int index) => const Divider(),
                        // ),
                      );
                  }

                }
            ),
          ),
        );
      },
    );

  }

  void qrDialog(context) {
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
                    data: 'https://classdiary2.web.app/?paramClassCode=${GetStorage().read('class_code')}&paramEmail=${GetStorage().read('email')}&paramGubun=auction',
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

  @override
  Widget build(BuildContext context) {
    /// index.html에서 테마색깔 지정, 폰 제일 위 색깔 마추기위해
    js.context.callMethod("setMetaThemeColor", ["#4C4C4C"]);

    List popupEditControllers = [];
    CustomPopupMenuController popupAddController = CustomPopupMenuController();
    CustomPopupMenuController copyController = CustomPopupMenuController();
    // CustomPopupMenuController popupEditController = CustomPopupMenuController();
    TextEditingController titleInputController = TextEditingController();
    TextEditingController contentInputController = TextEditingController();
    // var bgColors1 = [0xff2B2B2B, 0xffE9E7EA, 0xff668F85, 0xff84A76A, 0xffD3DC7E];
    // var bgColors2 = [0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
    var bgColors = [0xffE9E7EA, 0xff2B2B2B, 0xff668F85, 0xff84A76A, 0xffD3DC7E, 0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
    var bgImages = ['bg01', 'bg02', 'bg03', 'bg04', 'bg05', 'bg06', 'bg07', 'bg08', 'bg09', 'bg10'];

    return MediaQuery.of(context).size.width < 600 ?
    Scaffold(
      backgroundColor: Color(0xFF4C4C4C),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 윗줄
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    ClassController.to.exitClass();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
                    child: Image.asset('assets/images/font_exit.png', height: 30),
                    // child: Column(
                    //   children: [
                    //     Container(
                    //       decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
                    //       height: 35.0,
                    //       width: 35.0,
                    //       child: Icon(Icons.exit_to_app, size: 20, color: ClassController.to.isHoverExit.value == true ? Colors.white : Colors.black.withOpacity(0.4)),
                    //     ),
                    //     // Text('퇴장', style: TextStyle(color: Colors.grey),),
                    //   ],
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.person, color: Colors.teal,),
                      SizedBox(width: 5,),
                      Text(GetStorage().read('name'), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 16),),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('board_main')
                          .where('class_code', isEqualTo: GetStorage().read('class_code')).where('gubun', isEqualTo: '경매').snapshots(),
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
                        List docs = snapshot.data!.docs.toList();
                        docs.sort((a,b)=> b['main_id'].compareTo(a['main_id']));
                        return
                          Flexible(
                            child: GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(15),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2/1.1, //item 의 가로, 세로 의 비율
                                // childAspectRatio: 2 / 1.16, //item 의 가로, 세로 의 비율
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc = docs[index];
                                // DocumentSnapshot doc = snapshot.data!.docs[index];
                                popupEditControllers.add(CustomPopupMenuController());
                                return InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    BoardController.to.mainTitleInput = doc['title'];
                                    BoardController.to.background.value = doc['background'];

                                    Get.to(() => AuctionIndi(), arguments: {'title' : doc['title'], 'main_id' : doc['main_id'], 'background': doc['background'],
                                      'content': doc['content'], 'id': doc.id, 'gubun' : doc['gubun'] });
                                    BoardController.to.selected_main_id = doc['main_id'];

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      /// 길이가 10이면 배경색깔
                                      decoration: doc['background'].length == 10 ?
                                      BoxDecoration(color: Color(int.parse(doc['background'])), borderRadius: BorderRadius.circular(10)) :
                                      BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + doc['background'] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12, right: 12,top:12,),
                                            child: Container(
                                              width: 250,
                                              // 아이맥 2048, 한성 2560, pc1 2048, pc2 1920
                                              // height: 50,
                                              child: Stack(
                                                children: <Widget>[
                                                  Text(doc['title'], maxLines: 2, style: TextStyle(fontFamily: 'Jua',
                                                    foreground: Paint()
                                                      ..style = PaintingStyle.stroke
                                                      ..strokeWidth = 3
                                                      ..color = Colors.black.withOpacity(0.3),
                                                  ),
                                                  ),
                                                  Text(doc['title'], maxLines: 2, style: TextStyle(fontFamily: 'Jua', color: Colors.white,),),
                                                ],
                                              ),
                                              // child: Text(doc['title'], maxLines: 2,  style: TextStyle(fontFamily: 'Jua',  color: Colors.white),),
                                            ),
                                          ),
                                          Expanded(child: SizedBox()),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(doc['main_id'].toDate().toString().substring(2,16), style: TextStyle(fontSize: 12, color: Colors.white),),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              },

                            ),
                          );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ) :
    Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body:
      SingleChildScrollView(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 15,),
            /// 윗줄
            GetStorage().read('job') == 'teacher' ?
            Container(
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                child: Row(
                  children: [
                    /// 홈
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.off(() => Dashboard());
                        // Get.back();
                      },
                      child: Column(
                        children: [
                          Image.asset('assets/images/quiz_home_icon.png', height: 35,),
                          SizedBox(height: 10,),
                          Text('집으로', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 13,),)
                        ],
                      ),
                      // child: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Image.asset('assets/images/font_home.png', height: 50),
                      // ),
                    ),
                    SizedBox(width: 50,),
                    /// add 아이콘
                    CustomPopupMenu(
                      controller: popupAddController,
                      arrowSize: 20,
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xff6690AC), borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                          child: Text('${DashboardController.to.game_gubun} 만들기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white),),
                        ),
                      ),
                      menuBuilder: () => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 400,
                          height: MediaQuery.of(context).size.height*0.7,
                          // height: 650,
                          color: Color(0xFF4C4C4C),
                          child: SingleChildScrollView(
                            child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child:
                                        TextButton(
                                          style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                                          onPressed: () {
                                            if (BoardController.to.mainTitleInput.length > 0) {
                                              // BoardController.to.popCloseType = 'save';
                                              BoardController.to.saveBoardMain(DashboardController.to.game_gubun);
                                            }
                                            popupAddController.hideMenu();
                                          },
                                          child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 370, height: 40,
                                    child: TextField(
                                      // controller: titleInputController,
                                      autofocus: true,
                                      textAlignVertical: TextAlignVertical.center,
                                      onChanged: (value) {
                                        BoardController.to.mainTitleInput = value;
                                      },
                                      style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
                                      // minLines: 1,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: '제목을 입력하세요',
                                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  SizedBox(
                                    width: 370, height: 100,
                                    child: TextField(
                                      onChanged: (value) {
                                        BoardController.to.mainContentInput = value;
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
                                  SizedBox(height: 7,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// 보드형태
                                      Container(
                                        width: 370,
                                        child: Text('  보드형태', style: TextStyle(color: Colors.white),),
                                      ),
                                      SizedBox(height: 3,),
                                      Obx(() => Container(
                                        width: 370,height: 60,
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                BoardController.to.board_type.value = '개인';
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [ BoardController.to.board_type.value == '개인' ?
                                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                                  Icon(Icons.circle_outlined, color: Colors.white,),
                                                    SizedBox(width: 5,),
                                                    Text('개인형',style: TextStyle(color: Colors.white, fontSize: 17),),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                // BoardController.to.board_type.value = '모둠';
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [ BoardController.to.board_type.value == '모둠' ?
                                                  Icon(Icons.check_circle, color: Colors.orangeAccent,) :
                                                  Icon(Icons.circle_outlined, color: Colors.white,),
                                                    SizedBox(width: 5,),
                                                    Text('모둠형',style: TextStyle(color: Colors.white, fontSize: 17),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ),
                                      SizedBox(height: 10,),
                                      /// 배경색깔
                                      Container(
                                        width: 370,
                                        child: Text('  배경색깔', style: TextStyle(color: Colors.white),),
                                      ),
                                      Container(
                                        width: 370,height: 100,
                                        // decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                                        child: GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(2),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            childAspectRatio: 2/1.16, //item 의 가로, 세로 의 비율
                                          ),
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return Obx(() => InkWell(
                                              onTap: () {
                                                BoardController.to.background.value = bgColors[index].toString();
                                                // BoardController.to.board_bgcolor.value = bgColors[index];
                                              },
                                              child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(1),
                                                      child: Container(
                                                        decoration: index == 0 ?
                                                        BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),) :
                                                        index == 4 ?
                                                        BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(topRight: Radius.circular(10),),) :
                                                        index == 5 ?
                                                        BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),),) :
                                                        index == 9 ?
                                                        BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),) :
                                                        BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),),),
                                                        // color: Colors.red,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: BoardController.to.background.value == bgColors[index].toString() ?
                                                      // child: BoardController.to.board_bgcolor.value == bgColors[index] ?
                                                      Icon(Icons.check_circle) :
                                                      SizedBox(),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            );

                                          },

                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      /// 배경이미지
                                      Container(
                                        width: 370,
                                        child: Text('  배경이미지', style: TextStyle(color: Colors.white),),
                                      ),
                                      Container(
                                        width: 370,height: 100,
                                        // decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                                        child: GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(2),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            childAspectRatio: 2/1.16, //item 의 가로, 세로 의 비율
                                          ),
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return Obx(() => InkWell(
                                              onTap: () {
                                                BoardController.to.background.value = bgImages[index];
                                                // BoardController.to.boardBgImage.value = bgImages[index];
                                              },
                                              child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(1),
                                                      child: Container(
                                                        decoration: index == 0 ?
                                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),) :
                                                        index == 4 ?
                                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(topRight: Radius.circular(10),),) :
                                                        index == 5 ?
                                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),),) :
                                                        index == 9 ?
                                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),) :
                                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),),),
                                                        // color: Colors.red,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: BoardController.to.background.value == bgImages[index] ?
                                                      // child: BoardController.to.boardBgImage.value == bgImages[index] ?
                                                      Icon(Icons.check_circle) :
                                                      SizedBox(),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            );

                                          },

                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 20,),

                                ]
                            ),
                          ),
                        ),
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                    ),
                    SizedBox(width: 30,),
                    Text(BoardController.to.mainAlignment.value, style: TextStyle(fontSize: 0),), // obx 먹을려면 적어둬야 함
                    Text('해상도 : ' + MediaQuery.of(context).size.width.toString()),
                    Text('반코드: ' + GetStorage().read('class_code')),
                    SizedBox(width: 20,),
                    Text('총원: ' + AttendanceController.to.attendanceCnt.value.toString()),
                    SizedBox(width: 20,),
                    Text('이메일: ' + GetStorage().read('email')),
                    SizedBox(width: 20,),
                    Text('번호: ' + GetStorage().read('number').toString()),
                    SizedBox(width: 20,),
                    Text('이름: ' + GetStorage().read('name')),
                    SizedBox(width: 20,),
                    Text('직업: ' + GetStorage().read('job')),
                    Expanded(child: SizedBox()),
                    /// 입퇴장
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        exitDialog(context);
                      },
                      child: Text('입/퇴장',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                    ),
                    SizedBox(width: 15,),
                    /// 날짜순
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        if (BoardController.to.mainAlignment.value.substring(2,5) == 'asc') {
                          BoardController.to.mainAlignment.value = 'd_dsc';
                        }else{
                          BoardController.to.mainAlignment.value = 'd_asc';
                        }
                      },
                      child: Text('날짜순 정렬',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                    ),
                    // InkWell(
                    //   // highlightColor: Colors.transparent,
                    //   // hoverColor: Colors.transparent,
                    //   // splashColor: Colors.transparent,
                    //   // onHover: (isHovering) {
                    //   //   if (isHovering) {
                    //   //     BoardController.to.isHoverDate.value = true;
                    //   //   } else {
                    //   //     BoardController.to.isHoverDate.value = false;
                    //   //   }
                    //   // },
                    //   onTap: () {
                    //     if (BoardController.to.mainAlignment.value.substring(2,5) == 'asc') {
                    //       BoardController.to.mainAlignment.value = 'd_dsc';
                    //     }else{
                    //       BoardController.to.mainAlignment.value = 'd_asc';
                    //     }
                    //     // BoardController.to.mainAlignment.value = 'date_true';
                    //   },
                    //   child: Image.asset('assets/images/font_date_arrange.png', height: 32),
                    //   // child: Column(
                    //   //   children: [
                    //   //     Container(
                    //   //       decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
                    //   //       height: 40.0,
                    //   //       width: 40.0,
                    //   //       child: Icon(Icons.date_range, size: 25, color: BoardController.to.isHoverDate.value == true ? Colors.white : Colors.black.withOpacity(0.4)),
                    //   //     ),
                    //   //     Text('날짜순', style: TextStyle(color: Colors.grey),),
                    //   //   ],
                    //   // ),
                    // ),
                    SizedBox(width: 20,),
                    /// 제목순
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        if (BoardController.to.mainAlignment.value.substring(2,5) == 'asc') {
                          BoardController.to.mainAlignment.value = 't_dsc';
                        }else{
                          BoardController.to.mainAlignment.value = 't_asc';
                        }
                      },
                      child: Text('제목순 정렬',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (BoardController.to.mainAlignment.value.substring(2,5) == 'asc') {
                    //       BoardController.to.mainAlignment.value = 't_dsc';
                    //     }else{
                    //       BoardController.to.mainAlignment.value = 't_asc';
                    //     }
                    //   },
                    //   child: Image.asset('assets/images/font_title_arrange.png', height: 32),
                    // ),
                    SizedBox(width: 20,),
                    /// 이전년도
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        BoardController.to.mainAlignment.value = 'title';
                      },
                      child: Text('이전년도 조회',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     BoardController.to.mainAlignment.value = 'title';
                    //   },
                    //   child: Image.asset('assets/images/font_before_year.png', height: 32),
                    // ),
                    SizedBox(width: 20,),
                    /// url복사
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {

                      },
                      child: CustomPopupMenu(
                        menuOnChange: (bool) {
                        },
                        controller: copyController,
                        arrowSize: 20,
                        child: Text('URL 복사',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                        // child: Image.asset('assets/images/font_url_copy.png', height: 32),
                        menuBuilder: () => ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 480,
                            height: 150,
                            color: Color(0xFF4C4C4C),
                            child: IntrinsicWidth(
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: 'https://classdiary2.web.app/?paramClassCode=${GetStorage().read('class_code')}&paramEmail=${GetStorage().read('email')}&paramGubun=auction', ));
                                              // Clipboard.setData(ClipboardData(text: 'https://classdiary2.web.app/?class_code=${GetStorage().read('class_code')}' ));
                                              copyController.hideMenu();
                                            },
                                            child: Image.asset('assets/images/font_copy.png', height: 32),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text('https://classdiary2.web.app/?paramClassCode=${GetStorage().read('class_code')}&paramEmail=${GetStorage().read('email')}&paramGubun=auction', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      // child: Text('https://classdiary2.web.app/?class_code=' + GetStorage().read('class_code'), style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ),

                                  ]
                              ),
                            ),
                          ),
                        ),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                      ),
                    ),

                    SizedBox(width: 20,),
                    /// qr코드
                    TextButton(
                      style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                      onPressed: () {
                        qrDialog(context);
                      },
                      child: Text('QR 코드',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     qrDialog(context);
                    //   },
                    //   child: Image.asset('assets/images/font_qr_code.png', height: 32),
                    // ),
                    SizedBox(width: 40,),
                  ],
                ),
              ),
            ) :
            Container(
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                child: Row(
                  children: [
                    /// 퇴장
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        ClassController.to.exitClass();
                      },
                      child: Image.asset('assets/images/font_exit.png', height: 40),
                    ),

                    Text(BoardController.to.mainAlignment.value, style: TextStyle(fontSize: 0),), // obx 먹을려면 적어둬야 함
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.person, color: Colors.teal,),
                        SizedBox(width: 5,),
                        Text(GetStorage().read('name'), style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 17),),
                      ],
                    ),
                    SizedBox(width: 40,),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('board_main')
                          .where('class_code', isEqualTo: GetStorage().read('class_code')).where('gubun', isEqualTo: '경매').snapshots(),
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
                        List docs = snapshot.data!.docs.toList();
                        if (BoardController.to.mainAlignment.value == 'd_asc') {
                          docs.sort((a,b)=> a['main_id'].compareTo(b['main_id']));
                        }else if (BoardController.to.mainAlignment.value == 'd_dsc') {
                          docs.sort((a,b)=> b['main_id'].compareTo(a['main_id']));
                        }else if (BoardController.to.mainAlignment.value == 't_asc') {
                          docs.sort((a,b)=> a['title'].compareTo(b['title']));
                        }else {
                          docs.sort((a,b)=> b['main_id'].compareTo(a['main_id']));
                        }

                        return
                          Flexible(
                            child: GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(15),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount : MediaQuery.of(context).size.width > 1800 ? 7 :
                                MediaQuery.of(context).size.width < 1000 ? 4: 6,
                                childAspectRatio: MediaQuery.of(context).size.width > 1800 ? 2/1.16 : 2/1.3, //item 의 가로, 세로 의 비율
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc = docs[index];
                                popupEditControllers.add(CustomPopupMenuController());
                                return InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    BoardController.to.mainTitleInput = doc['title'];
                                    BoardController.to.background.value = doc['background'];

                                    Get.off(() => AuctionIndi(), arguments: {'title' : doc['title'], 'main_id' : doc['main_id'], 'background': doc['background'],
                                      'content': doc['content'], 'id': doc.id, 'gubun' : doc['gubun']});
                                    BoardController.to.selected_main_id = doc['main_id'];
                                    /// 댓글허용
                                    BoardController.to.isRepeatToggle.value = doc['isAcceptComment'];

                                    /// 평가 명단 만들기
                                    BoardController.to.saveEstimateList();

                                  },
                                  child: Container(
                                    // color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        /// 길이가 10이면 배경색깔
                                        decoration: doc['background'].length == 10 ?
                                        BoxDecoration(color: Color(int.parse(doc['background'])), borderRadius: BorderRadius.circular(10)) :
                                        BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + doc['background'] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12, right: 12,top:12,),
                                              child: Container(
                                                width: 250,
                                                // 아이맥 2048, 한성 2560, pc1 2048, pc2 1920
                                                height: 55 * MediaQuery.of(context).size.width/2000,
                                                child: Stack(
                                                  children: <Widget>[
                                                    // Stroked text as border.
                                                    Text(
                                                      doc['title'],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontFamily: 'Jua',
                                                        // fontSize: 18,
                                                        foreground: Paint()
                                                          ..style = PaintingStyle.stroke
                                                          ..strokeWidth = 4
                                                          ..color = Colors.black.withOpacity(0.3),
                                                      ),
                                                    ),
                                                    // Solid text as fill.
                                                    Text(
                                                      doc['title'],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontFamily: 'Jua',
                                                        // fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // child: Text(doc['title'], maxLines: 2,  style: TextStyle(fontFamily: 'Jua', fontSize: 19* MediaQuery.of(context).size.width/2000, color: Colors.white),),
                                              ),
                                            ),
                                            // Divider(color: Colors.black.withOpacity(0.1),),
                                            Expanded(child: SizedBox()),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(doc['main_id'].toDate().toString().substring(2,16), style: TextStyle(color: Colors.white),),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                              },

                            ),
                          );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );

  }
}


