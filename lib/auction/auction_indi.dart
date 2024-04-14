import 'package:classdiary2/board_add_mobile.dart';
import 'package:classdiary2/board_main.dart';
import 'package:classdiary2/board_upd_mobile.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controller/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:get/get.dart';
import 'dart:js' as js;

import '../controller/subject_controller.dart';
import 'auction_main.dart';

class AuctionIndi extends StatelessWidget {
  CustomPopupMenuController popupSettingController = CustomPopupMenuController();
  CustomPopupMenuController addController = CustomPopupMenuController();
  TextEditingController titleSettingController = TextEditingController();
  TextEditingController contentSettingController = TextEditingController();
  List addControllers = [];
  List updIndiControllers = [];
  List updCommentControllers = [];
  List addCommentControllers = [];
  List updTitleInputControllers = [];
  List updContentInputControllers = [];
  List updCommentInputControllers = [];
  int indiCnt = 0;
  int commentCnt = 0;
  int addCommentCnt = 0;
  int updTitleCnt = 0;
  int updContentCnt = 0;
  int updCommentInputCnt = 0;
  /// index.html에서 테마색깔 지정, 폰 제일 위 색깔 마추기위해
  List bg_colors = ['#5CBCCD', '#FBECBC', '#F9F9F9', '#FBFBFB', '#D8F9FE', '#FEF8F5', '#A7D1EB', '#6BD8FA', '#C4D5EE', '#C0E4F8'];
  List appbar_colors = [0xff56BCCF, 0xffFBECBC, 0xffF9F9F9, 0xffFBFBFB, 0xffD8F9FE, 0xffFEF8F5, 0xffA7D1EB, 0xff6BD8FA, 0xffC4D5EE, 0xffC0E4F8];

