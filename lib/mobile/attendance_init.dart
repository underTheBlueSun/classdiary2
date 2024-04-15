import 'package:classdiary2/mobile/absent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class AttendanceInit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 안보이게
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey,),
        title: Text('출석부 등록', ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => Absent());
                },
                child: Icon(Icons.close_outlined, color: Colors.grey,),
             ),
              SizedBox(width: 10,),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                    maxLength: 5,
                    controller: TextEditingController(),
                    autofocus: true,
                    style: TextStyle(color: Colors.black.withOpacity(0.7), height: 1.0),
                    onSubmitted: (value) {
                      AttendanceController.to.saveAttendance(value, AttendanceController.to.attendanceCnt.value + 1);
                      AttendanceController.to.isSubmit.value = true;

                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '성명을 입력하세요 (저장은 엔터,삭제는 이름 지우고 엔터)',
                      counterText: '',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.0,),
                    ),
                  ),
                ),

              ],
            ),
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

                  Future.delayed(const Duration(milliseconds: 400), () {  //  시간 텀을 안주면 build 중에 obx 불렀다고 에러남.
                    AttendanceController.to.attendanceCnt.value = snapshot.data!.docs.length;
                  });


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
                          border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5,),
                            Container(
                              width: 19,
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: 100, height: 25,
                              child: TextField(
                                // maxLength: 5,
                                controller: TextEditingController(text: doc['name']),
                                style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 17),
                                onSubmitted: (value) {
                                  if(doc['number'] == snapshot.data!.docs.length && value == '') {  //  마지막번호 이름을 지우면 번호까지 삭제가 되게
                                    AttendanceController.to.delAttendance(doc.id);
                                  }else{
                                    AttendanceController.to.updAttendance(doc.id, value);
                                  }
                                  AttendanceController.to.isSubmit.value = true;
                                },
                                decoration: InputDecoration(border: InputBorder.none, counterText: '',),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
            ),
            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}

