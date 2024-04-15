import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'attendance_controller.dart';

class ExamController extends GetxController {
  static ExamController get to => Get.find();

  RxString active_screen = 'exam_main'.obs;
  String subject = '';
  List answer_list = [Answer(1,0),Answer(2,0),Answer(3,0),Answer(4,0),Answer(5,0),Answer(6,0),Answer(7,0),Answer(8,0),Answer(9,0),Answer(10,0),
    Answer(11,0),Answer(12,0),Answer(13,0),Answer(14,0),Answer(15,0),Answer(16,0),Answer(17,0),Answer(18,0),Answer(19,0),Answer(20,0),
    Answer(21,0),Answer(22,0),Answer(23,0),Answer(24,0),Answer(25,0)];


  @override
  void onInit() async {

  }
  List all_score_list_docs = [];
  // void exportExcel() async{
  //   int korea_all_score = 0;
  //   int society_all_score = 0;
  //   int math_all_score = 0;
  //   int science_all_score = 0;
  //   int eng_all_score = 0;
  //   List all_score_list = [0,0,0,0,0];
  //   // List all_score_list_docs = [];
  //   AttendanceController.to.attendanceDocs.forEach((doc) async {
  //     all_score_list = [0,0,0,0,0];
  //     await FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //         .where('number', isEqualTo: doc['number'] ).get().then((QuerySnapshot snapshot) {
  //
  //       var korea_docs = snapshot.docs.where((doc) => doc['subject'] == '국어');
  //       var society_docs = snapshot.docs.where((doc) => doc['subject'] == '사회');
  //       var math_docs = snapshot.docs.where((doc) => doc['subject'] == '수학');
  //       var science_docs = snapshot.docs.where((doc) => doc['subject'] == '과학');
  //       var eng_docs = snapshot.docs.where((doc) => doc['subject'] == '영어');
  //
  //       if (korea_docs.length > 0) {
  //         korea_all_score = korea_docs.first['a1_score']+korea_docs.first['a2_score']+korea_docs.first['a3_score']+korea_docs.first['a4_score']+korea_docs.first['a5_score']+
  //             korea_docs.first['a6_score']+korea_docs.first['a7_score']+korea_docs.first['a8_score']+korea_docs.first['a9_score']+korea_docs.first['a10_score']+
  //             korea_docs.first['a11_score']+korea_docs.first['a12_score']+korea_docs.first['a13_score']+korea_docs.first['a14_score']+korea_docs.first['a15_score']+
  //             korea_docs.first['a16_score']+ korea_docs.first['a17_score']+korea_docs.first['a18_score']+korea_docs.first['a19_score']+korea_docs.first['a20_score']+
  //             korea_docs.first['a21_score']+ korea_docs.first['a22_score']+korea_docs.first['a23_score']+korea_docs.first['a24_score']+korea_docs.first['a25_score'];
  //       }
  //
  //       if (society_docs.length > 0) {
  //         society_all_score = society_docs.first['a1_score']+society_docs.first['a2_score']+society_docs.first['a3_score']+society_docs.first['a4_score']+society_docs.first['a5_score']+
  //             society_docs.first['a6_score']+society_docs.first['a7_score']+society_docs.first['a8_score']+society_docs.first['a9_score']+society_docs.first['a10_score']+
  //             society_docs.first['a11_score']+society_docs.first['a12_score']+society_docs.first['a13_score']+society_docs.first['a14_score']+society_docs.first['a15_score']+
  //             society_docs.first['a16_score']+ society_docs.first['a17_score']+society_docs.first['a18_score']+society_docs.first['a19_score']+society_docs.first['a20_score']+
  //             society_docs.first['a21_score']+ society_docs.first['a22_score']+society_docs.first['a23_score']+society_docs.first['a24_score']+society_docs.first['a25_score'];
  //       }
  //       if (math_docs.length > 0) {
  //         math_all_score = math_docs.first['a1_score']+math_docs.first['a2_score']+math_docs.first['a3_score']+math_docs.first['a4_score']+math_docs.first['a5_score']+
  //             math_docs.first['a6_score']+math_docs.first['a7_score']+math_docs.first['a8_score']+math_docs.first['a9_score']+math_docs.first['a10_score']+
  //             math_docs.first['a11_score']+math_docs.first['a12_score']+math_docs.first['a13_score']+math_docs.first['a14_score']+math_docs.first['a15_score']+
  //             math_docs.first['a16_score']+ math_docs.first['a17_score']+math_docs.first['a18_score']+math_docs.first['a19_score']+math_docs.first['a20_score']+
  //             math_docs.first['a21_score']+ math_docs.first['a22_score']+math_docs.first['a23_score']+math_docs.first['a24_score']+math_docs.first['a25_score'];
  //       }
  //       if (science_docs.length > 0) {
  //         science_all_score = science_docs.first['a1_score']+science_docs.first['a2_score']+science_docs.first['a3_score']+science_docs.first['a4_score']+science_docs.first['a5_score']+
  //             science_docs.first['a6_score']+science_docs.first['a7_score']+science_docs.first['a8_score']+science_docs.first['a9_score']+science_docs.first['a10_score']+
  //             science_docs.first['a11_score']+science_docs.first['a12_score']+science_docs.first['a13_score']+science_docs.first['a14_score']+science_docs.first['a15_score']+
  //             science_docs.first['a16_score']+ science_docs.first['a17_score']+science_docs.first['a18_score']+science_docs.first['a19_score']+science_docs.first['a20_score']+
  //             science_docs.first['a21_score']+ science_docs.first['a22_score']+science_docs.first['a23_score']+science_docs.first['a24_score']+science_docs.first['a25_score'];
  //       }
  //       if (eng_docs.length > 0) {
  //         eng_all_score = eng_docs.first['a1_score']+eng_docs.first['a2_score']+eng_docs.first['a3_score']+eng_docs.first['a4_score']+eng_docs.first['a5_score']+
  //             eng_docs.first['a6_score']+eng_docs.first['a7_score']+eng_docs.first['a8_score']+eng_docs.first['a9_score']+eng_docs.first['a10_score']+
  //             eng_docs.first['a11_score']+eng_docs.first['a12_score']+eng_docs.first['a13_score']+eng_docs.first['a14_score']+eng_docs.first['a15_score']+
  //             eng_docs.first['a16_score']+ eng_docs.first['a17_score']+eng_docs.first['a18_score']+eng_docs.first['a19_score']+eng_docs.first['a20_score']+
  //             eng_docs.first['a21_score']+ eng_docs.first['a22_score']+eng_docs.first['a23_score']+eng_docs.first['a24_score']+eng_docs.first['a25_score'];
  //       }
  //
  //       all_score_list = [korea_all_score,society_all_score,math_all_score,science_all_score,eng_all_score];
  //
  //     });
  //     all_score_list_docs.add(all_score_list);
  //     print(all_score_list_docs.length);
  //   });
  //   print('----------------------------------------');
  //   print(all_score_list_docs.length);
  //   // exportExcel2(all_score_list_docs);
  // }

