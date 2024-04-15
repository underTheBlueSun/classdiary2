import 'package:carousel_slider/carousel_slider.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/diary_controller.dart';
import '../controller/exam_controller.dart';
import '../controller/signinup_controller.dart';

class ExamAnswer extends StatelessWidget {

  void answerDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('닫기', style: TextStyle( fontFamily: 'Jua', fontSize: 17),),
                ),
              ),
            ],),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    // controller: TextEditingController(text: doc['memo']),
                    onChanged: (value) {
                      ExamController.to.subject = value;
                    },
                    style: TextStyle( fontSize: 15.0,),
                    decoration: InputDecoration(
                      hintText: "과목 입력",
                      hintStyle: TextStyle(fontSize: 13.0,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(),
                for (int number = 1; number < 26; number++)
                  Row(
                    children: [
                      Container(
                        width: 20,
                        child:
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Center(
                            child: Text(number.toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: 100,
                        // padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          // controller: TextEditingController(text: doc['memo']),
                          onChanged: (value) {
                            ExamController.to.answer_list[ExamController.to.answer_list.indexWhere((e) => e.number == number)].answer = int.parse(value);
                          },
                          // style: TextStyle( fontSize: 15.0,),
                          decoration: InputDecoration(
                            hintText: "${number}번 답안 입력",
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 30,),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, ),
                    onPressed: () async{
                      ExamController.to.addAnswer();
                      Navigator.pop(context);
                    },
                    child: Text('저장', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );

  }

  List won_num_list = ['0', '①', '②', '③', '④'];
  List answer_list = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 답안지작성
        GetStorage().read('email') == 'umssam00@gmail.com' && GetStorage().read('job') == 'teacher' ?
        Container(
          width: 120,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, ),
            onPressed: () async{
              answerDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app_outlined, color: Colors.white,),
                SizedBox(width: 5,),
                Text('정답 등록', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ) : SizedBox(),
        SizedBox(width: 50,),

        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('exam_answer').snapshots(),
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

              if (snapshot.data!.docs.length > 0) {
                var sort_docs = snapshot.data!.docs;
                sort_docs.sort((a, b) => a['id'].compareTo(b['id']));
                return GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    childAspectRatio: 1/8, //item 의 가로, 세로 의 비율
                  ),
                  itemCount: sort_docs.length,
                  itemBuilder: (context, index) {
                    var doc = sort_docs[index];
                    answer_list[0] = doc['a1'];
                    answer_list[1] = doc['a2'];
                    answer_list[2] = doc['a3'];
                    answer_list[3] = doc['a4'];
                    answer_list[4] = doc['a5'];
                    answer_list[5] = doc['a6'];
                    answer_list[6] = doc['a7'];
                    answer_list[7] = doc['a8'];
                    answer_list[8] = doc['a9'];
                    answer_list[9] = doc['a10'];
                    answer_list[10] = doc['a11'];
                    answer_list[11] = doc['a12'];
                    answer_list[12] = doc['a13'];
                    answer_list[13] = doc['a14'];
                    answer_list[14] = doc['a15'];
                    answer_list[15] = doc['a16'];
                    answer_list[16] = doc['a17'];
                    answer_list[17] = doc['a18'];
                    answer_list[18] = doc['a19'];
                    answer_list[19] = doc['a20'];
                    answer_list[20] = doc['a21'];
                    answer_list[21] = doc['a22'];
                    answer_list[22] = doc['a23'];
                    answer_list[23] = doc['a24'];
                    answer_list[24] = doc['a25'];

                    return Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text(doc['subject'], style: TextStyle(fontSize: 15)),
                          Table(
                            border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                            columnWidths: {
                              0: FractionColumnWidth(0.3),
                              1: FractionColumnWidth(0.7)
                            },
                            children: [
                              /// 번호
                              for (int number = 1; number < 26; number++)
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      color: Colors.black.withOpacity(0.4),
                                      child: Text(number.toString(), style: TextStyle(fontSize: 15, color: Colors.white)),
                                    ),
                                  ),
                                  /// 정답
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        color: Colors.white,
                                        child: SelectableText(won_num_list[answer_list[number-1]], style: TextStyle(fontSize: 15, color: Colors.black),),
                                        // child: Text(answer_list[number-1].toString(), style: TextStyle(fontSize: 15, color: Colors.black),),
                                      ),
                                    ),
                                ]),

                            ],
                          ),
                        ],
                      ),
                    );

                  },

                );
              }else{
                return SizedBox();
              }

            }
        ),
      ],
    );

  }
}



