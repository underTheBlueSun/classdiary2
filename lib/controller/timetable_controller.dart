import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class TimetableController extends GetxController {
  static TimetableController get to => Get.find();

  RxString selectedDate = DateTime.now().toString().obs;

  @override
  void onInit() async {
    super.onInit();
    // saveTimetable();
  }

  RxList timeTableItems = [].obs;
  // RxList timeTableItems = [].obs;
  void setTimetable() async{
    timeTableItems.value = [];
    var yyyy = DateTime.now().year.toString();
    var email = GetStorage().read('email');

    await FirebaseFirestore.instance.collection('timetable').where('email', isEqualTo: email)
        .where('yyyy', isEqualTo: DateTime.now().year.toString()).get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length == 0) {
        timeTableItems.value = [
          {'email': email, 'yyyy': yyyy, 'weekday': '',  'class0': '0', 'class1': '1', 'class2': '2', 'class3': '3', 'class4': '4', 'class5': '5', 'class6': '6', 'class7': '7','order': '1'},
          {'email': email, 'yyyy': yyyy, 'weekday': '월', 'class0': '아침', 'class1': '', 'class2': '', 'class3': '', 'class4': '', 'class5': '', 'class6': '', 'class7': '방과후', 'order': '2'},
          {'email': email, 'yyyy': yyyy, 'weekday': '화', 'class0': '아침', 'class1': '', 'class2': '', 'class3': '', 'class4': '', 'class5': '', 'class6': '', 'class7': '방과후', 'order': '3'},
          {'email': email, 'yyyy': yyyy, 'weekday': '수', 'class0': '아침', 'class1': '', 'class2': '', 'class3': '', 'class4': '', 'class5': '', 'class6': '', 'class7': '방과후', 'order': '4'},
          {'email': email, 'yyyy': yyyy, 'weekday': '목', 'class0': '아침', 'class1': '', 'class2': '', 'class3': '', 'class4': '', 'class5': '', 'class6': '', 'class7': '방과후', 'order': '5'},
          {'email': email, 'yyyy': yyyy, 'weekday': '금', 'class0': '아침', 'class1': '', 'class2': '', 'class3': '', 'class4': '', 'class5': '', 'class6': '', 'class7': '방과후', 'order': '6'},
          ];
        timeTableItems.value.forEach((item) async {
          await FirebaseFirestore.instance.collection('timetable').add(item).catchError((error) { print(error); });
        });

      }

    }); //  then

  }


  void updTimetable(id, value, gubun) async{
    // var index = timeTableItems.indexWhere((item) => item['order'] == doc['order']);
    if(gubun == 'class1') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class1': value});
    }else if (gubun == 'class2') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class2': value});
    }else if (gubun == 'class3') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class3': value});
    }else if (gubun == 'class4') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class4': value});
    }else if (gubun == 'class5') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class5': value});
    }else if (gubun == 'class6') {
      await FirebaseFirestore.instance.collection('timetable').doc(id).update({ 'class6': value});
    }

  }


  void getToDoCnt() async{
    // var now = DateTime.now();
    // var nowYMD = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // await FirebaseFirestore.instance.collection('todo').where('email', isEqualTo: email).get()
    //     .then((QuerySnapshot querySnapshot) {
    //   toDoTatalCnt.value = querySnapshot.docs.length;
    // });

  }

}