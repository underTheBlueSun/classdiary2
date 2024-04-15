
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/quiz/quiz_main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

// class ImageModel {
//   File? pickedImage;
//   File?  thumbnailFile;
//   Uint8List? imageInt8;
// }

class QuizController extends GetxController {
  static QuizController get to => Get.find();

  String school_year = '';
  RxString search_grade = '학년'.obs;
  RxString search_semester = '학기'.obs;
  RxString search_subject = '과목'.obs;
  RxString active_screen = 'all'.obs;
  RxInt is_hover_start = 99999.obs;
  RxInt is_hover_edit = 99999.obs;

  String quiz_id = '';
  String quiz_title = '';
  String quiz_description = '';
  RxString quiz_grade = '1학년'.obs;
  RxString quiz_semester = '1학기'.obs;
  RxString quiz_subject = '국어'.obs;
  RxString quiz_quiz_type = '스피드'.obs;
  // RxString quiz_question_type = '선택형'.obs;
  RxString quiz_timer = 'X'.obs;
  RxString quiz_public_type = '공개'.obs;
  DateTime quiz_date = DateTime.now();
  DateTime question_date = DateTime.now();

  String question_id = '';
  RxString question_type = '선택형'.obs;
  RxString question = ''.obs;
  RxString answer1 = ''.obs;
  RxString answer2 = ''.obs;
  RxString answer3 = ''.obs;
  RxString answer4 = ''.obs;
  RxString question_tex = ''.obs;
  RxString answer1_tex = ''.obs;
  RxString answer2_tex = ''.obs;
  RxString answer3_tex = ''.obs;
  RxString answer4_tex = ''.obs;
  RxString answer = ''.obs;
  String question_image_url = '';
  String answer1_image_url = '';
  String answer2_image_url = '';
  String answer3_image_url = '';
  String answer4_image_url = '';
  RxBool is_visible_count_down = false.obs;
  RxBool is_visible_timer = false.obs;
  RxBool is_visible_start_btn = false.obs;
  RxBool is_visible_answer = false.obs;

  bool is_real_name = true;
  String nickname_input = '';
  RxString active_screen_mobile = 'entrance'.obs;
  RxString active_screen_real = 'entrance'.obs;
  String quiz_class_code = '';
  String score_doc_id = '';
  String start_date = '';
  String end_date = '';
  double remain_time = 0.0;
  RxBool is_visible_score = false.obs;
  int number = 0;
  RxBool is_hover_choice_real = false.obs;
  RxBool is_hover_choice_anonymous = false.obs;


  /// 이미지 처리
  // Rx<ImageModel> imageModel = ImageModel().obs;
  Rx<Uint8List> imageInt8 = Uint8List(0).obs;
  Rx<Uint8List> imageInt8_answer1 = Uint8List(0).obs;
  Rx<Uint8List> imageInt8_answer2 = Uint8List(0).obs;
  Rx<Uint8List> imageInt8_answer3 = Uint8List(0).obs;
  Rx<Uint8List> imageInt8_answer4 = Uint8List(0).obs;

  // RxInt dummy = 0.obs;

  List<Color> kDefaultRainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  List grades = ['1학년', '2학년', '3학년', '4학년', '5학년', '6학년'];
  List semesters = ['1학기', '2학기'];
  List subjects = ['국어', '수학', '사회', '과학', '영어', '실과', '체육', '음악', '미술', '창체'];
  List subjects1 = ['국어', '수학', '사회', '과학', '영어', '실과'];
  List subjects2 = ['체육', '음악', '미술', '창체'];
  List quiz_types = ['스피드', '모둠대항'];
  List question_types = ['선택형', 'OX형', '시험지 배부형'];
  List timers = ['10', '20', '30', '40', '50', '60'];
  // List timers = ['X', '10', '20', '30', '40', '50', '60'];
  List public_types = ['공개', '비공개'];

  @override
  void onInit() async {
    /// 학년도 가져오기
    school_year = DateTime.now().toString().substring(0, 4);
    if (DateTime.now().month == 1 || DateTime.now().month == 2) {
      school_year = (DateTime.now().year - 1).toString();
    }
  }

