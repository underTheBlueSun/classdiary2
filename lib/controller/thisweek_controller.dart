
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ThisWeekController extends GetxController {
  static ThisWeekController get to => Get.find();

  RxString selectedDate = DateTime.now().toString().obs;
  List weekdays = ['월','화','수','목','금','토','일'];
  RxMap thisweekMap = {}.obs;
  Map<String, String> selectedTimetable = {};

  String class0 = '';
  String content0 = '';
  String class1 = '';
  String content1 = '';
  String class2 = '';
  String content2 = '';
  String class3 = '';
  String content3 = '';
  String class4 = '';
  String content4 = '';
  String class5 = '';
  String content5 = '';
  String class6 = '';
  String content6 = '';
  String class7 = '';
  String content7 = '';
  String memo = '';
  String imageUrl = '';
  String saveID = '';

  RxBool isChangedSubject = false.obs;



  @override
  void onInit() async {
    super.onInit();

  }

  void getThisWeeks() {
    var d = DateTime.parse(selectedDate.value);
    var weekday = d.weekday;
    var firstDayOfWeek = d.subtract(Duration(days: weekday - 1));
    var i = 0;
    // for (var weekday in weekdays) {
    //   thisweekMap[weekday] = firstDayOfWeek.add(Duration(days:i));
    //   i++;
    // }
    for (var weekday in weekdays) {
      /// 토, 일요일 제외
      if (weekday != '토' && weekday != '일') {
        thisweekMap[weekday] = firstDayOfWeek.add(Duration(days:i));
      }
      i++;
    }

  }

  void getTimeTable() async{
    var selectedYoil = DateFormat.E('ko_KR').format(DateTime.parse(ThisWeekController.to.selectedDate.value));
    /// 1월, 2월이면 전학년도 처리
    var yyyy;
    if(DateTime.now().month == 1 || DateTime.now().month == 2 ){
      yyyy = (DateTime.now().year - 1).toString();
    }else{
      yyyy = (DateTime.now().year).toString();
    }

    if (selectedYoil == '토' || selectedYoil == '일') {
      selectedTimetable = {'class0': '', 'class1': '','class2': '','class3': '','class4': '','class5': '','class6': '','class7': ''};
    } else {
      await FirebaseFirestore.instance.collection('timetable').where('email', isEqualTo: GetStorage().read('email'))
          .where('yyyy', isEqualTo: yyyy).where('weekday', isEqualTo: selectedYoil).get()
          .then((QuerySnapshot querySnapshot) {
        /// 1월, 2월이면 전학년도 처리
            if (querySnapshot.docs.length > 0) {
              selectedTimetable = {'class0': querySnapshot.docs[0]['class0'], 'class1': querySnapshot.docs[0]['class1'],'class2': querySnapshot.docs[0]['class2'],
                'class3': querySnapshot.docs[0]['class3'],'class4': querySnapshot.docs[0]['class4'],'class5': querySnapshot.docs[0]['class5'],
                'class6': querySnapshot.docs[0]['class6'],'class7': querySnapshot.docs[0]['class7']};
            }else{
              selectedTimetable = {'class0': '', 'class1': '','class2': '','class3': '','class4': '','class5': '','class6': '','class7': ''};
            }

      });
    }

  }

  // void saveThisweek() async{
  //   await FirebaseFirestore.instance.collection('thisweek')
  //       .add({ 'email': GetStorage().read('email'), 'date': selectedDate.substring(0,10), 'class0': class0, 'content0': content0, 'class1': class1, 'content1': content1, 'class2': class2, 'content2': content2,
  //     'class3': class3, 'content3': content3,'class4': class4, 'content4': content4,'class5': class5, 'content5': content5,'class6': class6, 'content6': content6,'class7': class7, 'content7': content7,'memo' : memo })
  //       .catchError((error) { print(error); });
  //
  // }

  void setThisweek(id) async{
    await FirebaseFirestore.instance.collection('thisweek').doc(id)
        .set({ 'email': GetStorage().read('email'), 'date': selectedDate.substring(0,10), 'class0': class0, 'content0': content0, 'class1': class1,
      'content1': content1, 'class2': class2, 'content2': content2, 'class3': class3, 'content3': content3,'class4': class4, 'content4': content4,
      'class5': class5, 'content5': content5,'class6': class6, 'content6': content6,'class7': class7, 'content7': content7,'memo' : memo, 'imageUrl': imageUrl })
        .catchError((error) { print(error); });

    // saveID = ref.id;

  }

  /// 엑셀
  List all_this_week_list = [];
  void getThisWeekAll() async{
    all_this_week_list = [];
    await FirebaseFirestore.instance.collection('thisweek').where('email', isEqualTo: GetStorage().read('email')).get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        all_this_week_list.add(doc);
      });

    });

  }

  void exportExcel() async{
    /// 번호순 정렬해야 함
    all_this_week_list.sort((a, b) => a['date'].compareTo(b['date']));
    final excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'sheet');
    Sheet sheet = excel['sheet'];
    // final sheet = excel.sheets[excel.getDefaultSheet() as String];
    CellStyle cellStyle = CellStyle(fontSize: 17);
    sheet!.setColumnWidth(2, 50);
    sheet!.setColumnAutoFit(3);

    // var cell1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4));
    // cell1.value = TextCellValue('번호');
    /// 타이틀
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value = TextCellValue('날짜');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value = TextCellValue('아침');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value = TextCellValue('1교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value = TextCellValue('2교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1)).value = TextCellValue('3교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1)).value = TextCellValue('4교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1)).value = TextCellValue('5교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1)).value = TextCellValue('6교시');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1)).value = TextCellValue('방과후');


    int i = 1;
    all_this_week_list.forEach((doc) async {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1+i)).value = TextCellValue(doc['date']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1+i)).value = TextCellValue('[' + doc['class0'] + '] ' + doc['content0']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1+i)).value = TextCellValue('[' + doc['class1'] + '] ' + doc['content1']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1+i)).value = TextCellValue('[' + doc['class2'] + '] ' + doc['content2']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1+i)).value = TextCellValue('[' + doc['class3'] + '] ' + doc['content3']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1+i)).value = TextCellValue('[' + doc['class4'] + '] ' + doc['content4']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1+i)).value = TextCellValue('[' + doc['class5'] + '] ' + doc['content5']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1+i)).value = TextCellValue('[' + doc['class6'] + '] ' + doc['content6']);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 1+i)).value = TextCellValue('[' + doc['class7'] + '] ' + doc['content7']);

      i++;
    });

    excel.save(fileName: "이번주 전체 목록.xlsx");
  }


}