  void delDialog(context, main_doc_id, main_id) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 200,
            height: 100,
            child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 25,),),
          ),
          actions: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/font_cancel.png', height: 32),
                // child: Text('취소',style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
              ),
            ),
            SizedBox(width: 20,),
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                BoardController.to.delBoardMain(main_doc_id, main_id, 'indi');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/font_delete.png', height: 32),
                // child: Text('삭제', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
              ),
            ),
          ],
        );
      },
    );

  }

  void updCommentDialog(context, comment, id) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 150,
            height: 150,
            color: Color(0xFF4C4C4C),
            child: IntrinsicWidth(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('댓글 수정' ,style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 14, )),
                    Divider(color: Colors.white.withOpacity(0.3),),
                    Container(
                      height: 110,
                      child: TextField(
                        controller: TextEditingController(text: comment['comment']),
                        // textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          BoardController.to.indiCommentInput = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/font_cancel.png', height: 22),
                    // child: Text('취소',style: TextStyle(color: Colors.white, fontSize: 17,),),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      BoardController.to.delComment(id, comment, 'board_indi');
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/font_delete.png', height: 22),
                    // child: Text('삭제', style: TextStyle(color: Colors.white, fontSize: 17,),),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      BoardController.to.updComment(id, comment, 'board_indi');
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/font_upd.png', height: 22),
                    // child: Text('수정', style: TextStyle(color: Colors.white, fontSize: 17,),),
                  ),
                ],
              ),
            ),

          ],
        );
      },
    );

  }

  void imageDialog(context, id, imageUrl, isDelete) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 400,
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(imageUrl),
            ),
          ),
          actions: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/font_close.png', height: 32),
              ),
            ),
            SizedBox(width: 20,),
            Visibility(
              visible: isDelete,
              child: InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  BoardController.to.delImage(id, imageUrl, 'board_indi');
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/font_delete.png', height: 32),
                ),
              ),
            ),
          ],
        );
      },
    );

  }

  void fullScreenDialog(full_context, title, content, image_url, number, name, main_id) {
    print(image_url.length);
    showDialog(
      context: full_context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEEE9DF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                        onPressed: () {
                          BoardController.to.board_full_screen_text_size.value = 45;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('닫기',style: TextStyle(fontSize: 25,  color: Colors.white),),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(number.toString() + '번',style: TextStyle(fontSize: 30, fontFamily: 'Jua', color: Colors.teal),),
                          ),
                          SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(name,style: TextStyle(fontSize: 30, fontFamily: 'Jua', color: Colors.teal),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: () {
                              BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value + 5;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('글자 크게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: () {
                              BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value - 5;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('글자 작게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.9*0.4,
                          child: Text(content, style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: BoardController.to.board_full_screen_text_size.value,),),
                        ),
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.9*0.3,
                              alignment: Alignment.center,
                              child: Text(title, style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 50,),),
                            ),
                            SizedBox(height: 20,),
                            image_url.length > 0 ?
                            Container(
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width*0.9*0.3,
                              height: MediaQuery.of(context).size.width*0.9*0.3,
                              child: Image.network(image_url),
                            ) :
                            Container(
                              width: MediaQuery.of(context).size.width*0.9*0.3,
                              height: MediaQuery.of(context).size.width*0.9*0.3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 50,),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
                              .where('main_id', isEqualTo: main_id).where('number', isEqualTo: number).snapshots(),
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
                            var indiDoc = snapshot.data!.docs.first;
                            List commentList = indiDoc['comment'];
                            commentList.sort((a, b) => int.parse(b['comment']).compareTo( int.parse(a['comment']) ));
                            // commentList.sort((a, b) => a['date'].compareTo(b['date']));
                            return Container(
                              width: MediaQuery.of(context).size.width*0.9*0.2,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: commentList.length,
                                  itemBuilder: (_, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 350,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),),
                                                onPressed: () {
                                                  BoardController.to.saveAuction(indiDoc['number'], commentList[index]['name'],commentList[index]['comment'], title, image_url);
                                                  auctionDialog(full_context, context,commentList[index]['name'],commentList[index]['comment']);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    children: [
                                                      Text(commentList[index]['name'], style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'Jua'),),
                                                      SizedBox(width: 50,),
                                                      Image.asset('assets/images/coin.png', width: 50,),
                                                      SizedBox(width: 5,),
                                                      Text(commentList[index]['comment'], style: TextStyle(fontSize: 55, color: Colors.red, fontFamily: 'Jua'),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Text(commentList[index]['name'] + ' : ', style: TextStyle(color: Colors.black, fontSize: 55, fontFamily: 'Jua'),),
                                            //     SizedBox(width: 10,),
                                            //     Text(commentList[index]['comment'], style: TextStyle(fontSize: 55, color: Colors.redAccent, fontFamily: 'Jua'),),
                                            //     // Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
                                            //     //     commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
                                            //     //   style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        // Text(commentList[index]['comment'], style: TextStyle(fontSize: 70, color: Colors.redAccent, fontFamily: 'Jua'),),
                                        SizedBox(height: 10,),
                                      ],
                                    );
                                  }
                              ),
                            );
                          }
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void auctionDialog(full_context, context, name, coin) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 600,
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/congrats01.png'),
                  Text(name, style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 80,),),
                  Image.asset('assets/images/congrats02.png')
                ],
              ),
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(full_context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('닫기',style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 40,),),
              ),
            ),
          ],
        );
      },
    );

  }

  void auctionListDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEEE9DF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                        onPressed: () {
                          BoardController.to.board_full_screen_text_size.value = 45;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('닫기',style: TextStyle(fontSize: 25,  color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('auction_coin').where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
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
                        docs.sort((a,b)=> a['date'].compareTo(b['date']));

                        return
                          ListView.separated(
                            separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); },
                            primary: false,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(15),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = docs[index];

                              return Row(
                                children: [
                                Image.network(doc['image_url'], width: 100, height: 50,),
                                SizedBox(width: 30,),
                                Container(
                                    width: 300,
                                    child: Text(doc['title'], style: TextStyle(color: Colors.black, fontSize: 40),),
                                ),
                                SizedBox(width: 30,),
                                Container(
                                  width: 200,
                                  child: Text(doc['name'], style: TextStyle(color: Colors.black, fontSize: 40),),
                                ),
                                SizedBox(width: 30,),
                                Image.asset('assets/images/coin.png', width: 50, height: 50,),
                                SizedBox(width: 30,),
                                Container(
                                  width: 300,
                                  child: Text(doc['coin'].toString(), style: TextStyle(color: Colors.orange, fontSize: 60),),
                                ),
                              ],);

                            },

                          );
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void auctionListIndiDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          backgroundColor: Color(0xFFEEE9DF),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(0xFFEEE9DF),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    // style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('닫기',style: TextStyle(color: Colors.black, fontSize: 17),),
                  ),
                ],
              ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('auction_coin').where('main_id', isEqualTo: BoardController.to.selected_main_id)
                  .where('name', isEqualTo: GetStorage().read('name')).snapshots(),
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
                    docs.sort((a,b)=> a['date'].compareTo(b['date']));

                    return
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); },
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = docs[index];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  doc['image_url'].length > 0 ?
                                  // Image.asset('assets/images/bg01.png', width: 50, height: 50,),
                                  Image.network(doc['image_url'], width: 50, height: 50,) :
                                  SizedBox(width: 50, height: 50,),
                                  SizedBox(width: 10,),
                                  Container(
                                    width: 150,
                                    child: Text(doc['title'], style: TextStyle(color: Colors.black, fontSize: 15),),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image.asset('assets/images/coin.png', width: 30, height: 30,),
                                  SizedBox(width: 10,),
                                  Container(
                                    width: 50,
                                    child: Text(doc['coin'].toString(), style: TextStyle(color: Colors.orange, fontSize: 20),),
                                  ),
                                ],
                              ),

                            ],);

                        },

                      );
                  }
              ),
            ),
          ),
        );
      },
    );

  }

  void estimateIndiDialog(context, number, name) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          backgroundColor: Color(0xFFEEE9DF),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(0xFFEEE9DF),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    BoardController.to.updEstimate(number, name);
                    Navigator.pop(context);
                  },
                  child: Text('저장',style: TextStyle(color: Colors.black, fontSize: 17),),
                ),
                Text('${number}번  ${name}',style: TextStyle(color: Colors.black, fontSize: 17),),
                TextButton(
                  onPressed: () {
                  },
                  child: Text('닫기',style: TextStyle(color: Colors.transparent, fontSize: 17),),
                ),
              ],
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Obx(() => SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('준비한 자료와 발표내용이 알찬가?',style: TextStyle(fontSize: 15,  color: Colors.black),),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate1.value = 5;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate1.value == 5 ? Colors.teal : Colors.grey,
                                      child: Text('5점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate1.value = 3;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate1.value == 3 ? Colors.green : Colors.grey,
                                      child: Text('3점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate1.value = 1;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate1.value == 1 ? Colors.orange : Colors.grey,
                                      child: Text('1점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                              ],),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('내용전달이 알아 듣기 쉬운가?',style: TextStyle(fontSize: 15,  color: Colors.black),),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate2.value = 5;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate2.value == 5 ? Colors.teal : Colors.grey,
                                      child: Text('5점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate2.value = 3;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate2.value == 3 ? Colors.green : Colors.grey,
                                      child: Text('3점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate2.value = 1;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate2.value == 1 ? Colors.orange : Colors.grey,
                                      child: Text('1점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                              ],),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('바른 자세로 발표를 잘 하였는가?',style: TextStyle(fontSize: 15,  color: Colors.black),),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate3.value = 5;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate3.value == 5 ? Colors.teal : Colors.grey,
                                      child: Text('5점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate3.value = 3;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate3.value == 3 ? Colors.green : Colors.grey,
                                      child: Text('3점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate3.value = 1;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate3.value == 1 ? Colors.orange : Colors.grey,
                                      child: Text('1점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                              ],),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('구매욕구를 자극하는가?',style: TextStyle(fontSize: 15,  color: Colors.black),),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate4.value = 5;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate4.value == 5 ? Colors.teal : Colors.grey,
                                      child: Text('5점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate4.value = 3;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate4.value == 3 ? Colors.green : Colors.grey,
                                      child: Text('3점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: () {
                                    BoardController.to.estimate4.value = 1;
                                  },
                                  child: Container(
                                    width: 60,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: BoardController.to.estimate4.value == 1 ? Colors.orange : Colors.grey,
                                      child: Text('1점', style: TextStyle(color: Colors.white, fontSize: 16,),),
                                    ),
                                  ),
                                ),
                              ],),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                ],),
            ),
            ),
          ),
        );
      },
    );

  }

  void estimateTotalDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEEE9DF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                    onPressed: () {
                      BoardController.to.board_full_screen_text_size.value = 45;
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('닫기',style: TextStyle(fontSize: 20,  color: Colors.white),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  // for(int i=0; i < BoardController.to.estimates.length; i++)
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 15,
                  //       child: CircleAvatar(backgroundColor: Colors.teal,),
                  //     ),
                  //     SizedBox(width: 10,),
                  //     Text(BoardController.to.estimates[i],style: TextStyle(fontSize: 15,  color: Colors.grey),),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            child: CircleAvatar(backgroundColor: Colors.teal,),
                          ),
                          SizedBox(width: 10,),
                          Text('준비한 자료와 발표내용이 알찬가?',style: TextStyle(fontSize: 15,  color: Colors.grey),),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            child: CircleAvatar(backgroundColor: Colors.green,),
                          ),
                          SizedBox(width: 10,),
                          Text('내용전달이 알아 듣기 쉬운가?',style: TextStyle(fontSize: 15,  color: Colors.grey),),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            child: CircleAvatar(backgroundColor: Colors.orange,),
                          ),
                          SizedBox(width: 10,),
                          Text('바른 자세로 발표를 잘 하였는가?',style: TextStyle(fontSize: 15,  color: Colors.grey),),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            child: CircleAvatar(backgroundColor: Colors.blue,),
                          ),
                          SizedBox(width: 10,),
                          Text('구매욕구를 자극하는가?',style: TextStyle(fontSize: 15,  color: Colors.grey),),
                        ],
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 15,
                  //       child: CircleAvatar(backgroundColor: Colors.black,),
                  //     ),
                  //     SizedBox(width: 10,),
                  //     Text('총점',style: TextStyle(fontSize: 15,  color: Colors.grey),),
                  //   ],
                  // ),
                ],),
              Divider(),
            ],),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('auction_estimate').where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
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
                        docs.sort((a,b)=> a['number'].compareTo(b['number']));

                        return
                          ListView.separated(
                            separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); },
                            primary: false,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(15),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = docs[index];

                              return Row(
                                children: [
                                  Container(
                                      width: 50,
                                      child: Text(doc['number'].toString() + '번', style: TextStyle(color: Colors.black, fontSize: 17),)),
                                  SizedBox(width: 20,),
                                  Container(
                                    width: 70,
                                    child: Text(doc['name'].toString(), style: TextStyle(color: Colors.black, fontSize: 17),),
                                  ),
                                  SizedBox(width: 30,),
                                  Container(
                                    width: 50,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Text('${doc['estimate1']}', style: TextStyle(color: Colors.white, fontSize: 17,),),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 50,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Text('${doc['estimate2']}', style: TextStyle(color: Colors.white, fontSize: 17,),),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 50,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      child: Text('${doc['estimate3']}', style: TextStyle(color: Colors.white, fontSize: 17,),),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 50,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text('${doc['estimate4']}', style: TextStyle(color: Colors.white, fontSize: 17,),),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    width: 50,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Text('${doc['estimate1']+doc['estimate2']+doc['estimate3']+doc['estimate4']}', style: TextStyle(color: Colors.white, fontSize: 17,),),
                                    ),
                                  ),
                                ],);

                            },

                          );
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  void hintDialog(context, content) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.width*0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                        onPressed: () {
                          BoardController.to.board_full_screen_text_size.value = 45;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('닫기',style: TextStyle(fontSize: 25,  color: Colors.white),),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: () {
                              BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value + 5;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('글자 크게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: () {
                              BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value - 5;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('글자 작게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Obx(() => Container(
                    child: Text(content, style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: BoardController.to.board_full_screen_text_size.value,),),
                  ),
                  ),
                ],
              ),
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

    if (Get.arguments['background'].length == 10) {
      js.context.callMethod("setMetaThemeColor", ['#'+ int.parse(Get.arguments['background']).toRadixString(16).toUpperCase().substring(2,8)]);
    }else {
      js.context.callMethod("setMetaThemeColor", [ bg_colors[int.parse(Get.arguments['background'].substring(2,4))-1] ]);
    }

    // var bgColors1 = [0xff2B2B2B, 0xffE9E7EA, 0xff668F85, 0xff84A76A, 0xffD3DC7E];
    // var bgColors2 = [0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
    var bgColors = [0xffE9E7EA, 0xff2B2B2B, 0xff668F85, 0xff84A76A, 0xffD3DC7E, 0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
    var bgImages = ['bg01', 'bg02', 'bg03', 'bg04', 'bg05', 'bg06', 'bg07', 'bg08', 'bg09', 'bg10'];


    // CustomPopupMenuController stampController = CustomPopupMenuController();
    /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
    List allIndexs = [];

    return MediaQuery.of(context).size.width < 600 ?
    Scaffold(
      backgroundColor: Color(0xFFEEE9DF),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => InkWell(
              onTap: () {
                BoardController.to.isVisibleContent.value = !BoardController.to.isVisibleContent.value;
              },
              child:
              BoardController.to.isVisibleContent.value == false ?
              Icon(Icons.remove_red_eye, size: 28, color: Colors.white,) :
              Icon(Icons.remove_circle, size: 28, color: Colors.white,),
            ),
            ),
            SizedBox(width: 20,),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      auctionListIndiDialog(context);
                    },
                    child: Text('낙찰보기', style: TextStyle(color: Colors.white))),
                SizedBox(width: 20,),
                Image.asset('assets/images/coin.png', width: 35,),
                SizedBox(width: 7,),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('auction_coin').where('name', isEqualTo: GetStorage().read('name')).snapshots(),
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
                      int sum = 0;
                      docs.forEach((doc) {
                        int coin = doc['coin'];
                        sum = sum + coin;
                      });
                      BoardController.to.coin = 100 - sum;
                      // var sum = docs.reduce((a, b) => a['coin'] + b['coin']);
                      return
                        Text(BoardController.to.coin.toString(), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),);
                      // Text((BoardController.to.coin - sum).toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),);
                    }
                ),
              ],
            ),


          ],
        )
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 본문 내용
              Padding(
                padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: AttendanceController.to.attendanceDocs.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
                      addControllers.add(CustomPopupMenuController());

                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
                              .where('main_id', isEqualTo: BoardController.to.selected_main_id).where('number', isEqualTo: attendanceDoc['number'])
                          // .snapshots(),
                              .orderBy('date', descending: true).snapshots(),
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
                            // List indiDocs = snapshot.data!.docs.toList();
                            // indiDocs.sort((a,b)=> b['date'].compareTo(a['date']));
                            return
                              Column(
                                children: [
                                  /// 번호, 이름, 추가아이콘
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      // itemCount: indiDocs.length,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (_, index) {
                                        // DocumentSnapshot indiDoc = indiDocs[index];
                                        DocumentSnapshot indiDoc = snapshot.data!.docs[index];
                                        /// 스탬프 전체찍기 위해
                                        if (!allIndexs.contains('${attendanceDoc['number']}-${index}')) {
                                          allIndexs.add('${attendanceDoc['number']}-${index}');
                                        }

                                        // 댓글 날짜순 정렬
                                        List commentList = indiDoc['comment'];
                                        commentList.sort((a, b) => a['date'].compareTo(b['date']));
                                        indiCnt ++;
                                        updTitleCnt ++;
                                        updContentCnt ++;
                                        /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
                                        ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
                                        ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
                                        // addCommentCnt ++;
                                        addCommentCnt = 0;
                                        updIndiControllers.add(CustomPopupMenuController());
                                        updTitleInputControllers.add(TextEditingController());
                                        updContentInputControllers.add(TextEditingController());
                                        addCommentControllers.add(TextEditingController());

                                        return Padding(
                                          padding: EdgeInsets.only(top: 10, right: 0),
                                          child: Container(
                                            // width: 250,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  /// 제목
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 200,
                                                        child: Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                                      ),
                                                      GetStorage().read('number') == indiDoc['number'] ?
                                                      // GetStorage().read('number') == indiDoc['number'] || GetStorage().read('job') == 'teacher' ?
                                                      /// 수정아이콘
                                                      InkWell(
                                                        highlightColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        splashColor: Colors.transparent,
                                                        onTap: () {
                                                          /// 이거안하면 텍스트필드 onchange없으면 널값 됨
                                                          BoardController.to.indiTitleInput = indiDoc['title'];
                                                          BoardController.to.indiContent = indiDoc['content'];
                                                          // Get.off(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi'}, );
                                                          Get.off(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi', 'title' : Get.arguments['title'], 'main_id' : BoardController.to.selected_main_id, 'background': Get.arguments['background'],
                                                            'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun'],}, );
                                                        },
                                                        child: Container(
                                                            width: 50,
                                                            child: Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),)),
                                                      ) :
                                                      StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('auction_estimate').where('main_id', isEqualTo: BoardController.to.selected_main_id)
                                                              .where('number', isEqualTo: indiDoc['number']).where('estimaters', arrayContains: GetStorage().read('number')).snapshots(),
                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                            if (!snapshot.hasData) {
                                                              return SizedBox();
                                                            }
                                                            if (snapshot.data!.docs.length > 0) {
                                                              return SizedBox();
                                                            }else{
                                                              return
                                                                /// 평가
                                                                InkWell(
                                                                  highlightColor: Colors.transparent,
                                                                  hoverColor: Colors.transparent,
                                                                  splashColor: Colors.transparent,
                                                                  onTap: () {
                                                                    estimateIndiDialog(context, indiDoc['number'], attendanceDoc['name']);
                                                                  },
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(color: Color(0xff6690AC), borderRadius: BorderRadius.circular(20)),
                                                                    child: Text('평가',style: TextStyle(fontSize: 15,  color: Colors.white),),
                                                                  ),
                                                                );
                                                            }
                                                          }
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  /// 전체화면 선택할때만 내용, 이미지 보이게
                                                  Obx(() => Visibility(
                                                    visible: GetStorage().read('number') == indiDoc['number']  || BoardController.to.isVisibleContent.value,
                                                    child: Column(children: [
                                                      /// 내용, 이미지로딩중
                                                      Stack(children: [
                                                        indiDoc['content'].length > 0 ?
                                                        Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                        BoardController.to.isImageLoading.value == true && indiDoc['number'] == GetStorage().read('number') && index == 0 ?
                                                        Center(child: Container(
                                                          height: 40,
                                                          child: LoadingIndicator(
                                                              indicatorType: Indicator.ballPulse,
                                                              colors: BoardController.to.kDefaultRainbowColors,
                                                              strokeWidth: 2,
                                                              backgroundColor: Colors.transparent,
                                                              pathBackgroundColor: Colors.transparent
                                                          ),
                                                        ),) : SizedBox(),
                                                      ],),
                                                      SizedBox(height: 5,),
                                                      /// 이미지
                                                      indiDoc['imageUrl'].length != 0 ?
                                                      InkWell(
                                                        onTap: () {
                                                          if (GetStorage().read('number') == indiDoc['number']) {
                                                            imageDialog(context, indiDoc.id, indiDoc['imageUrl'], true);
                                                          }else {
                                                            imageDialog(context, indiDoc.id, indiDoc['imageUrl'], false);
                                                          }

                                                        },
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          child: Image.network(indiDoc['imageUrl']),
                                                        ),
                                                      )
                                                          : SizedBox(),
                                                    ],),
                                                  ),
                                                  ),

                                                  /// 이모티콘
                                                  indiDoc['stamp'] == '' ? SizedBox() :
                                                  Row(
                                                    children: [
                                                      Expanded(child: SizedBox()),
                                                      Container(
                                                        height: 32,
                                                        child: Image.asset('assets/images/${indiDoc['stamp']}'),
                                                      ),
                                                    ],
                                                  ),

                                                  Divider(color: Colors.black,),
                                                  SizedBox(height: 5,),
                                                  /// 댓글허용 여부
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                                          .where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
                                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return SizedBox();
                                                        }
                                                        return
                                                          Visibility(
                                                            visible: snapshot.data!.docs.first['isAcceptComment'],
                                                            child: Column(
                                                              children: [
                                                                /// 댓글리스트
                                                                ListView.builder(
                                                                    shrinkWrap: true,
                                                                    itemCount: commentList.length,
                                                                    itemBuilder: (_, index) {
                                                                      commentCnt ++;
                                                                      updCommentControllers.add(CustomPopupMenuController());
                                                                      updCommentInputCnt ++;
                                                                      updCommentInputControllers.add(TextEditingController());
                                                                      return Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),),
                                                                              Text(commentList[index]['comment'], style: TextStyle(fontSize: 13, color: Colors.orange,),),
                                                                            ],
                                                                          ),
                                                                          Divider(height: 5),
                                                                        ],
                                                                      );
                                                                    }
                                                                ),
                                                                /// 이거 안해주면 index 에러남
                                                                Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                                SizedBox(height: 10,),
                                                                /// 댓글입력
                                                                Container(
                                                                  height: 32,
                                                                  child: TextField(
                                                                    controller: addCommentControllers[addCommentCnt - 1],
                                                                    textAlignVertical: TextAlignVertical.center,
                                                                    onSubmitted: (value) {
                                                                      bool isNumeric(String s) {
                                                                        if (s == null) {
                                                                          return false;
                                                                        }
                                                                        return double.tryParse(s) != null;
                                                                      }

                                                                      if (isNumeric(value)) {
                                                                        if ( value.trim().length > 0 && BoardController.to.coin >= int.parse(value)) {
                                                                          BoardController.to.saveComment(indiDoc, value.trim(), 'board_indi');
                                                                          for(var con in addCommentControllers)
                                                                            con.clear();
                                                                        } else {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text('입찰가가 없거나 너무 큽니다'),
                                                                                duration: Duration(seconds: 3),
                                                                              )
                                                                          );
                                                                        }
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(
                                                                              content: Text('숫자만 입력하세요'),
                                                                              duration: Duration(seconds: 3),
                                                                            )
                                                                        );
                                                                      }


                                                                    },

                                                                    style: TextStyle(fontFamily: 'Jua', color: Colors.orange, fontSize: 17, ),
                                                                    // minLines: 1,
                                                                    maxLines: 1,
                                                                    decoration: InputDecoration(
                                                                      hintText: '입찰가 입력',
                                                                      hintStyle: TextStyle(fontSize: 15, color: Colors.teal.withOpacity(0.5)),
                                                                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.teal, width: 2 ),),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.teal, width: 2 ),),
                                                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                      }
                                                  ),

                                                ],
                                              ),


                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              );
                          }
                      );
                    }
                ),
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),


      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        backgroundColor: Colors.transparent,
        onPressed: () {
          /// 이거 안하면 수정 누른후 바로 추가 누르면 제목,내용 가지고 옴
          BoardController.to.indiTitleInput = '';
          BoardController.to.indiContent = '';

          /// argument 안넘기고 저장후 get.back하면 폰에서는 회색화면만 뜸
          Get.off(() => BoardAddMoblie(), arguments: {'title' : Get.arguments['title'], 'main_id' : BoardController.to.selected_main_id, 'background': Get.arguments['background'],
            'content': Get.arguments['content'], 'id': Get.arguments['id'], 'type': 'indi', 'gubun': Get.arguments['gubun']});
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
          height: 70.0,
          width: 70.0,
          child: Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    ) :
    Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // color: Color(Get.arguments['bg_color']),
          /// 길이가 10이면 배경색깔
          decoration: Get.arguments['background'].length == 10 ?
          BoxDecoration(color: Color(int.parse(Get.arguments['background']))) :
          BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + Get.arguments['background'] + '.png'), fit: BoxFit.cover, opacity: 0.8),),
          child: Column(
            children: [
              /// 윗쪽
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 홈
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.off(() => AuctionMain());
                          // Get.back();
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/images/quiz_home_icon.png', height: 30,),
                            SizedBox(height: 5,),
                            Text('집으로', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 13,),)
                          ],
                        ),
                        // child: Image.asset('assets/images/font_home.png', height: 50),
                      ),
                      SizedBox(width: 20,),
                      /// 제목
                      Container(
                        width: MediaQuery.of(context).size.width*0.68,
                        height: 70,
                        child: Stack(
                          children: <Widget>[
                            Text(BoardController.to.mainTitleInput, style: TextStyle(fontFamily: 'Jua', fontSize: 30,
                              foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.black.withOpacity(0.3),),),
                            Text(BoardController.to.mainTitleInput, style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white,),),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      /// 설명보기
                      Get.arguments['content'].length > 0 ?
                      TextButton(
                        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                        onPressed: () {
                          hintDialog(context, Get.arguments['content']);
                        },
                        child: Text('설명보기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
                      )
                          :
                      SizedBox(),
                      SizedBox(width: 10,),
                      GetStorage().read('job') == 'teacher' ?
                      Row(
                        children: [
                          SizedBox(width: 30  ,),
                          /// 설정
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {

                            },
                            child: CustomPopupMenu(
                              menuOnChange: (bool) {
                                titleSettingController.text = Get.arguments['title'];
                                titleSettingController.selection = TextSelection.fromPosition(TextPosition(offset: titleSettingController.text.length));
                                contentSettingController.text = Get.arguments['content'];
                                contentSettingController.selection = TextSelection.fromPosition(TextPosition(offset: contentSettingController.text.length));

                              },
                              controller: popupSettingController,
                              // arrowColor: Color(pop_bgcolor),
                              arrowSize: 20,
                              child: Text('설정',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
                              // child: Image.asset('assets/images/font_setting.png', height: 32),
                              menuBuilder: () => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 400,
                                  height: MediaQuery.of(context).size.height*0.8,
                                  // height: 550,
                                  // color: Color(pop_bgcolor),
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
                                                child: TextButton(
                                                  style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                                                  onPressed: () {
                                                    if (BoardController.to.mainTitleInput.length > 0) {
                                                      BoardController.to.updAuctionMain(Get.arguments['id']);
                                                      popupSettingController.hideMenu();
                                                    }
                                                  },
                                                  child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
                                                ),
                                                // child: InkWell(
                                                //     onTap: () {
                                                //       if (BoardController.to.mainTitleInput.length > 0) {
                                                //         BoardController.to.updBoardMain(Get.arguments['id']);
                                                //         popupSettingController.hideMenu();
                                                //       }
                                                //     },
                                                //     // child: Image.asset('assets/images/font_upd.png', height: 32),
                                                // ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 370, height: 40,
                                            child: TextField(
                                              controller: titleSettingController,
                                              // controller: TextEditingController(text: Get.arguments['title']),
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
                                              controller: contentSettingController,
                                              onChanged: (value) {
                                                BoardController.to.mainContentInput = value;
                                              },
                                              style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
                                              // minLines: 1,
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                hintText: '힌트를 입력하세요',
                                                hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
                                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),

                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
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
                                                  highlightColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
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
                                                  highlightColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
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
                                          SizedBox(height: 10,),
                                          /// 댓글 허용 여부
                                          Container(
                                            width: 370,
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                                              child:
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('댓글허용', style: TextStyle(color: Colors.white, fontSize: 16),),
                                                  Obx(() => InkWell(
                                                    highlightColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    splashColor: Colors.transparent,
                                                    onTap: () {
                                                      BoardController.to.isRepeatToggle.value = !BoardController.to.isRepeatToggle.value;
                                                      BoardController.to.updAcceptComment(Get.arguments['id']);
                                                    },
                                                    child: BoardController.to.isRepeatToggle.value == true
                                                        ? Icon(Icons.toggle_on, color: Colors.yellow, size: 45,)
                                                        : Icon(Icons.toggle_off, color: Colors.grey, size: 45,),
                                                  ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30,),
                                          /// 삭제
                                          Container(
                                            width: 370,
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                                              child:
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('삭제 ', style: TextStyle(color: Colors.white, fontSize: 16),),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:15, right:5, top:15, bottom: 15),
                                                    child:
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
                                                      onPressed: () {
                                                        popupSettingController.hideMenu();
                                                        delDialog(context, Get.arguments['id'], BoardController.to.selected_main_id);

                                                      },
                                                      child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                          ),

                          SizedBox(width: 30,),
                          DashboardController.to.game_gubun == '보드' ?
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              if (BoardController.to.stamps.value.length == 0) {
                                BoardController.to.stamps.value = allIndexs;
                                BoardController.to.addAllStamp(BoardController.to.selected_main_id, 'indi');
                              }else {
                                BoardController.to.stamps.value = [];
                                BoardController.to.delAllStamp(BoardController.to.selected_main_id, 'indi');
                              }
                            },
                            child: Text('전체도장찍기/해제',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
                          ) :
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              auctionListDialog(context);
                            },
                            child: Text('낙찰자보기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
                          ) ,
                          SizedBox(width: 20,),
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              estimateTotalDialog(context);
                            },
                            child: Text('상호평가결과',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
                          ) ,
                          SizedBox(width: 20,),
                          /// qr코드
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              qrDialog(context);
                            },
                            child: Text('QR 코드',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.black, ),),
                          ),
                        ],
                      ) : SizedBox(),
                      SizedBox(width: 20,),
                    ]
                ),
              ),
              SizedBox(height: 5,),
              /// 본문 내용
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width*0.01,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min, // 스크롤은 부드럽게 하기 위해 필요
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.98,
                        child: AlignedGridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          /// 교실 작은 컴퓨터가 1920이라서 5로 하면 너무 사이가 벌어져서 내용이 삐져나옴
                          crossAxisCount: MediaQuery.of(context).size.width > 1800 ? 7 :
                          // crossAxisCount: MediaQuery.of(context).size.width > 2000 ? 7 :
                          MediaQuery.of(context).size.width < 1000 ? 4: 5,
                          mainAxisSpacing: 50,
                          crossAxisSpacing: 14,
                          itemCount: AttendanceController.to.attendanceDocs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
                            addControllers.add(CustomPopupMenuController());

                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                    .where('main_id', isEqualTo: BoardController.to.selected_main_id).where('number', isEqualTo: attendanceDoc['number'])
                                    .orderBy('date', descending: true).snapshots(),
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
                                  /// 겹치는 거 방지
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    BoardController.to.nowdate.value = DateTime.now().toString();
                                  });

                                  return
                                    Obx(() => Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /// 이거 안하면 추가할때 밑의 번호뒤로 겹쳐지는 경우 발생
                                          Text(BoardController.to.nowdate.value, style: TextStyle(color: Colors.transparent, fontSize: 0),),
                                          /// 번호, 이름
                                          GetStorage().read('number') == attendanceDoc['number'] ?
                                          CustomPopupMenu(
                                            menuOnChange: (bool) {
                                              /// 이거 안하면 수정 누른후 바로 추가 누르면 제목,내용 가지고 옴
                                              BoardController.to.indiTitleInput = '';
                                              BoardController.to.indiContent = '';
                                              if (bool == false && BoardController.to.popCloseType == 'nosave') {
                                                BoardController.to.imageModel.value.imageInt8 = null;
                                              }
                                            },
                                            controller: addController,
                                            // controller: addControllers[index],
                                            arrowSize: 20,
                                            child: Container(
                                              width: 300,
                                              height: 30,
                                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                              child: Center(child: Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),)),
                                            ),
                                            menuBuilder: () => ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Obx(() => AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                width: BoardController.to.imageModel.value.imageInt8 == null ? 380 : 600,
                                                height: 270,
                                                color: Color(0xFF4C4C4C),
                                                child: BoardController.to.imageModel.value.imageInt8 == null ?
                                                SingleChildScrollView(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(15),
                                                              child: InkWell(
                                                                highlightColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                splashColor: Colors.transparent,
                                                                onTap: () {
                                                                  BoardController.to.selectImage();
                                                                },
                                                                child: Image.asset('assets/images/camera.png', height: 32),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(15),
                                                              child: InkWell(
                                                                  highlightColor: Colors.transparent,
                                                                  hoverColor: Colors.transparent,
                                                                  splashColor: Colors.transparent,
                                                                  onTap: () {
                                                                    if (BoardController.to.indiTitleInput.length > 0) {
                                                                      BoardController.to.popCloseType = 'save';
                                                                      BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
                                                                      // addControllers[index].hideMenu();
                                                                      addController.hideMenu();
                                                                    }
                                                                  },
                                                                  child: Image.asset('assets/images/font_save.png', height: 32)),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 0, right: 15),
                                                          child: SizedBox(
                                                            width: 350, height: 30,
                                                            child: TextField(
                                                              textAlignVertical: TextAlignVertical.center,
                                                              onChanged: (value) {
                                                                BoardController.to.indiTitleInput = value;
                                                              },
                                                              style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                              // minLines: 1,
                                                              maxLines: 1,
                                                              decoration: InputDecoration(
                                                                hintText: '제목을 입력하세요',
                                                                hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                                                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5, right: 15),
                                                          child: SizedBox(
                                                            width: 350, height: 150,
                                                            child: TextField(
                                                              onChanged: (value) {
                                                                BoardController.to.indiContent = value;
                                                              },
                                                              style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                              minLines: 10,
                                                              maxLines: null,
                                                              decoration: InputDecoration(
                                                                hintText: '내용을 입력하세요',
                                                                hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: 5,),

                                                      ]
                                                  ),
                                                ) :
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 200, height: 269,
                                                          child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover),
                                                        ),
                                                        Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                                                      ],
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      width: 380,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(15),
                                                                    child: InkWell(
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      splashColor: Colors.transparent,
                                                                      onTap: () {
                                                                        BoardController.to.selectImage();
                                                                      },
                                                                      child: Image.asset('assets/images/camera.png', height: 32),
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.all(15),
                                                                    child: InkWell(
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      splashColor: Colors.transparent,
                                                                      onTap: () {
                                                                        if (BoardController.to.indiTitleInput.length > 0) {
                                                                          BoardController.to.popCloseType = 'save';
                                                                          BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
                                                                        }
                                                                        addController.hideMenu();
                                                                      },
                                                                      child: Image.asset('assets/images/font_save.png', height: 32),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 0, right: 15),
                                                                child: SizedBox(
                                                                  width: 350, height: 30,
                                                                  child: TextField(
                                                                    /// 제목 입력후 이미지 선택하면 제목이 사라져서 밑에거 추가함
                                                                    controller: TextEditingController(text: BoardController.to.indiTitleInput),
                                                                    textAlignVertical: TextAlignVertical.center,
                                                                    onChanged: (value) {
                                                                      BoardController.to.indiTitleInput = value;
                                                                    },
                                                                    style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                    // minLines: 1,
                                                                    maxLines: 1,
                                                                    decoration: InputDecoration(
                                                                      hintText: '제목을 입력하세요',
                                                                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                                                                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 5, right: 15),
                                                                child: SizedBox(
                                                                  width: 350, height: 150,
                                                                  child: TextField(
                                                                    controller: TextEditingController(text: BoardController.to.indiContent),
                                                                    onChanged: (value) {
                                                                      BoardController.to.indiContent = value;
                                                                    },
                                                                    style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                    minLines: 10,
                                                                    maxLines: null,
                                                                    decoration: InputDecoration(
                                                                      hintText: '내용을 입력하세요',
                                                                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(height: 5,),
                                                            ]
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ),
                                              ),
                                            ),
                                            pressType: PressType.singleClick,
                                            verticalMargin: -10,

                                          ) :
                                          Container(
                                            width: 300,
                                            height: 30,
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                            child: Center(child: Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),)),
                                          ),

                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (_, index) {
                                                DocumentSnapshot indiDoc = snapshot.data!.docs[index];
                                                /// 스탬프 전체찍기 위해
                                                if (!allIndexs.contains('${attendanceDoc['number']}-${index}')) {
                                                  allIndexs.add('${attendanceDoc['number']}-${index}');
                                                }

                                                // 댓글 날짜순 정렬
                                                List commentList = indiDoc['comment'];
                                                commentList.sort((a, b) => a['date'].compareTo(b['date']));

                                                indiCnt ++;
                                                // updTitleCnt ++;
                                                // updContentCnt ++;
                                                updTitleCnt = 0;
                                                updContentCnt = 0;
                                                /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
                                                ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
                                                ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
                                                // addCommentCnt ++;
                                                addCommentCnt = 0;
                                                updIndiControllers.add(CustomPopupMenuController());
                                                updTitleInputControllers.add(TextEditingController());
                                                updContentInputControllers.add(TextEditingController());
                                                addCommentControllers.add(TextEditingController());

                                                return Padding(
                                                  padding: EdgeInsets.only(top: 10, right: 0),
                                                  child: Container(
                                                    width: 250,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          /// 제목
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: 190,
                                                                child: Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                                              ),
                                                              GetStorage().read('number') == attendanceDoc['number']  || GetStorage().read('job') == 'teacher' ?
                                                              /// 수정아이콘
                                                              CustomPopupMenu(
                                                                menuOnChange: (bool) {
                                                                  BoardController.to.imageModel.value.imageInt8 = null;
                                                                  BoardController.to.indiTitleInput = indiDoc['title'];
                                                                  BoardController.to.indiContent = indiDoc['content'];
                                                                  // 텍스트필드 커서 뒤로 보내기
                                                                  updTitleInputControllers[updTitleCnt - 1].text = BoardController.to.indiTitleInput;
                                                                  updTitleInputControllers[updTitleCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updTitleInputControllers[updTitleCnt - 1].text.length));
                                                                  updContentInputControllers[updContentCnt - 1].text = BoardController.to.indiContent;
                                                                  updContentInputControllers[updContentCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updContentInputControllers[updContentCnt - 1].text.length));
                                                                },
                                                                controller: updIndiControllers[indiCnt-1],
                                                                arrowSize: 20,
                                                                child:
                                                                Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),),

                                                                menuBuilder: () => ClipRRect(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  child:
                                                                  Obx(() => AnimatedContainer(
                                                                    duration: const Duration(milliseconds: 300),
                                                                    width: indiDoc['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
                                                                    380 : 600,
                                                                    height: 270,
                                                                    color: Color(0xFF4C4C4C),
                                                                    child: indiDoc['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
                                                                    SingleChildScrollView(
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                InkWell(
                                                                                  highlightColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  splashColor: Colors.transparent,
                                                                                  onTap: () {
                                                                                    BoardController.to.selectImage();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Image.asset('assets/images/camera.png', height: 32),
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: SizedBox()),
                                                                                InkWell(
                                                                                  highlightColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  splashColor: Colors.transparent,
                                                                                  onTap: () {
                                                                                    BoardController.to.delBoardIndi(indiDoc);
                                                                                    for(var con in updIndiControllers)
                                                                                      con.hideMenu();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Image.asset('assets/images/font_delete.png', height: 32),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  highlightColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  splashColor: Colors.transparent,
                                                                                  onTap: () {
                                                                                    BoardController.to.updBoardIndi(indiDoc);
                                                                                    for(var con in updIndiControllers)
                                                                                      con.hideMenu();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    child: Image.asset('assets/images/font_upd.png', height: 32),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            /// 제목수정
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 0, right: 15),
                                                                              child: SizedBox(
                                                                                width: 350, height: 30,
                                                                                child: TextField(
                                                                                  controller: updTitleInputControllers[updTitleCnt - 1],
                                                                                  textAlignVertical: TextAlignVertical.center,
                                                                                  onChanged: (value) {
                                                                                    BoardController.to.indiTitleInput = value;
                                                                                  },
                                                                                  style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                                  // minLines: 1,
                                                                                  maxLines: 1,
                                                                                  decoration: InputDecoration(
                                                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            /// 내용수정
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 5, right: 15),
                                                                              child: SizedBox(
                                                                                width: 350, height: 150,
                                                                                child: TextField(
                                                                                  controller: updContentInputControllers[updContentCnt - 1],
                                                                                  onChanged: (value) {
                                                                                    BoardController.to.indiContent = value;
                                                                                  },
                                                                                  style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                                  minLines: 10,
                                                                                  maxLines: null,
                                                                                  decoration: InputDecoration(
                                                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            SizedBox(height: 5,),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 380,
                                                                                  child: BoardController.to.imageModel.value.imageInt8 == null
                                                                                      ? SizedBox()
                                                                                      :
                                                                                  Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill),
                                                                                ),
                                                                                Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                                                                              ],
                                                                            ),

                                                                          ]
                                                                      ),
                                                                    ) :
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Container(
                                                                              width: 200, height: 269,
                                                                              child: BoardController.to.imageModel.value.imageInt8 == null ?
                                                                              Image.network(indiDoc['imageUrl'], fit: BoxFit.cover) :
                                                                              Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover),
                                                                            ),
                                                                            Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                                                                          ],
                                                                        ),
                                                                        SizedBox(width: 10,),
                                                                        Container(
                                                                          width: 380,
                                                                          child: SingleChildScrollView(
                                                                            child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        highlightColor: Colors.transparent,
                                                                                        hoverColor: Colors.transparent,
                                                                                        splashColor: Colors.transparent,
                                                                                        onTap: () {
                                                                                          BoardController.to.selectImage();
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(15),
                                                                                          child: Image.asset('assets/images/camera.png', height: 32),
                                                                                        ),
                                                                                      ),
                                                                                      // Padding(
                                                                                      //   padding: const EdgeInsets.all(15),
                                                                                      //   child: IconButton(
                                                                                      //     icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
                                                                                      //     onPressed: () {
                                                                                      //       BoardController.to.selectImage();
                                                                                      //     },
                                                                                      //   ),
                                                                                      //   // child: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
                                                                                      // ),
                                                                                      Row(
                                                                                        children: [
                                                                                          InkWell(
                                                                                            highlightColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            splashColor: Colors.transparent,
                                                                                            onTap: () {
                                                                                              BoardController.to.delBoardIndi(indiDoc);
                                                                                              for(var con in updIndiControllers)
                                                                                                con.hideMenu();
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(15),
                                                                                              child: Image.asset('assets/images/font_delete.png', height: 32),
                                                                                            ),
                                                                                          ),
                                                                                          // SizedBox(width: 30,),
                                                                                          InkWell(
                                                                                            highlightColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            splashColor: Colors.transparent,
                                                                                            onTap: () async{
                                                                                              await BoardController.to.updBoardIndi(indiDoc);
                                                                                              /// await 안붙히고 비동기로 처리하면 디비저장전에 hide가 먼저처리되어서 image값이 null 됨
                                                                                              for(var con in updIndiControllers)
                                                                                                con.hideMenu();
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(15),
                                                                                              child: Image.asset('assets/images/font_upd.png', height: 32),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      // Padding(
                                                                                      //   padding: const EdgeInsets.all(15),
                                                                                      //   child:
                                                                                      //   ElevatedButton(
                                                                                      //     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
                                                                                      //     onPressed: () {
                                                                                      //       BoardController.to.delBoardIndi(indiDoc);
                                                                                      //       for(var con in updIndiControllers)
                                                                                      //         con.hideMenu();
                                                                                      //     },
                                                                                      //     child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
                                                                                      //   ),
                                                                                      // ),


                                                                                      // Padding(
                                                                                      //   padding: const EdgeInsets.all(15),
                                                                                      //   child:
                                                                                      //   ElevatedButton(
                                                                                      //     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
                                                                                      //     onPressed: () async {
                                                                                      //       // await 안하면 menutonchange가 먼저 실행되어 titleinput값이 제대로 반영 안됨
                                                                                      //       await BoardController.to.updBoardIndi(indiDoc);
                                                                                      //       for(var con in updIndiControllers)
                                                                                      //         con.hideMenu();
                                                                                      //     },
                                                                                      //     child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
                                                                                      //   ),
                                                                                      // ),
                                                                                    ],
                                                                                  ),
                                                                                  /// 제목 수정
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 0, right: 15),
                                                                                    child: SizedBox(
                                                                                      width: 350, height: 30,
                                                                                      child: TextField(
                                                                                        controller: updTitleInputControllers[updTitleCnt - 1],
                                                                                        textAlignVertical: TextAlignVertical.center,
                                                                                        onChanged: (value) {
                                                                                          BoardController.to.indiTitleInput = value;
                                                                                        },
                                                                                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                                        // minLines: 1,
                                                                                        maxLines: 1,
                                                                                        decoration: InputDecoration(
                                                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  /// 내용 수정
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 5, right: 15),
                                                                                    child: SizedBox(
                                                                                      width: 350, height: 150,
                                                                                      child: TextField(
                                                                                        controller: updContentInputControllers[updContentCnt - 1],
                                                                                        onChanged: (value) {
                                                                                          BoardController.to.indiContent = value;
                                                                                        },
                                                                                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                                                                                        minLines: 10,
                                                                                        maxLines: null,
                                                                                        decoration: InputDecoration(
                                                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ]
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ),
                                                                  ),
                                                                ),
                                                                pressType: PressType.singleClick,
                                                                verticalMargin: -10,

                                                              ) : SizedBox(),
                                                              InkWell(
                                                                  onTap: () {
                                                                    fullScreenDialog(context, indiDoc['title'], indiDoc['content'], indiDoc['imageUrl'], attendanceDoc['number'], attendanceDoc['name'], BoardController.to.selected_main_id,);
                                                                  },
                                                                  child: Icon(Icons.fullscreen, size: 28, color: Colors.grey,),
                                                              ),

                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          /// 내용, 이미지로딩중
                                                          Obx(() => Stack(children: [
                                                            indiDoc['content'].length > 0 ?
                                                            Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                            BoardController.to.isImageLoading.value == true && indiDoc['number'] == GetStorage().read('number') && index == 0 ?
                                                            Center(child: Container(
                                                              height: 40,
                                                              child: LoadingIndicator(
                                                                  indicatorType: Indicator.ballPulse,
                                                                  colors: BoardController.to.kDefaultRainbowColors,
                                                                  strokeWidth: 2,
                                                                  backgroundColor: Colors.transparent,
                                                                  pathBackgroundColor: Colors.transparent
                                                              ),
                                                            ),) : SizedBox(),
                                                            // Container(
                                                            //   decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
                                                            //   height: 30,
                                                            //   width: 100,
                                                            //   child: Text('이미지 로딩중...', style: TextStyle(color: Colors.black),),
                                                            // ) : SizedBox(),
                                                          ],),
                                                          ),

                                                          SizedBox(height: 5,),
                                                          /// 이미지
                                                          indiDoc['imageUrl'].length != 0 ?
                                                          InkWell(
                                                            onTap: () {
                                                              if (GetStorage().read('number') == indiDoc['number']) {
                                                                imageDialog(context, indiDoc.id, indiDoc['imageUrl'], true);
                                                              }else {
                                                                imageDialog(context, indiDoc.id, indiDoc['imageUrl'], false);
                                                              }

                                                            },
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                              child: Image.network(indiDoc['imageUrl']),
                                                            ),
                                                          )
                                                              : SizedBox(),
                                                          /// 이모티콘
                                                          indiDoc['stamp'] == '' ? SizedBox() :
                                                          Row(
                                                            children: [
                                                              Expanded(child: SizedBox()),
                                                              Container(
                                                                height: 32,
                                                                child: Image.asset('assets/images/${indiDoc['stamp']}'),
                                                              ),
                                                            ],
                                                          ),

                                                          Divider(color: Colors.black,),
                                                          SizedBox(height: 5,),
                                                          /// 댓글허용 여부
                                                          StreamBuilder<QuerySnapshot>(
                                                              stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                                                  .where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
                                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                if (!snapshot.hasData) {
                                                                  return SizedBox();
                                                                }
                                                                return
                                                                  Visibility(
                                                                    visible: snapshot.data!.docs.first['isAcceptComment'],
                                                                    child: Column(
                                                                      children: [
                                                                        /// 댓글 리스트
                                                                        ListView.builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: commentList.length,
                                                                            itemBuilder: (_, index) {
                                                                              commentCnt ++;
                                                                              updCommentControllers.add(CustomPopupMenuController());
                                                                              updCommentInputCnt ++;
                                                                              updCommentInputControllers.add(TextEditingController());
                                                                              return
                                                                                Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),),
                                                                                            SizedBox(width: 10,),
                                                                                            Text(commentList[index]['comment'], style: TextStyle(fontSize: 13, color: Colors.orange,),),
                                                                                          ],
                                                                                        ),
                                                                                        // GetStorage().read('job') == 'teacher' ?
                                                                                        // /// 댓글수정아이콘
                                                                                        // CustomPopupMenu(
                                                                                        //   menuOnChange: (bool) {
                                                                                        //     BoardController.to.indiCommentInput = commentList[index]['comment'];
                                                                                        //     // 텍스트필드 커서 뒤로 보내기
                                                                                        //     updCommentInputControllers[updCommentInputCnt - 1].text = BoardController.to.indiCommentInput;
                                                                                        //     updCommentInputControllers[updCommentInputCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updCommentInputControllers[updCommentInputCnt - 1].text.length));
                                                                                        //   },
                                                                                        //   controller: updCommentControllers[commentCnt-1],
                                                                                        //   arrowSize: 20,
                                                                                        //   child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
                                                                                        //   menuBuilder: () => ClipRRect(
                                                                                        //     borderRadius: BorderRadius.circular(15),
                                                                                        //     child: Container(
                                                                                        //       width: 220,
                                                                                        //       height: 200,
                                                                                        //       color: Color(0xFF4C4C4C),
                                                                                        //       child: IntrinsicWidth(
                                                                                        //         child: Column(
                                                                                        //             crossAxisAlignment: CrossAxisAlignment.end,
                                                                                        //             children: [
                                                                                        //               Row(
                                                                                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        //                 children: [
                                                                                        //                   Padding(
                                                                                        //                     padding: const EdgeInsets.all(15),
                                                                                        //                     child: InkWell(
                                                                                        //                       onTap: () async{
                                                                                        //                         await BoardController.to.delComment(indiDoc.id, commentList[index], 'board_indi');
                                                                                        //                         for(var con in updCommentControllers)
                                                                                        //                           con.hideMenu();
                                                                                        //                       },
                                                                                        //                       child: Image.asset('assets/images/font_delete.png', height: 25),
                                                                                        //                     ),
                                                                                        //                   ),
                                                                                        //                   Padding(
                                                                                        //                     padding: const EdgeInsets.all(15),
                                                                                        //                     child: InkWell(
                                                                                        //                       onTap: () async{
                                                                                        //                         await BoardController.to.updComment(indiDoc.id, commentList[index], 'board_indi');
                                                                                        //                         for(var con in updCommentControllers)
                                                                                        //                           con.hideMenu();
                                                                                        //                       },
                                                                                        //                       child: Image.asset('assets/images/font_upd.png', height: 25),
                                                                                        //                     ),
                                                                                        //                   ),
                                                                                        //                 ],
                                                                                        //               ),
                                                                                        //               Padding(
                                                                                        //                 padding: const EdgeInsets.only(left:10, right: 10),
                                                                                        //                 // padding: const EdgeInsets.only(top: 10, right: 15,),
                                                                                        //                 child: Container(
                                                                                        //                   width: 200, height: 120,
                                                                                        //                   child: TextField(
                                                                                        //                     controller: updCommentInputControllers[updCommentInputCnt - 1],
                                                                                        //                     textAlignVertical: TextAlignVertical.center,
                                                                                        //                     onChanged: (value) {
                                                                                        //                       BoardController.to.indiCommentInput = value;
                                                                                        //                     },
                                                                                        //                     style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
                                                                                        //                     // minLines: 1,
                                                                                        //                     maxLines: 5,
                                                                                        //                     decoration: InputDecoration(
                                                                                        //                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                                        //                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                                        //
                                                                                        //                     ),
                                                                                        //                   ),
                                                                                        //                 ),
                                                                                        //               ),
                                                                                        //
                                                                                        //             ]
                                                                                        //         ),
                                                                                        //       ),
                                                                                        //     ),
                                                                                        //   ),
                                                                                        //   pressType: PressType.singleClick,
                                                                                        //   verticalMargin: -10,
                                                                                        // ) : SizedBox(),
                                                                                      ],
                                                                                    ),
                                                                                    Divider(height: 5),

                                                                                  ],
                                                                                );
                                                                            }
                                                                        ),
                                                                        /// 이거 안해주면 index 에러남
                                                                        Text((updTitleCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                                        Text((updContentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                                        Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                                        /// 댓글입력
                                                                        Container(
                                                                          height: 32,
                                                                          child: TextField(
                                                                            controller: addCommentControllers[addCommentCnt - 1],
                                                                            textAlignVertical: TextAlignVertical.center,
                                                                            onSubmitted: (value) {
                                                                              if ( value.trim().length > 0 && BoardController.to.coin >= int.parse(value)) {
                                                                                BoardController.to.saveComment(indiDoc, value.trim(), 'board_indi');
                                                                                for(var con in addCommentControllers)
                                                                                  con.clear();
                                                                              }
                                                                            },

                                                                            style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 16, ),
                                                                            // minLines: 1,
                                                                            maxLines: 1,
                                                                            decoration: InputDecoration(
                                                                              hintText: '입찰가 입력',
                                                                              hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                                                                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                              }
                                                          ),
                                                        ],
                                                      ),


                                                    ),
                                                  ),
                                                );
                                              }
                                          ),

                                        ],
                                      ),
                                    ),
                                    );
                                }
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40,),
                    ],
                  ),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width*0.01,
                    height: MediaQuery.of(context).size.height,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );

  }
}