  void exportExcel() async{
    /// 번호순 정렬해야 함
    all_score_list_docs.sort((a, b) => a['number'].compareTo(b['number']));
    final excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'test sheet');
    Sheet sheet = excel['test sheet'];
    // final sheet = excel.sheets[excel.getDefaultSheet() as String];
    CellStyle cellStyle = CellStyle(fontSize: 17);
    sheet!.setColumnWidth(2, 50);
    sheet!.setColumnAutoFit(3);

    // var cell1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4));
    // cell1.value = TextCellValue('번호');
    /// 타이틀
    var c1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4));
    var c2 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4));
    var c3 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4));
    var c4 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4));
    var c5 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4));
    var c6 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4));
    var c7 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4));
    c1.value = TextCellValue('번호');
    c1.cellStyle = cellStyle;
    c2.value = TextCellValue('성명');
    c2.cellStyle = cellStyle;
    c3.value = TextCellValue('국어');
    c3.cellStyle = cellStyle;
    c4.value = TextCellValue('사회');
    c4.cellStyle = cellStyle;
    c5.value = TextCellValue('수학');
    c5.cellStyle = cellStyle;
    c6.value = TextCellValue('과학');
    c6.cellStyle = cellStyle;
    c7.value = TextCellValue('영어');
    c7.cellStyle = cellStyle;

    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4)).value = TextCellValue('번호');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4)).value = TextCellValue('성명');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4)).value = TextCellValue('국어');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4)).value = TextCellValue('사회');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4)).value = TextCellValue('수학');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4)).value = TextCellValue('과학');
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4)).value = TextCellValue('영어');


    int i = 1;
    AttendanceController.to.attendanceDocs.forEach((doc) async {

      var c1_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4+i));
      var c2_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4+i));
      var c3_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4+i));
      var c4_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4+i));
      var c5_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4+i));
      var c6_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4+i));
      var c7_1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4+i));

      c1_1.value = TextCellValue(doc['number'].toString());
      c1_1.cellStyle = cellStyle;
      c2_1.value = TextCellValue(doc['name']);
      c2_1.cellStyle = cellStyle;
      c3_1.value = TextCellValue(all_score_list_docs[i-1]['score'][0].toString());
      c3_1.cellStyle = cellStyle;
      c4_1.value = TextCellValue(all_score_list_docs[i-1]['score'][1].toString());
      c4_1.cellStyle = cellStyle;
      c5_1.value = TextCellValue(all_score_list_docs[i-1]['score'][2].toString());
      c5_1.cellStyle = cellStyle;
      c6_1.value = TextCellValue(all_score_list_docs[i-1]['score'][3].toString());
      c6_1.cellStyle = cellStyle;
      c7_1.value = TextCellValue(all_score_list_docs[i-1]['score'][4].toString());
      c7_1.cellStyle = cellStyle;

      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4+i)).value = TextCellValue(doc['number'].toString());
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4+i)).value = TextCellValue(doc['name']);
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4+i)).value = TextCellValue(all_score_list_docs[i-1]['score'][0].toString());
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4+i)).value = TextCellValue(all_score_list_docs[i-1]['score'][1].toString());
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4+i)).value = TextCellValue(all_score_list_docs[i-1]['score'][2].toString());
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4+i)).value = TextCellValue(all_score_list_docs[i-1]['score'][3].toString());
      // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4+i)).value = TextCellValue(all_score_list_docs[i-1]['score'][4].toString());

      i++;
    });

    excel.save();
  }

  // void exportExcel3() async{
  //   int korea_all_score = 0;
  //   int society_all_score = 0;
  //   int math_all_score = 0;
  //   int science_all_score = 0;
  //   int eng_all_score = 0;
  //   List all_score_list = [0,0,0,0,0];
  //
  //   final excel = Excel.createExcel();
  //   excel.rename(excel.getDefaultSheet()!, 'test sheet');
  //   Sheet sheet = excel['test sheet'];
  //   // final sheet = excel.sheets[excel.getDefaultSheet() as String];
  //   CellStyle cellStyle = CellStyle(backgroundColorHex: '#1AFF1A', fontSize: 20);
  //   sheet!.setColumnWidth(2, 50);
  //   sheet!.setColumnAutoFit(3);
  //
  //   // var cell1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4));
  //   // cell1.value = TextCellValue('번호');
  //   /// 타이틀
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4)).value = TextCellValue('번호');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4)).value = TextCellValue('성명');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4)).value = TextCellValue('국어');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4)).value = TextCellValue('사회');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4)).value = TextCellValue('수학');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4)).value = TextCellValue('과학');
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4)).value = TextCellValue('영어');
  //
  //
  //   int i = 1;
  //   AttendanceController.to.attendanceDocs.forEach((doc)  {
  //      FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //         .where('number', isEqualTo: doc['number'] ).get().then((QuerySnapshot snapshot) {
  //
  //     var korea_docs = snapshot.docs.where((doc) => doc['subject'] == '국어');
  //     var society_docs = snapshot.docs.where((doc) => doc['subject'] == '사회');
  //     var math_docs = snapshot.docs.where((doc) => doc['subject'] == '수학');
  //     var science_docs = snapshot.docs.where((doc) => doc['subject'] == '과학');
  //     var eng_docs = snapshot.docs.where((doc) => doc['subject'] == '영어');
  //
  //     if (korea_docs.length > 0) {
  //       korea_all_score = korea_docs.first['a1_score']+korea_docs.first['a2_score']+korea_docs.first['a3_score']+korea_docs.first['a4_score']+korea_docs.first['a5_score']+
  //           korea_docs.first['a6_score']+korea_docs.first['a7_score']+korea_docs.first['a8_score']+korea_docs.first['a9_score']+korea_docs.first['a10_score']+
  //           korea_docs.first['a11_score']+korea_docs.first['a12_score']+korea_docs.first['a13_score']+korea_docs.first['a14_score']+korea_docs.first['a15_score']+
  //           korea_docs.first['a16_score']+ korea_docs.first['a17_score']+korea_docs.first['a18_score']+korea_docs.first['a19_score']+korea_docs.first['a20_score']+
  //           korea_docs.first['a21_score']+ korea_docs.first['a22_score']+korea_docs.first['a23_score']+korea_docs.first['a24_score']+korea_docs.first['a25_score'];
  //     }
  //
  //     if (society_docs.length > 0) {
  //       society_all_score = society_docs.first['a1_score']+society_docs.first['a2_score']+society_docs.first['a3_score']+society_docs.first['a4_score']+society_docs.first['a5_score']+
  //           society_docs.first['a6_score']+society_docs.first['a7_score']+society_docs.first['a8_score']+society_docs.first['a9_score']+society_docs.first['a10_score']+
  //           society_docs.first['a11_score']+society_docs.first['a12_score']+society_docs.first['a13_score']+society_docs.first['a14_score']+society_docs.first['a15_score']+
  //           society_docs.first['a16_score']+ society_docs.first['a17_score']+society_docs.first['a18_score']+society_docs.first['a19_score']+society_docs.first['a20_score']+
  //           society_docs.first['a21_score']+ society_docs.first['a22_score']+society_docs.first['a23_score']+society_docs.first['a24_score']+society_docs.first['a25_score'];
  //     }
  //     if (math_docs.length > 0) {
  //       math_all_score = math_docs.first['a1_score']+math_docs.first['a2_score']+math_docs.first['a3_score']+math_docs.first['a4_score']+math_docs.first['a5_score']+
  //           math_docs.first['a6_score']+math_docs.first['a7_score']+math_docs.first['a8_score']+math_docs.first['a9_score']+math_docs.first['a10_score']+
  //           math_docs.first['a11_score']+math_docs.first['a12_score']+math_docs.first['a13_score']+math_docs.first['a14_score']+math_docs.first['a15_score']+
  //           math_docs.first['a16_score']+ math_docs.first['a17_score']+math_docs.first['a18_score']+math_docs.first['a19_score']+math_docs.first['a20_score']+
  //           math_docs.first['a21_score']+ math_docs.first['a22_score']+math_docs.first['a23_score']+math_docs.first['a24_score']+math_docs.first['a25_score'];
  //     }
  //     if (science_docs.length > 0) {
  //       science_all_score = science_docs.first['a1_score']+science_docs.first['a2_score']+science_docs.first['a3_score']+science_docs.first['a4_score']+science_docs.first['a5_score']+
  //           science_docs.first['a6_score']+science_docs.first['a7_score']+science_docs.first['a8_score']+science_docs.first['a9_score']+science_docs.first['a10_score']+
  //           science_docs.first['a11_score']+science_docs.first['a12_score']+science_docs.first['a13_score']+science_docs.first['a14_score']+science_docs.first['a15_score']+
  //           science_docs.first['a16_score']+ science_docs.first['a17_score']+science_docs.first['a18_score']+science_docs.first['a19_score']+science_docs.first['a20_score']+
  //           science_docs.first['a21_score']+ science_docs.first['a22_score']+science_docs.first['a23_score']+science_docs.first['a24_score']+science_docs.first['a25_score'];
  //     }
  //     if (eng_docs.length > 0) {
  //       eng_all_score = eng_docs.first['a1_score']+eng_docs.first['a2_score']+eng_docs.first['a3_score']+eng_docs.first['a4_score']+eng_docs.first['a5_score']+
  //           eng_docs.first['a6_score']+eng_docs.first['a7_score']+eng_docs.first['a8_score']+eng_docs.first['a9_score']+eng_docs.first['a10_score']+
  //           eng_docs.first['a11_score']+eng_docs.first['a12_score']+eng_docs.first['a13_score']+eng_docs.first['a14_score']+eng_docs.first['a15_score']+
  //           eng_docs.first['a16_score']+ eng_docs.first['a17_score']+eng_docs.first['a18_score']+eng_docs.first['a19_score']+eng_docs.first['a20_score']+
  //           eng_docs.first['a21_score']+ eng_docs.first['a22_score']+eng_docs.first['a23_score']+eng_docs.first['a24_score']+eng_docs.first['a25_score'];
  //     }
  //
  //     all_score_list = [korea_all_score,society_all_score,math_all_score,science_all_score,eng_all_score];
  //
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4+i)).value = TextCellValue(doc['number'].toString());
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4+i)).value = TextCellValue(doc['name']);
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4+i)).value = TextCellValue(all_score_list[0].toString());
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 4+i)).value = TextCellValue(all_score_list[1].toString());
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 4+i)).value = TextCellValue(all_score_list[2].toString());
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 4+i)).value = TextCellValue(all_score_list[3].toString());
  //     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 4+i)).value = TextCellValue(all_score_list[4].toString());
  //
  //     });
  //
  //
  //
  //     i++;
  //   });
  //
  //   excel.save();
  // }



  void addAnswer() async{
    await FirebaseFirestore.instance.collection('exam_answer').where('subject', isEqualTo: subject).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('exam_answer').doc(snapshot.docs.first.id).delete();
      }
    });

    int id = 0;
    if (subject == '국어') { id = 1;}
    else if(subject == '사회') { id = 2;}
    else if(subject == '수학') { id = 3;}
    else if(subject == '과학') { id = 4;}
    else if(subject == '영어') { id = 5;}

    FirebaseFirestore.instance.collection('exam_answer').add({'id': id, 'subject': subject,
      'a1': answer_list[0].answer,'a2': answer_list[1].answer,'a3': answer_list[2].answer,'a4': answer_list[3].answer,'a5': answer_list[4].answer,'a6': answer_list[5].answer,
      'a7': answer_list[6].answer,'a8': answer_list[7].answer,'a9': answer_list[8].answer,'a10': answer_list[9].answer,'a11': answer_list[10].answer,'a12': answer_list[11].answer,
      'a13': answer_list[12].answer,'a14': answer_list[13].answer,'a15': answer_list[14].answer,'a16': answer_list[15].answer,'a17': answer_list[16].answer,
      'a18': answer_list[17].answer,'a19': answer_list[18].answer,'a20': answer_list[19].answer, 'a21': answer_list[20].answer,'a22': answer_list[21].answer,'a23': answer_list[22].answer,
      'a24': answer_list[23].answer,'a25': answer_list[24].answer,});
  }

  void addScore(subject) async{
    await FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('subject', isEqualTo: subject).get().then((QuerySnapshot sheet_snapshot) {
      sheet_snapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('exam_answer').where('class_code', isEqualTo: GetStorage().read('class_code'))
            .where('subject', isEqualTo: subject).get().then((QuerySnapshot answer_snapshot) {
          if (answer_snapshot.docs.length > 0) {
            var a1_score = answer_snapshot.docs.first['a1'] == doc['a1'] ? 1 : 0;
            var a2_score = answer_snapshot.docs.first['a2'] == doc['a2'] ? 1 : 0;
            var a3_score = answer_snapshot.docs.first['a3'] == doc['a3'] ? 1 : 0;
            var a4_score = answer_snapshot.docs.first['a4'] == doc['a4'] ? 1 : 0;
            var a5_score = answer_snapshot.docs.first['a5'] == doc['a5'] ? 1 : 0;
            var a6_score = answer_snapshot.docs.first['a6'] == doc['a6'] ? 1 : 0;
            var a7_score = answer_snapshot.docs.first['a7'] == doc['a7'] ? 1 : 0;
            var a8_score = answer_snapshot.docs.first['a8'] == doc['a8'] ? 1 : 0;
            var a9_score = answer_snapshot.docs.first['a9'] == doc['a9'] ? 1 : 0;
            var a10_score = answer_snapshot.docs.first['a10'] == doc['a10'] ? 1 : 0;
            var a11_score = answer_snapshot.docs.first['a11'] == doc['a11'] ? 1 : 0;
            var a12_score = answer_snapshot.docs.first['a12'] == doc['a12'] ? 1 : 0;
            var a13_score = answer_snapshot.docs.first['a13'] == doc['a13'] ? 1 : 0;
            var a14_score = answer_snapshot.docs.first['a14'] == doc['a14'] ? 1 : 0;
            var a15_score = answer_snapshot.docs.first['a15'] == doc['a15'] ? 1 : 0;
            var a16_score = answer_snapshot.docs.first['a16'] == doc['a16'] ? 1 : 0;
            var a17_score = answer_snapshot.docs.first['a17'] == doc['a17'] ? 1 : 0;
            var a18_score = answer_snapshot.docs.first['a18'] == doc['a18'] ? 1 : 0;
            var a19_score = answer_snapshot.docs.first['a19'] == doc['a19'] ? 1 : 0;
            var a20_score = answer_snapshot.docs.first['a20'] == doc['a20'] ? 1 : 0;
            var a21_score = answer_snapshot.docs.first['a21'] == doc['a21'] ? 1 : 0;
            var a22_score = answer_snapshot.docs.first['a22'] == doc['a22'] ? 1 : 0;
            var a23_score = answer_snapshot.docs.first['a23'] == doc['a23'] ? 1 : 0;
            var a24_score = answer_snapshot.docs.first['a24'] == doc['a24'] ? 1 : 0;
            var a25_score = answer_snapshot.docs.first['a25'] == doc['a25'] ? 1 : 0;

            FirebaseFirestore.instance.collection('exam_sheet').doc(doc.id).update({ 'a1_score': a1_score,'a2_score': a2_score,'a3_score': a3_score,
              'a4_score': a4_score,'a5_score': a5_score,'a6_score': a6_score,'a7_score': a7_score,'a8_score': a8_score,'a9_score': a9_score,'a10_score': a10_score,
              'a11_score': a11_score,'a12_score': a12_score,'a13_score': a13_score,'a14_score': a14_score,'a15_score': a15_score,'a16_score': a16_score,'a17_score': a17_score,
              'a18_score': a18_score,'a19_score': a19_score,'a20_score': a20_score,'a21_score': a21_score,'a22_score': a22_score,'a23_score': a23_score,'a24_score': a24_score,
              'a25_score': a25_score });


          }

        });


      });

    });


  }

  // List answer_list_korea = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  //
  // void addAnswerList() async{
  //   await FirebaseFirestore.instance.collection('exam_answer').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //       .where('국어', isEqualTo: subject).get().then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.length > 0) {
  //       answer_list_korea[0] = snapshot.docs.first['a1'];
  //
  //     }
  //
  //   });
  //
  //
  // }



}

class Answer {
  int number;
  int answer;
  Answer(this.number, this.answer);
}
