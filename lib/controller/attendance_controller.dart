
// import 'package:allcheck/absent_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:hive/hive.dart';

// import 'attendance_model.dart';

// ignore_for_file: prefer_const_constructors

class AttendanceController extends GetxController {
  static AttendanceController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  RxString selectedDate = DateTime.now().toString().obs;
  RxInt attendanceCnt = 0.obs;
  RxBool isSubmit = false.obs;
  RxString gubun = '없음'.obs;
  RxInt absentCnt = 0.obs;
  RxInt agreeCnt = 0.obs;
  String absentMemo = '';
  String attendanceMemo = '';

  var attendanceDocs;

  // Map<int, String> attendanceMap = <int, String>{}; //  출석부

  @override
  void onInit() async {
    super.onInit();

    if (GetStorage().read('email') != null) {
      await getAttendance();
    }


    // makeMapAttendance();  //  출석부 맵 만들기

    // if (selectedDate.toString().substring(5,7) == '01' || selectedDate.toString().substring(5,7) == '02' ) {
    //   selectedDate.value = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day).toString();
    // }
  }

  void saveAttendance(value, number) async{
    await FirebaseFirestore.instance.collection('attendance')
    /// 1월,2월은 전학년도로 처리, 그리고 그외 달에 전년도 수정시에도 반영
        .add({ 'email': GetStorage().read('email'), 'number': number, 'name': value,
      'yyyy': (DateTime.now().month == 1 || DateTime.now().month == 2) ? (int.parse(selectedDate.value.substring(0,4))-1).toString() : selectedDate.value.substring(0,4),
      'memo' : '' })
        // .add({ 'email': GetStorage().read('email'), 'number': number, 'name': value, 'yyyy': DateTime.now().year.toString(), 'memo' : '' })
        .catchError((error) { print(error); });
    /// 출석부
    await getAttendance();

  }

  void updAttendance(id, value) async{
    await FirebaseFirestore.instance.collection('attendance').doc(id)
        .update({ 'name': value }).catchError((error) { print(error); });
  }

  void delAttendance(id) async {
    FirebaseFirestore.instance.collection('attendance').doc(id).delete();
    await getAttendance();
  }

  void saveAbsent(doc, gubun) async{
    var selectedDateYMD = selectedDate.value.substring(0,10);
    if (gubun == '없음') {
      await FirebaseFirestore.instance.collection('absent')
          .add({ 'email': GetStorage().read('email'), 'number': doc['number'], 'name': doc['name'], 'date': selectedDateYMD, 'gubun': '결석', 'memo' : '' })
          .catchError((error) { print(error); });
    }else if (gubun == '결석') {
      await FirebaseFirestore.instance.collection('absent').doc(doc.id)
          .update({ 'gubun': '인정' }).catchError((error) { print(error); });
    }else {
      await FirebaseFirestore.instance.collection('absent').doc(doc.id).delete();
    }
  }

  void getAbsentCnt() async{
    var selectedDateYMD = selectedDate.value.substring(0,10);
    await FirebaseFirestore.instance.collection('absent').where('email', isEqualTo: GetStorage().read('email')).where('date', isEqualTo: selectedDateYMD).get()
        .then((QuerySnapshot querySnapshot) {
        absentCnt.value = querySnapshot.docs.where((doc) => doc['gubun'] == '결석').length;
        agreeCnt.value = querySnapshot.docs.where((doc) => doc['gubun'] == '인정').length;
    });
  }

  void updAbsentMemo(id) async{
    await FirebaseFirestore.instance.collection('absent').doc(id)
        .update({ 'memo': absentMemo }).catchError((error) { print(error); });
  }

  void updAttendanceMemo(id) async{
    await FirebaseFirestore.instance.collection('attendance').doc(id)
        .update({ 'memo': attendanceMemo }).catchError((error) { print(error); });

    attendanceMemo = '';
  }

  List attendanceList = [];
  Future<void> getAttendance() async{
    /// 1월,2월이면 전학년도로 처리
    // var yyyy;
    // if(DateTime.now().month.toString() == '1' || DateTime.now().month.toString() == '2'){
    //   yyyy = DateTime.now().year - 1;
    // }else{
    //   yyyy = DateTime.now().year;
    // }
    await FirebaseFirestore.instance
        .collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
        .where('yyyy', isEqualTo: (DateTime.now().month == 1 || DateTime.now().month == 2) ? (int.parse(selectedDate.value.substring(0,4))-1).toString() : selectedDate.value.substring(0,4) )
        .orderBy('number', descending: false).get()
        .then((QuerySnapshot querySnapshot) {
      // GetStorage().write('attendanceCnt', querySnapshot.docs.length);
      attendanceDocs = querySnapshot.docs;
      attendanceCnt.value = querySnapshot.docs.length;
    });
    // return attendanceDocs;

    attendanceList = [];
    for(var doc in attendanceDocs) {
      // attendanceList.add(doc['name']);
      attendanceList.add({'number': doc['number'], 'name': doc['name']});
    }

  }


} // MainController