import 'package:carousel_slider/carousel_slider.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/subject_controller.dart';
import 'package:get/get.dart';

class SubjectDiary extends StatelessWidget {
  TextEditingController titleSettingController = TextEditingController();
  TextEditingController contentSettingController = TextEditingController();
  List updIndiControllers = [];
  List updCommentControllers = [];
  List addCommentControllers = [];
  List updTitleInputControllers = [];
  List updContentInputControllers = [];
  List updCommentInputControllers = [];
  int subject_cnt = 0;
  int commentCnt = 0;
  int addCommentCnt = 0;
  int updTitleCnt = 0;
  int updContentCnt = 0;
  int updCommentInputCnt = 0;
  /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
  List allIndexs = [];

  void updCommentDialog(context, comment) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 170,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          SubjectController.to.delComment(comment);
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delete_forever_outlined, ),
                            Text('삭제', style: TextStyle(fontFamily: 'Jua'),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 110,
                      child: TextField(
                        controller: TextEditingController(text: comment['comment']),
                        onChanged: (value) {
                          SubjectController.to.comment = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
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
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            // CupertinoDialogAction(isDefaultAction: true, child: Text('삭제', style: TextStyle(color: Colors.red),), onPressed: () {
            //   SubjectController.to.delComment(comment);
            //   Navigator.pop(context);
            // }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () {
              SubjectController.to.updComment(comment);
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  void fullScreenDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEEE9DF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.4,
            height: MediaQuery.of(context).size.width*0.7,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            SubjectController.to.subject_full_screen_text_size.value = 45;
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.delete_forever_outlined, size: 30, color: Colors.black),
                              Text('닫기', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.black),),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(number.toString() + '번',style: TextStyle(fontSize: 30, fontFamily: 'Jua', color: Colors.teal),),
                        //     ),
                        //     SizedBox(width: 10,),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(name,style: TextStyle(fontSize: 30, fontFamily: 'Jua', color: Colors.teal),),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                SubjectController.to.subject_full_screen_text_size.value = SubjectController.to.subject_full_screen_text_size.value + 5;
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.text_increase, size: 30, color: Colors.black),
                                  Text('글자크게', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.black),),
                                ],
                              ),
                            ),
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            //   onPressed: () {
                            //     BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value + 5;
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Text('글자 크게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            //   ),
                            // ),
                            SizedBox(width: 30,),
                            InkWell(
                              onTap: () {
                                SubjectController.to.subject_full_screen_text_size.value = SubjectController.to.subject_full_screen_text_size.value - 5;
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.text_decrease, size: 30, color: Colors.black),
                                  Text('글자작게', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.black),),
                                ],
                              ),
                            ),
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            //   onPressed: () {
                            //     BoardController.to.board_full_screen_text_size.value = BoardController.to.board_full_screen_text_size.value - 5;
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Text('글자 작게',style: TextStyle(fontSize: 25,  color: Colors.white),),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     child: Column(
                    //       children: [
                    //         Icon(Icons.delete_forever_outlined, size: 30, color: Colors.black),
                    //         Text('닫기', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.black),),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Obx(() => Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(SubjectController.to.content, style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: SubjectController.to.subject_full_screen_text_size.value,),),
                    ),
                    ),
                    // Container(
                    //   // height: 350,
                    //   child: TextField(
                    //     controller: TextEditingController(text: SubjectController.to.content),
                    //     onChanged: (value) {
                    //       SubjectController.to.content = value;
                    //     },
                    //     style: TextStyle(fontFamily: 'Jua', fontSize: 40, height: 1.3, color: Colors.black ),
                    //     maxLines: null,
                    //     decoration: InputDecoration(
                    //       hintText: '내용을 입력하세요',
                    //       hintStyle: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.5)),
                    //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                    //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                    //     ),
                    //   ),
                    // ),

                  ]
              ),
            ),
          ),
        );
      },
    );

  }

  void updContentDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
              // width: 500,
            height: 500,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async{
                          await SubjectController.to.delSubjectDiary();
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delete_forever_outlined, ),
                            Text('삭제', style: TextStyle(fontFamily: 'Jua'),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 350,
                      child: TextField(
                        controller: TextEditingController(text: SubjectController.to.content),
                        onChanged: (value) {
                          SubjectController.to.content = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', fontSize: 20 ),
                        maxLines: 15,
                        decoration: InputDecoration(
                          hintText: '내용을 입력하세요',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.5)),
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
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            // CupertinoDialogAction(isDefaultAction: true, child: Text('삭제', style: TextStyle(color: Colors.red),), onPressed: () {
            //   SubjectController.to.delComment(comment);
            //   Navigator.pop(context);
            // }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () async{
              await SubjectController.to.updSubjectDiary();
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  void saveSubjectDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 200,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      child: TextField(
                        controller: TextEditingController(text: SubjectController.to.subject.value),
                        onChanged: (value) {
                          SubjectController.to.subject.value = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
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
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () async{
              await SubjectController.to.saveSubject();
              await SubjectController.to.getSubjects();
              SubjectController.to.dummy_date.value = DateTime.now().toString();
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
          children: [
            /// 더미
            Text(SubjectController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                saveSubjectDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left:40,  top:10, ),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(SubjectController.to.subjects[SubjectController.to.subject_id.value].subject, style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 30),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
              child: AlignedGridView.count(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  /// 교실 작은 컴퓨터가 1920이라서 5로 하면 너무 사이가 벌어져서 내용이 삐져나옴
                  crossAxisCount: MediaQuery.of(context).size.width > 1800 ? 7 :
                  // crossAxisCount: MediaQuery.of(context).size.width > 2000 ? 7 :
                  MediaQuery.of(context).size.width < 1000 ? 4: 5,
                  mainAxisSpacing: 50,
                  crossAxisSpacing: 14,
                  itemCount: AttendanceController.to.attendanceDocs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('subject_diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                            .where('date', isEqualTo: SubjectController.to.mmdd_yoil.value).where('number', isEqualTo: attendanceDoc['number']).snapshots(),
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
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (_, index) {
                                      DocumentSnapshot subject_doc = snapshot.data!.docs[index];

                                      // 댓글 날짜순 정렬
                                      List commentList = subject_doc['comment'];
                                      commentList.sort((a, b) => a['date'].compareTo(b['date']));
                                      subject_cnt ++;
                                      updTitleCnt ++;
                                      updContentCnt ++;
                                      /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
                                      ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
                                      ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
                                      // addCommentCnt ++;
                                      addCommentCnt = 0;
                                      updTitleInputControllers.add(TextEditingController());
                                      updContentInputControllers.add(TextEditingController());
                                      addCommentControllers.add(TextEditingController());

                                      return Padding(
                                        padding: EdgeInsets.only(top: 10, right: 0),
                                        child: InkWell(
                                          onTap: () {
                                            if (GetStorage().read('number') == attendanceDoc['number'] || GetStorage().read('job') == 'teacher') {
                                              SubjectController.to.subject_diary_id = subject_doc.id;
                                              SubjectController.to.content = subject_doc['content'];
                                              // updContentDialog(context);
                                              fullScreenDialog(context);
                                            }
                                          },
                                          child: Container(
                                            // width: 250,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  /// 전체화면 선택할때만 내용
                                                  Column(children: [
                                                    subject_doc['content'].length > 0 ?
                                                    Text(subject_doc['content'],  style: TextStyle(fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                  ],),

                                                  Divider(color: Colors.black,),
                                                  /// 좋아요
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              SubjectController.to.subject_diary_id = subject_doc.id;
                                                              if (subject_doc['like'].contains(GetStorage().read('number'))) {
                                                                SubjectController.to.delLike(GetStorage().read('number'));
                                                              }else {
                                                                SubjectController.to.addLike(GetStorage().read('number'));
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 30,
                                                              child: subject_doc['like'].contains(GetStorage().read('number')) == true ?
                                                              Icon(Icons.favorite, size: 20, color: Colors.red,) :
                                                              Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
                                                            ),
                                                          ),
                                                          Text(subject_doc['like'].length.toString(), style: TextStyle(color: Colors.black),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: 15,),
                                                  /// 댓글허용 여부
                                                  /// /// 댓글 없애니 겹치는거 해결되어서 막음, 학급보드는 댓글이 필요해서 그냥 둠
                                                  // StreamBuilder<QuerySnapshot>(
                                                  //     stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
                                                  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  //       if (!snapshot.hasData) {
                                                  //         return SizedBox();
                                                  //       }
                                                  //       return
                                                  //         Visibility(
                                                  //           visible: snapshot.data!.docs.first['subject_comment'],
                                                  //           child: Column(
                                                  //             children: [
                                                  //               Text(snapshot.data!.docs.first['subject_comment'].toString()),
                                                  //               /// 댓글리스트
                                                  //               ListView.builder(
                                                  //                   shrinkWrap: true,
                                                  //                   itemCount: commentList.length,
                                                  //                   itemBuilder: (_, index) {
                                                  //                     commentCnt ++;
                                                  //                     updCommentInputCnt ++;
                                                  //                     updCommentInputControllers.add(TextEditingController());
                                                  //                     return Column(
                                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                       children: [
                                                  //                         Row(
                                                  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //                           children: [
                                                  //                             Row(
                                                  //                               children: [
                                                  //                                 Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                  //                                 SizedBox(width: 2,),
                                                  //                                 Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
                                                  //                                     commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
                                                  //                                   style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                  //                               ],
                                                  //                             ),
                                                  //                             GetStorage().read('name') == commentList[index]['name'] || GetStorage().read('job') == 'teacher' ?
                                                  //                             /// 댓글수정아이콘
                                                  //                             InkWell(
                                                  //                               onTap: () {
                                                  //                                 SubjectController.to.subject_diary_id = subject_doc.id;
                                                  //                                 updCommentDialog(context, commentList[index]);
                                                  //                               },
                                                  //                               child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
                                                  //                             ) : SizedBox(),
                                                  //                           ],
                                                  //                         ),
                                                  //                         Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
                                                  //                         SizedBox(height: 3,),
                                                  //                       ],
                                                  //                     );
                                                  //                   }
                                                  //               ),
                                                  //               /// 이거 안해주면 index 에러남
                                                  //               Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                  //               SizedBox(height: 10,),
                                                  //               /// 댓글입력
                                                  //               Container(
                                                  //                 height: 28,
                                                  //                 child: TextField(
                                                  //                   controller: addCommentControllers[addCommentCnt - 1],
                                                  //                   textAlignVertical: TextAlignVertical.center,
                                                  //                   onSubmitted: (value) {
                                                  //                     SubjectController.to.subject_diary_id = subject_doc.id;
                                                  //                     if (value.trim().length > 0) {
                                                  //                       SubjectController.to.saveComment(value.trim());
                                                  //                       for(var con in addCommentControllers)
                                                  //                         con.clear();
                                                  //                     }
                                                  //
                                                  //                   },
                                                  //
                                                  //                   style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
                                                  //                   // minLines: 1,
                                                  //                   maxLines: 1,
                                                  //                   decoration: InputDecoration(
                                                  //                     hintText: '댓글 입력',
                                                  //                     hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
                                                  //                     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                  //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                  //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                  //                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                  //
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         );
                                                  //     }
                                                  // ),

                                                ],
                                              ),


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
    );

  }
}