  void setPlyer() async {
    // await FirebaseFirestore.instance.collection('quiz_player').where('email', isEqualTo: GetStorage().read('email'))
    //     .where('school_year', isEqualTo: school_year).get().then((QuerySnapshot snapshot) {
    await FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code')).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length != AttendanceController.to.attendanceDocs.length) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });

        /// orer2를 둔 이유는 모둠대항전에서 두번이상 참여할 수도 있으니깐
        AttendanceController.to.attendanceDocs.forEach((doc) {
          // FirebaseFirestore.instance.collection('quiz_player').add({'email': GetStorage().read('email'), 'school_year': school_year, 'order1': 0, 'order2': 0, 'date': DateTime.now(),
          //   'number': doc['number'].toString(), 'name': doc['name'], 'modum': '0', 'isActive': false});
          FirebaseFirestore.instance.collection('quiz_player').add({'class_code': GetStorage().read('class_code'), 'order1': 0, 'order2': 0, 'date': DateTime.now(),
            'number': doc['number'].toString(), 'name': doc['name'], 'modum': '0', 'is_active': false});
        });
      }
    });

    Get.to(() => QuizMain());
  }

  void createQuiz() async {
    quiz_date = DateTime.now();
    await FirebaseFirestore.instance.collection('quiz_main').add({'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'), 'date': quiz_date,
      'school_year': school_year, 'title': quiz_title, 'description': quiz_description, 'grade': quiz_grade.value, 'semester': quiz_semester.value, 'subject': quiz_subject.value,
      'quiz_type': quiz_quiz_type.value, 'timer': quiz_timer.value, 'public': quiz_public_type.value, 'like': 0
    })
        .catchError((error) {
      print('createQuiz() : ${error}');
    });

    active_screen.value = 'myquiz';
  }

  void updQuiz() async {
    await FirebaseFirestore.instance.collection('quiz_main').doc(quiz_id).update({'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'),
      'date': quiz_date, 'school_year': school_year, 'title': quiz_title, 'description': quiz_description, 'grade': quiz_grade.value, 'semester': quiz_semester.value,
      'subject': quiz_subject.value, 'quiz_type': quiz_quiz_type.value, 'timer': quiz_timer.value, 'public': quiz_public_type.value
    }).catchError((error) {
      print("정상적으로 업데이트가 되지 않았습니다.");
    });
  }

  // Future<void> createQuestionSelect() async {
  //   question_date = DateTime.now();
  //   DocumentReference doc = await FirebaseFirestore.instance.collection('quiz_question')
  //       .add({'quiz_id': quiz_id, 'date': question_date, 'question': question.value, 'question_image_url': '', 'answer1': answer1.value, 'answer2': answer2.value, 'answer3': answer3.value,
  //     'answer4': answer4.value, 'answer1_image_url': '', 'answer2_image_url': '', 'answer3_image_url': '', 'answer4_image_url': '', 'answer': answer.value, 'state': false })
  //       .catchError((error) {print('createQuestionSelect() : ${error}');});
  //
  //   question_tex.value = '';
  //   answer1_tex.value = '';
  //   answer2_tex.value = '';
  //   answer3_tex.value = '';
  //   answer4_tex.value = '';
  //   question.value = '';
  //   answer1.value = '';
  //   answer2.value = '';
  //   answer3.value = '';
  //   answer4.value = '';
  //   answer.value = '';
  //
  //   /// 이미지 처리
  //   if (imageInt8.value.length > 0 || imageInt8_answer1.value.length > 0 ||
  //       imageInt8_answer2.value.length > 0 ||
  //       imageInt8_answer3.value.length > 0 ||
  //       imageInt8_answer4.value.length > 0) {
  //     await imageToStorage(doc.id);
  //   }
  // }

  /// 선택형
  Future<void> createQuestion() async {
    question_date = DateTime.now();
    var doc;
    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      /// 첫문제를 등록하면 number = 0
      doc = await FirebaseFirestore.instance.collection('quiz_question')
          .add({'number': snapshot.docs.length+1, 'quiz_id': quiz_id, 'date': question_date, 'question': question.value, 'question_image_url': '', 'answer1': answer1.value, 'answer2': answer2.value, 'answer3': answer3.value,
        'answer4': answer4.value, 'answer1_image_url': '', 'answer2_image_url': '', 'answer3_image_url': '', 'answer4_image_url': '', 'answer': answer.value, 'state': '', 'question_type': question_type.value })
          .catchError((error) {print('createQuestionSelect() : ${error}');});
    });
    //   if (snapshot.docs.isEmpty) {
    //     doc = await FirebaseFirestore.instance.collection('quiz_question')
    //         .add({'number': 1, 'quiz_id': quiz_id, 'date': question_date, 'question': question.value, 'question_image_url': '', 'answer1': answer1.value, 'answer2': answer2.value, 'answer3': answer3.value,
    //       'answer4': answer4.value, 'answer1_image_url': '', 'answer2_image_url': '', 'answer3_image_url': '', 'answer4_image_url': '', 'answer': answer.value, 'state': false })
    //         .catchError((error) {print('createQuestionSelect() : ${error}');});
    //
    //   }else {
    //     doc = await FirebaseFirestore.instance.collection('quiz_question')
    //         .add({'number': snapshot.docs.length+1, 'quiz_id': quiz_id, 'date': question_date, 'question': question.value, 'question_image_url': '', 'answer1': answer1.value, 'answer2': answer2.value, 'answer3': answer3.value,
    //       'answer4': answer4.value, 'answer1_image_url': '', 'answer2_image_url': '', 'answer3_image_url': '', 'answer4_image_url': '', 'answer': answer.value, 'state': false })
    //         .catchError((error) {print('createQuestionSelect() : ${error}');});
    //   }
    // });

    question_tex.value = '';
    answer1_tex.value = '';
    answer2_tex.value = '';
    answer3_tex.value = '';
    answer4_tex.value = '';
    question.value = '';
    answer1.value = '';
    answer2.value = '';
    answer3.value = '';
    answer4.value = '';
    answer.value = '';

    /// 이미지 처리
    if (imageInt8.value.length > 0 || imageInt8_answer1.value.length > 0 ||
        imageInt8_answer2.value.length > 0 ||
        imageInt8_answer3.value.length > 0 ||
        imageInt8_answer4.value.length > 0) {
      await imageToStorage(doc.id);
    }
  }

  // Future<void> createQuestionOx() async {
  //   question_date = DateTime.now();
  //   // DocumentReference doc = await FirebaseFirestore.instance.collection('quiz_question')
  //   //     .add({ 'quiz_id': quiz_id, 'date': question_date, 'question': question_tex.value, 'question_image_url': '', 'answer': answer })
  //   //     .catchError((error) { print('saveBoardMain() : ${error}'); });
  //   DocumentReference doc = await FirebaseFirestore.instance.collection('quiz_question').add({'quiz_id': quiz_id, 'date': question_date, 'question': question.value,
  //     'question_image_url': '', 'answer': answer}).catchError((error) {print('saveBoardMain() : ${error}');});
  //
  //   /// 이미지 처리
  //   String imageName = DateTime.now().toString();
  //   if (imageInt8.value.length > 0) {
  //     // await imageToStorage(imageName, imageInt8.value!, doc.id, 'main');
  //   }
  // }

  Future<void> updQuestionSelect() async {
    await FirebaseFirestore.instance.collection('quiz_question')
        .doc(question_id).update({'quiz_id': quiz_id, 'question': question.value, 'question_image_url': question_image_url, 'answer1': answer1.value, 'answer2': answer2.value,
      'answer3': answer3.value, 'answer4': answer4.value, 'answer1_image_url': answer1_image_url, 'answer2_image_url': answer2_image_url, 'answer3_image_url': answer3_image_url,
      'answer4_image_url': answer4_image_url, 'answer': answer.value}).catchError((error) {print('updQuestionSelect() : ${error}');});

    question_tex.value = '';
    answer1_tex.value = '';
    answer2_tex.value = '';
    answer3_tex.value = '';
    answer4_tex.value = '';
    question.value = '';
    answer1.value = '';
    answer2.value = '';
    answer3.value = '';
    answer4.value = '';
    answer.value = '';

    /// 이미지 처리
    if (imageInt8.value.length > 0 || imageInt8_answer1.value.length > 0 || imageInt8_answer2.value.length > 0 || imageInt8_answer3.value.length > 0 || imageInt8_answer4.value.length > 0) {
      await imageToStorage(question_id);
    }
  }

  void delQuiz() async {
    await FirebaseFirestore.instance.collection('quiz_main').doc(quiz_id).delete();

    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        /// 이미지 삭제
        List images = [doc['question_image_url'], doc['answer1_image_url'], doc['answer2_image_url'], doc['answer3_image_url'], doc['answer4_image_url']];
        for (int index = 0; index < images.length; index++) {
          if (images[index].length > 0) {
            var fileRef = FirebaseStorage.instance.refFromURL(images[index]);
            fileRef.delete();
          }
        }
        /// db 삭제
        doc.reference.delete();
      });
    });

  }

  void delQuestion(doc) async {
    List images = [doc['question_image_url'], doc['answer1_image_url'], doc['answer2_image_url'], doc['answer3_image_url'], doc['answer4_image_url']];
    for (int index = 0; index < images.length; index++) {
      if (images[index].length > 0) {
        var fileRef = FirebaseStorage.instance.refFromURL(images[index]);
        fileRef.delete();
      }
    }
    await FirebaseFirestore.instance.collection('quiz_question').doc(doc.id).delete();

    /// 번호 업데이트
    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        List docs = snapshot.docs.toList();
        docs.sort((a,b)=> a['date'].compareTo(b['date']));
        for (int index = 0; index < docs.length; index++) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(docs[index].id)
              .update({'number': index+1}).catchError((error) {print('updQuestionSelect() : ${error}');});
        }
      }
    });

    question_id = '';
    question.value = '';
    answer1.value = '';
    answer2.value = '';
    answer3.value = '';
    answer4.value = '';
    answer.value = '';
    imageInt8.value = Uint8List(0);
    imageInt8_answer1.value = Uint8List(0);
    imageInt8_answer2.value = Uint8List(0);
    imageInt8_answer3.value = Uint8List(0);
    imageInt8_answer4.value = Uint8List(0);
  }

  // Future<void> updActiveFirstQuestion(state) async{
  //
  //   updQuestionScore();
  //
  //   await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
  //     if (!snapshot.docs.isEmpty) {
  //       List docs = snapshot.docs.toList();
  //       /// sort 안하면 number가 1인 row가 제일 처음에 없으면 빨간화면 뜨고 넘어감
  //       docs.sort((a,b)=> a['number'].compareTo(b['number']));
  //       /// 처음 플레이시엔 마지막번호에 true가 남아있기에 그for문으로 false 만들고 시작
  //       for (int index = 0; index < snapshot.docs.length; index++) {
  //         if (docs[index]['number'] == 1) {
  //           await FirebaseFirestore.instance.collection('quiz_question').doc(docs[index].id).update({'state': state});
  //         }else {
  //           await FirebaseFirestore.instance.collection('quiz_question').doc(docs[index].id).update({'state': ''});
  //         }
  //
  //       }
  //     }
  //   });
  // }

  // Future<void> updActiveQuestion(number, state) async{
  //
  //   updQuestionScore();
  //
  //   await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).where('number', isEqualTo: number+1).get().then((QuerySnapshot snapshot) async {
  //     if (!snapshot.docs.isEmpty) {
  //       DocumentSnapshot doc = snapshot.docs.first;
  //       await FirebaseFirestore.instance.collection('quiz_question').doc(doc.id).update({'state': state});
  //     }
  //   });
  //
  // }

  // void updQuestionScore() async{
  //   int player_cnt = 0;
  //   if (is_real_name == true) {
  //     /// 전체 참가자 가져오기
  //     await FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //         .where('is_active', isEqualTo: true).get().then((QuerySnapshot snapshot) {
  //       player_cnt = snapshot.docs.length;
  //     });
  //   }
  //
  //   FirebaseFirestore.instance.collection('quiz_question_score').where('quiz_id', isEqualTo: quiz_id).where('question_number', isEqualTo: 1).get().then((QuerySnapshot snapshot) {
  //     if (!snapshot.docs.isEmpty) {
  //       FirebaseFirestore.instance.collection('quiz_question_score').doc(snapshot.docs.first.id).update({'player': player_cnt});
  //     }else {
  //       FirebaseFirestore.instance.collection('quiz_question_score').add({'quiz_id': quiz_id, 'date': DateTime.now(), 'question_number': 1, 'submitter': [], 'player': player_cnt });
  //     }
  //   });
  // }

  var score_doc;
  // int next_score_doc_number = 1;
  Future<void> updQuestionState(number, state) async{
    int player_cnt = 0;
    if (is_real_name == true) {
      /// 전체 참가자 가져오기
      await FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('is_active', isEqualTo: true).get().then((QuerySnapshot snapshot) {
        player_cnt = snapshot.docs.length;
      });
    }

    if (state == 'ready') {
      score_doc = await FirebaseFirestore.instance.collection('quiz_question_score').add({'class_code': GetStorage().read('class_code'),
        'quiz_id': quiz_id, 'date': DateTime.now(), 'question_number': number+1, 'submitter': [], 'player': player_cnt, 'state': 'ready' });
    }else if (state == 'active') {
      await FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc.id).update({'state': 'active'});
    }else {
      await FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc.id).update({'state': 'end'});
    }

  }

  int question_cnt = 0;
  void getQuestionCnt() async{
    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        question_cnt = snapshot.docs.length;
      }
    });
  }

  void delScore() async{
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code')).where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        List docs = snapshot.docs.toList();
        for (int index = 0; index < docs.length; index++) {
          await FirebaseFirestore.instance.collection('quiz_question_score').doc(docs[index].id).delete();
        }
      }
    });
  }

  // void clearAllActiveScore() async{
  //   await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code')).where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
  //     if (!snapshot.docs.isEmpty) {
  //       List docs = snapshot.docs.toList();
  //       for (int index = 0; index < snapshot.docs.length; index++) {
  //         await FirebaseFirestore.instance.collection('quiz_question_score').doc(docs[index].id).update({'state': ''});
  //       }
  //     }
  //   });
  // }

  /// 익명
  RxBool is_duplicate_name = false.obs;
  void saveAnonymous() async{
    await FirebaseFirestore.instance.collection('quiz_player_anonymous').where('class_code', isEqualTo: quiz_class_code)
        .where('quiz_id', isEqualTo: quiz_id).where('nickname', isEqualTo: nickname_input.trim()).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        is_duplicate_name.value = true;
      }else {
        await FirebaseFirestore.instance.collection('quiz_player_anonymous').add({'class_code': quiz_class_code, 'quiz_id': quiz_id, 'nickname': nickname_input.trim(), 'date': DateTime.now() });
        active_screen_mobile.value = 'ready';
        GetStorage().write('job', 'student'); /// 새로고침, 뒤로가기할때 사용
        is_duplicate_name.value = false;
      }
    });


  }

  /// 점수
  Future<void> updUserScore(select_answer, answer) async{
    Duration dif = DateTime.parse(end_date).difference(DateTime.parse(start_date));
    int score = 0;
    if (select_answer == answer) {
      score = 1;
    }

    if (is_real_name == true) {
      await FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc_id)
          .update({ 'submitter': FieldValue.arrayUnion([{'name': GetStorage().read('name'), 'time': dif.toString(), 'select_answer': select_answer}]) });
    }else {
      await FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc_id)
          .update({ 'submitter': FieldValue.arrayRemove([{'name': nickname_input, 'time': dif.toString(), 'select_answer': select_answer, 'score': score}]) });

      await FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc_id)
          .update({ 'submitter': FieldValue.arrayUnion([{'name': nickname_input, 'time': dif.toString(), 'select_answer': select_answer, 'score': score}]) });
    }

  }

  Map select_map = {};
  RxInt select_answer_1 = 0.obs;
  RxInt select_answer_2 = 0.obs;
  RxInt select_answer_3 = 0.obs;
  RxInt select_answer_4 = 0.obs;
  Future<void> cntSelectQuestion(number) async{
    select_map = {};
    select_answer_1.value = 0;
    select_answer_2.value = 0;
    select_answer_3.value = 0;
    select_answer_4.value = 0;
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).where('question_number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.first['submitter'].length > 0) {
        List<Map> list_map = [];
        for (int index = 0; index < snapshot.docs.first['submitter'].length; index++) {
          list_map.add(snapshot.docs.first['submitter'][index]);
        }
        select_map = groupBy(list_map, (Map obj) => obj['select_answer']).map(
                (k, v) => MapEntry(k, v.map((item) { item.remove('select_answer'); return item;}).toList().length));
        if (select_map['1'] != null) {
          select_answer_1.value = select_map['1'];
        }
        if (select_map['2'] != null) {
          select_answer_2.value = select_map['2'];
        }
        if (select_map['3'] != null) {
          select_answer_3.value = select_map['3'];
        }
        if (select_map['4'] != null) {
          select_answer_4.value = select_map['4'];
        }

      }
    });
  }

  /// 문제별 순위
  List score_question_list = [];
  Future<void> scoreQuestion(number, answer) async{
    score_question_list = [];
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).where('question_number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.first['submitter'].length > 0) {
        snapshot.docs.first['submitter'].forEach((data) {
          score_question_list.add({'name': data['name'], 'correct': answer == data['select_answer'] ? 'O' : 'X' , 'time': data['time'],});
        });

      }
    });

    /// 같은 이름은 삭제
    score_question_list.removeWhere((a) => a != score_question_list.firstWhere((b) => b['name'] == a['name'] ));

    /// 정렬
    score_question_list.sort((a, b) {
      int correctComp = a['correct'].compareTo(b['correct']);
      if (correctComp == 0) {
        return a['time'].compareTo(b['time']);
      }
      return correctComp;
    });
  }

  /// 전체 순위
  List total_list = [];
  Future<void> scoreTotal() async{
    total_list = [];
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        List<Map> list_map = [];
        snapshot.docs.forEach((doc) {

          // for (int index = 0; index < doc['submitter'].length; index++) {
          //   list_map.add(doc['submitter'][index]);
          // }

          /// 같은 이름은 삭제
          List remove_dupli_list = [];
          remove_dupli_list = doc['submitter'];
          remove_dupli_list.removeWhere((a) => a != remove_dupli_list.firstWhere((b) => b['name'] == a['name'] ));

          for (int index = 0; index < remove_dupli_list.length; index++) {
            list_map.add(doc['submitter'][index]);
          }

        });

        var total_map = groupBy(list_map, (Map obj) => obj['name']).map(
                (k, v) => MapEntry(k, v.map((item) { item.remove('name'); return item;}).toList()));

        total_map.forEach((key, value) {
          int? score = 0;
          int? score_sum = 0;
          // String? time = '';
          double time_sum = 0.0;
          for (int index = 0; index < value.length; index++) {
            score = value[index]['score'] as int;
            score_sum = (score! + score_sum!);
            time_sum = double.parse(value[index]['time'].substring(5,11))! + time_sum!;
          }
          total_list.add({'name': key, 'score': score_sum, 'time': time_sum,});
        });


      }
    });

    /// 정렬
    total_list.sort((a, b) {
      int scoreComp = b['score'].compareTo(a['score']);
      if (scoreComp == 0) {
        return a['time'].compareTo(b['time']);
      }
      return scoreComp;
    });

  }

  var rank_question_index = 0;
  var correct = '';
  var rank_tatal_index = 0;
  Future<void> scoreMobile() async{
    /// 나의 순위
    rank_question_index = score_question_list.indexWhere((e) => e['name'] == nickname_input);
    if (score_question_list.where((e) => e['name'] == nickname_input).length > 0) {
      correct = score_question_list.where((e) => e['name'] == nickname_input).first['correct'];
    }else {
      correct = 'X';
    }

    if (rank_question_index != -1) {
      rank_question_index = rank_question_index + 1;
    }
    rank_tatal_index = total_list.indexWhere((e) => e['name'] == nickname_input);
    if (rank_tatal_index != -1) {
      rank_tatal_index = rank_tatal_index + 1;
    }
  }


  /// 이미지 처리
  void selectImage(gubun) async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      if (gubun == '질문') {
        imageInt8.value = await result.files.first.bytes!;
      } else if (gubun == '답지1') {
        imageInt8_answer1.value = await result.files.first.bytes!;
      } else if (gubun == '답지2') {
        imageInt8_answer2.value = await result.files.first.bytes!;
      } else if (gubun == '답지3') {
        imageInt8_answer3.value = await result.files.first.bytes!;
      } else if (gubun == '답지4') {
        imageInt8_answer4.value = await result.files.first.bytes!;
      }

      //  변하는 상태값을 하나 더 안주면 이미지가 상태 반영이 안됨. 조건문이 있으면 바로 인식못하는것 같음
      // dummy.value  = dummy.value + 1;
    }
  }

  Future<void> imageToStorage(id) async {
    // Future<void> imageToStorage(String filename, Uint8List imageInt8, id, gubun) async{
    List images = [imageInt8.value, imageInt8_answer1.value, imageInt8_answer2.value, imageInt8_answer3.value, imageInt8_answer4.value];
    for (int index = 0; index < images.length; index++) {
      if (images[index].length > 0) {
        var filename = DateTime.now().toString();
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('quiz/${GetStorage().read('class_code')}').child('/$filename.jpg');
        final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg');
        var uploadTask;
        uploadTask = ref.putData(images[index], metadata);
        await uploadTask.whenComplete(() => null);
        String imageUrl = await ref.getDownloadURL();
        if (index == 0) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(id).update({ 'question_image_url': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        } else if (index == 1) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(id).update({ 'answer1_image_url': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        } else if (index == 2) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(id).update({ 'answer2_image_url': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        } else if (index == 3) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(id).update({ 'answer3_image_url': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        } else if (index == 4) {
          await FirebaseFirestore.instance.collection('quiz_question').doc(id).update({ 'answer4_image_url': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
        }

        imageInt8.value = Uint8List(0);
        imageInt8_answer1.value = Uint8List(0);
        imageInt8_answer2.value = Uint8List(0);
        imageInt8_answer3.value = Uint8List(0);
        imageInt8_answer4.value = Uint8List(0);
      }
    }
  }
}







