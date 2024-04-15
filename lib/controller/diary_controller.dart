import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DiaryController extends GetxController {
  static DiaryController get to => Get.find();

  RxString active_screen = 'diary'.obs;

  List diary_days = [];
  RxInt current_page_index = 0.obs;
  String morning_emotion_icon = '';
  String morning_emotion_name = '';
  String morning_emotion_content = '';
  List checklist_points = [0,0,0,0,0,0,0,0,0,0];
  String learning = '';
  String after_emotion_icon = '';
  String after_emotion_name = '';
  String after_emotion_content = '';
  String notice = '';
  String emotion_gubun = 'morning';
  String today = '';
  List morning_charts = [];
  List checklist_charts = [];
  List after_charts = [];
  String chart_morning_start_date = '';
  String chart_morning_middle_date = '';
  String chart_morning_end_date = '';
  String chart_checklist_start_date = '';
  String chart_checklist_middle_date = '';
  String chart_checklist_end_date = '';
  String chart_after_start_date = '';
  String chart_after_middle_date = '';
  String chart_after_end_date = '';
  String name = '';
  int number = 0;
  RxString diary_gubun = '아침감정내용'.obs;
  RxBool is_hovering_morning = false.obs;
  RxBool is_hovering_after = false.obs;
  RxList is_visible_morning_emotion_contents = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,].obs;
  RxList morning_emotion_content_list = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',].obs;
  RxList is_visible_after_emotion_contents = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,
    false,false,false,false,false,false,false,false,].obs;
  RxList after_emotion_content_list = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',].obs;
  /// List 를 obx로 받으려면 더미를 추가해야 되네.
  RxString dummy_date = DateTime.now().toString().obs;

  List emotion_file_names = ['pleasant','happy','funny','comfort','confident','touched','grateful','glad','expect','sorry','tired','boring','lonely','sad', 'anxious','upset','sore','scary','annoyed','angry'];
  List emotion_names = ['즐거운','기쁜','재밌는','편안한','자신있는','감동한','고마운','반가운','기대되는','미안한','지친','지루한','외로운','슬픈','불안한','속상한','아픈','무서운','짜증나는','화나는'];

  List emotion_goods = ['pleasant','happy','funny','comfort','confident','touched','grateful','glad','expect'];
  List emotion_bads = ['sorry','tired','boring','lonely','sad', 'anxious','upset','sore','scary','annoyed','angry'];

  List checklist = ['아침활동을 성실히 했나요?', '과제/일기/배움공책/독서록을 했나요?', '우유를 잘 먹었나요?', '줄을 서서 이동시 질서를 잘 지켰나요?', '친구랑 사이좋게 지냈나요?',
    '수업시간에 집중하여 경청했나요?', '교실이나 복도에서 질서를 잘 지켰나요?',  '1인1역등 자기역할을 잘 수행했나요?'];

  @override
  void onInit() async {

    /// 생활공책 기간은 올해 1월 ~ 내년 3.1 까지
    DateTime start_date = DateTime(DateTime.now().year, 1, 1);
    DateTime end_date = DateTime(DateTime.now().year + 1, 3, 0);
    for (int i = 0; i <= end_date.difference(start_date).inDays; i++) {
      DateTime day_datetime = start_date.add(Duration(days: i));
      String month = DateFormat('MM').format(day_datetime);
      String day = DateFormat('dd').format(day_datetime);
      String dayofweek = DateFormat('EEE', 'ko_KR').format(day_datetime);
      diary_days.add('${month}월 ${day}일(${dayofweek})');
    }

  }

  Future<void> getMorningEmotionChart() async{
    morning_charts = [];
    chart_morning_start_date = '';
    chart_morning_middle_date = '';
    chart_morning_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          if (emotion_goods.contains(doc['morning_emotion_icon'])) {
            morning_charts.add({'date': date, 'index': index, 'point': 5});
          }else {
            morning_charts.add({'date': date, 'index': index, 'point': 1});
          }
        });
        chart_morning_start_date = morning_charts[0]['date'];
        chart_morning_middle_date = morning_charts[(morning_charts.length/2).floor()]['date'];
        chart_morning_end_date = morning_charts[morning_charts.length - 1]['date'];

      }
    });

  }

  Future<void> getChecklistEmotionChart() async{
    checklist_charts = [];
    chart_checklist_start_date = '';
    chart_checklist_middle_date = '';
    chart_checklist_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          int point = doc['checklist_01'] + doc['checklist_02'] + doc['checklist_03'] + doc['checklist_04'] + doc['checklist_05'] + doc['checklist_06']
              + doc['checklist_07'] + doc['checklist_08'] + doc['checklist_09'] + doc['checklist_10'];
          checklist_charts.add({'date': date, 'index': index, 'point': point});
        });
        chart_checklist_start_date = checklist_charts[0]['date'];
        chart_checklist_middle_date = checklist_charts[(checklist_charts.length/2).floor()]['date'];
        chart_checklist_end_date = checklist_charts[checklist_charts.length - 1]['date'];

      }
    });

  }

  Future<void> getAfterEmotionChart() async{
    after_charts = [];
    chart_after_start_date = '';
    chart_after_middle_date = '';
    chart_after_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          if (emotion_goods.contains(doc['after_emotion_icon'])) {
            after_charts.add({'date': date, 'index': index, 'point': 5});
          }else {
            after_charts.add({'date': date, 'index': index, 'point': 1});
          }
        });
        chart_after_start_date = after_charts[0]['date'];
        chart_after_middle_date = after_charts[(after_charts.length/2).floor()]['date'];
        chart_after_end_date = after_charts[after_charts.length - 1]['date'];

      }
    });

  }



}






