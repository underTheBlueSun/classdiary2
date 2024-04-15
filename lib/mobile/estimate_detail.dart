import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/tablecalendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/attendance_controller.dart';
import 'package:intl/intl.dart';

import '../controller/signinup_controller.dart';

// ignore_for_file: prefer_const_constructors

class EstimateDetail extends StatelessWidget {

  void calendarDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 400,
            width: 300,
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
                    SizedBox(width: 10,),
                  ],),
                TableCalendarWidget(gubun: 'estimate',),
              ],
            ),
          ),
        );
      },
    );
  }

  void updTitleDialog(BuildContext context, title) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 150.0,
            child: Column(
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
                Text('제목 수정'),
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    controller: TextEditingController(text: title),
                    // onChanged: (value) {
                    //   EstiController.to.title.value = value;
                    // },
                    onSubmitted: (value) {
                      if (value != '') {
                        EstiController.to.title.value = value;
                        EstiController.to.updTitle();
                        Navigator.pop(context);
                      }
                    },
                    // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text('저장은 엔터키', style: TextStyle(fontSize: 12, color: Colors.grey),)
              ],
            ),
          ),
        );
      },
    );
  }

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
                      // Navigator.pop(context);
                      EstiController.to.delEstimate('파일');

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
        title: InkWell(
          onTap: () {
            updTitleDialog(context, EstiController.to.title.value);
          },
          child: Container(
            width: 200,
            child: Obx(() => Center(child: Text(EstiController.to.title.value, overflow: TextOverflow.ellipsis,),)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (EstiController.to.whoCall == 'Thisweek')
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
            if (EstiController.to.whoCall != 'Thisweek')
            Obx(() =>
                Column(
                children: [
                  SizedBox(height: 10,),
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
                            calendarDialog(context);
                          },
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  var s_date = DateTime.parse(EstiController.to.selectedDate.value);
                                  EstiController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day-1).toString();
                                },
                                child: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey, size: 23,),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                EstiController.to.selectedDate.substring(5,7) + '월 ' +
                                    EstiController.to.selectedDate.substring(8,10) + '일(' +
                                    DateFormat.E('ko_KR').format(DateTime.parse(EstiController.to.selectedDate.value)) + ')',
                                style: TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: () {
                                  var s_date = DateTime.parse(EstiController.to.selectedDate.value);
                                  EstiController.to.selectedDate.value = DateTime(s_date.year, s_date.month, s_date.day-1).toString();
                                },
                                child: Icon(Icons.arrow_circle_right_outlined, color: Colors.grey, size: 23,),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            delDialog(context);
                            // EstiController.to.delEstimate('파일');
                          },
                          icon: Icon(Icons.delete_outline, color: Colors.grey,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.withOpacity(0.7),),
      /// 상중하일때만
            if (EstiController.to.esti.value == 'tripple')
            Row(
              children: [
                SizedBox(width: 10,),
                Container(
                  width: 19,
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.7),
                    child: Center(
                      child: Text('상', style: TextStyle(color: Colors.white, fontSize: 12,),),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  width: 19,
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.7),
                    child: Center(
                      child: Text('중', style: TextStyle(color: Colors.white, fontSize: 12,),),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  width: 19,
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Center(
                      child: Text('하', style: TextStyle(color: Colors.white, fontSize: 12,),),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
                    .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
                (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                    .orderBy('number', descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                  }
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 5 / 1, //item 의 가로, 세로 의 비율
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
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
                      child:
                      /// 상중하, 점수로 분기
                      EstiController.to.esti.value == 'tripple'
                      ? Container(
                        // width: 100,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 3,),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('estimate').doc(EstiController.to.id).snapshots(),
                                builder: (BuildContext context1, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                                  }
                                  /// 이거 안해주면 삭제후 에러남(웹은 에러 안남. 왜그렇지?)
                                  if (snapshot.data!.exists) {
                                    return InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        if (doc['name'] == '') {
                                          return;
                                        }
                                        EstiController.to.updNumMapTripple(index+1, snapshot.data!['numMap']['${index + 1}']);
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          Container(
                                            width: 19,
                                            child:
                                            CircleAvatar(
                                              backgroundColor: snapshot.data!['numMap']['${index + 1}'] == '상'
                                                  ? Colors.orange.withOpacity(0.7)
                                                  : snapshot.data!['numMap']['${index + 1}'] == '중'
                                                  ? Colors.teal.withOpacity(0.7)
                                                  : snapshot.data!['numMap']['${index + 1}'] == '하'
                                                  ? Colors.purple
                                                  : Colors.black.withOpacity(0.4),
                                              child: Center(
                                                child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 65,
                                            child: Text(doc['name'], style: TextStyle(fontSize: 17),),

                                          ),
                                        ],
                                      ),
                                    );
                                  }else {
                                    return SizedBox();
                                  }

                                }
                            ),
                          ],
                        ),
                      )
                      : Container(
                        // width: 100,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 3,),
                            FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('estimate').doc(EstiController.to.id).get(),
                                builder: (BuildContext context1, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
                                  }
                                  /// 이거 안해주면 삭제후 에러남(웹은 에러 안남. 왜그렇지?)
                                  if (snapshot.data!.exists) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 19,
                                          child:
                                          CircleAvatar(
                                            backgroundColor: Colors.black.withOpacity(0.7),
                                            child: Center(
                                              child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: 65,
                                          child: Text(doc['name'], style: TextStyle(fontSize: 17),),
                                        ),
                                        SizedBox(width: 30,),
                                        Container(
                                          width: 30, height: 20,
                                          child: TextField(
                                            // focusNode: makeFocusMap(index+1),
                                            controller: TextEditingController(text: snapshot.data!['numMap']['${index+1}']),
                                            style: TextStyle(color: Colors.orange.withOpacity(0.7)),
                                            textAlignVertical: TextAlignVertical.center,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [LengthLimitingTextInputFormatter(3),],
                                            onChanged: (value) {
                                              EstiController.to.updNumMapScore(index+1, value);
                                            },
                                            decoration: InputDecoration(
                                              hintText: '점수',
                                              hintStyle: TextStyle(fontSize: 11, color: Colors.grey, ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }else {
                                    return SizedBox();
                                  }

                                }
                            ),
                          ],
                        ),
                      ),

                    );
                  },

                );
              }
            ),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }

}





