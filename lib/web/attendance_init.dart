// import 'package:allcheck/attendance_detail.dart';
import 'package:classdiary2/web/signinup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'attendance_model.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class AttendanceInit extends StatelessWidget {
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // var cnt = 0;
    return Column(
      children: [
        SizedBox(height: 10,),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AttendanceController.to.isSubmit.value == true ?
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                /// 이거 안해주면 출석부에서 이름 추가할때 칸 모양 이상해 진다.
                AttendanceController.to.selectedDate.value = DateTime.now().toString();
                Navigator.pop(context);
              },
              child: Icon(Icons.close_outlined, color: Colors.grey,),
            ) : SizedBox(),
            SizedBox(width: 10,),
          ],),
        ),
        SizedBox(height: 10,),
        Text('출석부', style: TextStyle(fontSize: 17,),),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
            /// 1월,2월은 전학년도 처리
                .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ?
            (int.parse(AttendanceController.to.selectedDate.value.substring(0,4))-1).toString() : AttendanceController.to.selectedDate.value.substring(0,4) )
                .orderBy('number', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
              }
              Future.delayed(const Duration(milliseconds: 400), () {  //  시간 텀을 안주면 build 중에 obx 불렀다고 에러남.
                AttendanceController.to.attendanceCnt.value = snapshot.data!.docs.length;
              });

              return Container( //  list를 container로 감싸야 독자적으로 스크롤 된다.
                height: 500,
                child: GridView.builder(
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
                        border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5,),
                          Container(
                            width: 19,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: 100, height: 10,
                            child: TextField(
                              // maxLength: 5,
                              controller: TextEditingController(text: doc['name']),
                              // onChanged: (value) {
                              //   if(doc['number'] == snapshot.data!.docs.length && value == '') {  //  마지막번호 이름을 지우면 번호까지 삭제가 되게
                              //     AttendanceController.to.delAttendance(doc.id);
                              //   }else{
                              //     AttendanceController.to.updAttendance(doc.id, value);
                              //   }
                              //   AttendanceController.to.isSubmit.value = true;
                              // },
                              onSubmitted: (value) {
                                if(doc['number'] == snapshot.data!.docs.length && value == '') {  //  마지막번호 이름을 지우면 번호까지 삭제가 되게
                                  AttendanceController.to.delAttendance(doc.id);
                                }else{
                                  AttendanceController.to.updAttendance(doc.id, value);
                                }
                                AttendanceController.to.isSubmit.value = true;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
        ),
        SizedBox(height: 30,),
        Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 5,),
            Container(
              width: 19,
              child: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.7),
                child: Center(
                  child: Text(
                    (AttendanceController.to.attendanceCnt.value + 1).toString(), style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              width: 300,
              child: TextField(
                focusNode: myFocusNode,
                maxLength: 5,
                controller: TextEditingController(),
                autofocus: true,
                onSubmitted: (value) {
                  AttendanceController.to.saveAttendance(value, AttendanceController.to.attendanceCnt.value + 1);
                  myFocusNode.requestFocus();
                  AttendanceController.to.isSubmit.value = true;

                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '성명을 입력하세요',
                  counterText: '',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.0,),
                ),
              ),
            ),

          ],
        ),
        ),
        Divider(),
        Text('저장은 입력후 엔터,삭제는 이름 지우고 엔터키를 누르세요', style: TextStyle(fontSize: 12),),
      ],
    );
  }
}

