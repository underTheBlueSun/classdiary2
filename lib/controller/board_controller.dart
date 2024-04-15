// import 'dart:ffi';
import 'dart:typed_data';

import 'package:classdiary2/board_modum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../auction/auction_main.dart';
import '../board_indi.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
// import 'dart:html' as html;
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../board_main.dart';
import 'attendance_controller.dart';

class ImageModel {
  File? pickedImage;
  File?  thumbnailFile;
  Uint8List? imageInt8;
}

class BoardController extends GetxController {
  static BoardController get to => Get.find();

  // String classCode = '';
  RxList stamps = [].obs;
  RxList stamp_file_names = ['stamp1','stamp2','stamp3','stamp4','stamp5','stamp6',].obs;
  RxString selected_stamp = 'stamp1'.obs;
  RxString stampDate = DateTime.now().toString().obs;
  RxString selectedStamp = 'stamp1.png'.obs;
  RxBool isHoverMainAddBtn = false.obs;
  RxBool isHoverAlignBtn = false.obs; // 정렬
  RxBool isHoverBoardListBtn = false.obs;  // 년도별 목록
  RxBool isHoverBoardMainSaveBtn = false.obs;  // 보드메인 저장버튼
  RxBool isHoverBoardIndiSaveBtn = false.obs;  // 보드개인 저장버튼
  RxBool isHoverCommentSaveBtn = false.obs;  // 보드개인 저장버튼
  RxBool isHover = false.obs;  // 테스트용
  // RxBool isHoverHome = false.obs;  // 홈
  // RxBool isHoverDate = false.obs;  // 날짜순 정렬
  // RxBool isHoverTitle = false.obs;  // 제목순 정렬
  // RxBool isHoverYear = false.obs;  // 이전년도
  RxBool isHoverStampAll = false.obs;  // 전체찍기
  RxInt isHoverStampImgIndex = 0.obs;
  RxBool isHoverSetting = false.obs;  // 설정
  RxBool isHoverModum = false.obs;  // 모둠추가

  RxList comments = [].obs; // comment, 댓글
  RxString board_type = '개인'.obs; // 보드추가시 출석부형, 모둠형 선택
  // RxInt board_bgcolor = 0xff2B2B2B.obs;
  // RxString boardBgImage = 'bg01'.obs;
  RxString background = 'bg01'.obs;
  String mainTitleInput = '';
  String mainContentInput = '';
  String schoolYear = '';
  String indiTitleInput = '';
  String indiContent = '';
  String indiCommentInput = '';
  String popCloseType = 'nosave';
  RxBool isImageLoading = false.obs;
  RxInt modumIndex = 0.obs; /// boardModum에서 이미지로딩시 식별하기위해, 이거 안하면 같은 번호 모두 로딩이미지 보여짐
  RxDouble board_full_screen_text_size = 40.0.obs;
  ///
  // RxString active_screen = 'board_main'.obs;
  // String selected_main_title = '';
  /// 설명보기, 경매에서 다이얼로그 띄우고 댓글 달면 뒷화면에서 argument main_id를 못가져와서 수정
  var selected_main_id;
  // String selected_background = '';
  // String selected_content = '';
  // String selected_id = '';

  /// 폰의 bottom sheet가 argument를 받지못해서, 데스크탑에선 귀찮아서 그냥 argument 받음
  /// 폰에서 이미지를 추가하면 회색 먹통이 되어서 다시 원복함. ㅠㅠ
  // var mainId;

  // RxBool loading = false.obs;

  /// 경매
  int coin = 100;
  RxBool isVisibleContent = false.obs;
  RxInt estimate1 = 0.obs;
  RxInt estimate2 = 0.obs;
  RxInt estimate3 = 0.obs;
  RxInt estimate4 = 0.obs;
  // List estimates = ['준비한 자료와 발표내용이 알찬가?', '내용전달이 알아 듣기 쉬운가?', '바른 자세로 발표를 잘 하였는가?', '구매욕구를 자극하는가?'];

  /// 퇴장시, 추가,수정,삭제시 보드, 경매 분기할때 필요
  String param_gubun = '';


  List<Color> kDefaultRainbowColors =  [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple,];

  /// 이미지 처리
  Rx<ImageModel> imageModel = ImageModel().obs;
  RxInt dummy = 0.obs;

  RxString nowdate = ''.obs;

  RxBool isRepeatToggle = true.obs;
  RxString mainAlignment = 'd_dsc'.obs;

  double sizeKbs = 0;
  final int maxSizeKbs = 1024;
  var size = 0;

  int modumLastNumber = 6; // 모둠추가시 필요


  @override
  void onInit() async {

    // 학년도 가져오기
    schoolYear = DateTime.now().toString().substring(0,4);
    if (DateTime.now().month == 1 || DateTime.now().month == 2) {
      schoolYear = (DateTime.now().year-1).toString();
    }

    /// signup_controller의 regNewUser()와 setUser()쪽으로 옮겨야 한다
    // setClassCode();

    if (GetStorage().read('stamp') != null) {
      selected_stamp.value = GetStorage().read('stamp');
    }


  }

  void saveBoardMain(gubun) async{
    var mainId = DateTime.now();

    DocumentReference doc;
    if (board_type.value == '개인') {
      doc = await FirebaseFirestore.instance.collection('board_main')
          .add({ 'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'), 'title': mainTitleInput, 'background': background.value,
        'main_id': mainId, 'school_year' : schoolYear, 'type' : board_type.value, 'content' : mainContentInput, 'isAcceptComment': true, 'gubun': gubun })
          .catchError((error) { print('saveBoardMain() : ${error}'); });

      Get.off(() => BoardIndi(), arguments: {'title' : mainTitleInput, 'main_id' : mainId, 'background': background.value,
        'content': mainContentInput, 'id': doc.id, 'gubun': gubun });
      /// 설명보기, 경매에서 다이얼로그 띄우고 댓글 달면 뒷화면에서 argument main_id를 못가져와서 수정
      selected_main_id = mainId;
    }else {
      doc = await FirebaseFirestore.instance.collection('board_main')
          .add({ 'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'), 'title': mainTitleInput, 'background': background.value,
        'main_id': mainId, 'school_year' : schoolYear, 'type' : board_type.value, 'content' : mainContentInput,
        'modums' : [{'number': 1, 'name': '1모둠'}, {'number': 2, 'name': '2모둠'}, {'number': 3, 'name': '3모둠'}, {'number': 4, 'name': '4모둠'},
          {'number': 5, 'name': '5모둠'}, {'number': 6, 'name': '6모둠'}], 'isAcceptComment': true, 'gubun': gubun })
          .catchError((error) { print('saveBoardMain() : ${error}'); });

      Get.off(() => BoardModum(), arguments: {'title' : mainTitleInput, 'main_id' : mainId, 'background': background.value, 'content': mainContentInput,
        'id': doc.id, 'modums': [{'number': 1, 'name': '1모둠'}, {'number': 2, 'name': '2모둠'}, {'number': 3, 'name': '3모둠'},
          {'number': 4, 'name': '4모둠'}, {'number': 5, 'name': '5모둠'}, {'number': 6, 'name': '6모둠'}], 'gubun': gubun });
    }

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      await imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'main');
    }

  }

  Future<void> saveBoardIndi(mainId, number) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('board_indi')
        .add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'), 'school_year': schoolYear, 'main_id': mainId, 'number': number, 'title': indiTitleInput,
      'content': indiContent, 'comment' : [], 'imageUrl' : '', 'thumbUrl' : '', 'like' : [], 'stamp' : '' })
        .catchError((error) { print('saveBoardIndi() : ${error}'); });

    /// 이미지 처리
    String imageName = DateTime.now().toString();

    if (imageModel.value.imageInt8 != null) {
      popCloseType = 'save';
      /// 이미지로딩중
      isImageLoading.value = true;
      await imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'indi');
    }

    indiTitleInput = '';
    indiContent = '';

  }

  Future<void> saveBoardModum(mainId, modum_number) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('board_modum')
        .add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'), 'school_year': schoolYear, 'main_id': mainId,
      'modum_number' : modum_number, 'stu_number': GetStorage().read('number'), 'stu_name': GetStorage().read('name'), 'title': indiTitleInput,
      'content': indiContent, 'comment' : [], 'imageUrl' : '', 'thumbUrl' : '', 'like' : [], 'stamp' : '' })
        .catchError((error) { print('saveBoardModum() : ${error}'); });

    /// 이미지 처리
    String imageName = DateTime.now().toString();

    if (imageModel.value.imageInt8 != null) {
      popCloseType = 'save';
      /// 이미지로딩중
      isImageLoading.value = true;
      await imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'modum');
    }

    /// indiTitleInput: indi 이름 고치기 귀찮아서 그냥 놔둠
    indiTitleInput = '';
    indiContent = '';

  }

  void selectImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      // final fileName = result.files.first.name;
      imageModel.value.imageInt8 = await result.files.first.bytes;
      //  변하는 상태값을 하나 더 안주면 이미지가 상태 반영이 안됨. 조건문이 있으면 바로 인식못하는것 같음
      dummy.value  = dummy.value + 1;

      /// 파일 사이즈 확인
      size = result.files.first.size;
      sizeKbs = size/1024;
    }

  }

  /// 파이어베이스 스토리지에 저장
  Future<void> imageToStorage(String filename, Uint8List imageInt8, id, gubun) async{
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref()
        .child('board/${GetStorage().read('class_code')}')
        .child('/$filename.jpg');
    final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg');

    var uploadTask;

    uploadTask = ref.putData(imageInt8, metadata);

    await uploadTask.whenComplete(() => null);
    String imageUrl = await ref.getDownloadURL();
    // if (gubun == 'main') {
    //   await FirebaseFirestore.instance.collection('board_main').doc(id).update({ 'imageUrl': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
    // }else if(gubun == 'indi') {
    //   await FirebaseFirestore.instance.collection('board_indi').doc(id).update({ 'imageUrl': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
    // }else{
    //   await FirebaseFirestore.instance.collection('board_modum').doc(id).update({ 'imageUrl': imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
    // }
    imageModel.value.imageInt8 = null;


    Future.delayed(const Duration(milliseconds: 4000), () async{
      final desertRef = FirebaseStorage.instance.ref('board/${GetStorage().read('class_code')}/$filename.jpg');
      await desertRef.delete();
      List imageUrls = imageUrl.split('.jpg');
      String new_imageUrl = imageUrls[0] + '_2000x2000.jpg' + imageUrls[1];
      if (gubun == 'main') {
        await FirebaseFirestore.instance.collection('board_main').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }else if(gubun == 'indi') {
        await FirebaseFirestore.instance.collection('board_indi').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }else {
        await FirebaseFirestore.instance.collection('board_modum').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }
      isImageLoading.value = false;
    });



  }

  void delImage(id, imageUrl, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id).update({ 'imageUrl': '' });

    var fileRef = FirebaseStorage.instance.refFromURL(imageUrl);
    fileRef.delete();

  }

  Future<void> updBoardMain(id) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'title': mainTitleInput, 'content': mainContentInput, 'image': '', 'background': background.value });

    Get.off(() => BoardMain());

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      imageToStorage(imageName, imageModel.value.imageInt8!, id, 'main');
    }
  }

  Future<void> updAuctionMain(id) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'title': mainTitleInput, 'content': mainContentInput, 'image': '', 'background': background.value });

    Get.off(() => AuctionMain());

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      imageToStorage(imageName, imageModel.value.imageInt8!, id, 'main');
    }
  }

  Future<void> updBoardIndi(doc) async{
    await FirebaseFirestore.instance.collection('board_indi').doc(doc.id)
        .update({ 'title': indiTitleInput, 'content': indiContent});

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      /// 이미지로딩중
      isImageLoading.value = true;
      imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'indi');
    }

    indiTitleInput = '';
    indiContent = '';
  }

  Future<void> updBoardModum(doc) async{
    await FirebaseFirestore.instance.collection('board_modum').doc(doc.id)
        .update({ 'title': indiTitleInput, 'content': indiContent});

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      /// 이미지로딩중
      isImageLoading.value = true;
      imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'modum');
    }

    indiTitleInput = '';
    indiContent = '';
  }

  void delBoardMain(main_doc_id, main_id, gubun) async{
    FirebaseFirestore.instance.collection('board_main').doc(main_doc_id).delete();

    if (gubun == 'indi') {
      await FirebaseFirestore.instance.collection('board_indi').where('main_id', isEqualTo: main_id).get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
          if (doc['imageUrl'].length > 0) {
            /// 이미지 삭제
            var fileRef = FirebaseStorage.instance.refFromURL(doc['imageUrl']);
            fileRef.delete();
          }

        });
      });
    }else{
      await FirebaseFirestore.instance.collection('board_modum').where('main_id', isEqualTo: main_id).get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
          if (doc['imageUrl'].length > 0) {
            /// 이미지 삭제
            var fileRef = FirebaseStorage.instance.refFromURL(doc['imageUrl']);
            fileRef.delete();
          }

        });
      });
    }

    Get.off(() => BoardMain());

  }

  void delBoardIndi(doc) async{
    FirebaseFirestore.instance.collection('board_indi').doc(doc.id).delete();
  }

  void delBoardModum(doc) async{
    FirebaseFirestore.instance.collection('board_modum').doc(doc.id).delete();
  }

  void saveComment(doc,value, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(doc.id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': DateTime.now(), 'name': GetStorage().read('name'), 'comment': value}]) });
  }

  Future<void> updComment(id,commment, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id)
        .update({ 'comment': FieldValue.arrayRemove([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': commment['comment']}]) });

    await FirebaseFirestore.instance.collection(gubun).doc(id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': indiCommentInput}]) });
  }

  Future<void> delComment(id,commment, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id)
        .update({ 'comment': FieldValue.arrayRemove([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': commment['comment']}]) });
  }

  void addLike(id,number, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id)
        .update({ 'like': FieldValue.arrayUnion([number]) });
  }

  void delLike(id, number, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id)
        .update({ 'like': FieldValue.arrayRemove([number]) });

  }

  void addStamp(id, gubun) async{
    if (GetStorage().read('stamp') == null) {
      GetStorage().write('stamp', 'stamp1');
    }
    await FirebaseFirestore.instance.collection(gubun).doc(id).update({ 'stamp': GetStorage().read('stamp') });
    // await FirebaseFirestore.instance.collection(gubun).doc(id).update({ 'stamp': selectedStamp.value });

  }

  void addAllStamp(mainId, gubun) async{
    if (GetStorage().read('stamp') == null) {
      GetStorage().write('stamp', 'stamp1');
    }

    if (gubun == 'indi') {
      await FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_indi').doc(doc.id).update({ 'stamp': GetStorage().read('stamp') });
            // FirebaseFirestore.instance.collection('board_indi').doc(doc.id).update({ 'stamp': selectedStamp.value });
          }
        }
      });
    }else{
      await FirebaseFirestore.instance.collection('board_modum').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_modum').doc(doc.id).update({ 'stamp': GetStorage().read('stamp') });
            // FirebaseFirestore.instance.collection('board_modum').doc(doc.id).update({ 'stamp': selectedStamp.value });
          }
        }
      });
    }

  }

  void delAllStamp(mainId, gubun) async{
    if (gubun == 'indi') {
      await FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_indi').doc(doc.id).update({ 'stamp': '' });
          }

        }
      });
    }else {
      await FirebaseFirestore.instance.collection('board_modum').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_modum').doc(doc.id).update({ 'stamp': '' });
          }

        }
      });
    }

  }

  void delStamp(id, gubun) async{
    if (gubun == 'board_indi') {
      await FirebaseFirestore.instance.collection('board_indi').doc(id).update({ 'stamp': '' });
    }else {
      await FirebaseFirestore.instance.collection('board_modum').doc(id).update({ 'stamp': '' });
    }

  }

  String modumName = '';
  void updModumName(id,modum) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'modums': FieldValue.arrayRemove([{'number': modum['number'], 'name': modum['name']}]) });

    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'modums': FieldValue.arrayUnion([{'number': modum['number'], 'name': modumName}]) });

    modumName = '';
  }

  void addModum(id) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'modums': FieldValue.arrayUnion([{'number': modumLastNumber+1, 'name': (modumLastNumber+1).toString()+'모둠'}]) });
  }

  void delModum(id, modum) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'modums': FieldValue.arrayRemove([{'number': modum['number'], 'name': modum['name']}]) });
  }

  void updAcceptComment(id) async{
    await FirebaseFirestore.instance.collection('board_main').doc(id)
        .update({ 'isAcceptComment': isRepeatToggle.value});
  }

  /// 경매
  void saveAuction(number, name, coin, title, image_url) async{

    // FirebaseFirestore.instance.collection('board_main').doc(main_doc_id).delete();

    await FirebaseFirestore.instance.collection('auction_coin').where('main_id', isEqualTo: selected_main_id).where('number', isEqualTo: number).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    DocumentReference doc;
    doc = await FirebaseFirestore.instance.collection('auction_coin')
        .add({ 'main_id' : selected_main_id, 'date': DateTime.now().toString(), 'number' : number, 'name' : name, 'coin' : int.parse(coin), 'title' : title, 'image_url' : image_url })
        .catchError((error) { print('saveAuction() : ${error}'); });
  }

  void saveEstimateList() async{
    await FirebaseFirestore.instance.collection('auction_estimate').where('main_id', isEqualTo: selected_main_id).get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.length == 0) {
            AttendanceController.to.attendanceDocs.forEach((doc) {
              FirebaseFirestore.instance.collection('auction_estimate')
                  .add({ 'main_id' : selected_main_id, 'date': DateTime.now().toString(), 'number' : doc['number'], 'name' : doc['name'], 'estimaters' : [],
                'estimate1' : 0, 'estimate2' : 0, 'estimate3' : 0, 'estimate4' : 0});
            });
          }
    });

  }

  void updEstimate(number, name) async{
    await FirebaseFirestore.instance.collection('auction_estimate').where('main_id', isEqualTo: selected_main_id).where('number', isEqualTo: number).get()
        .then((QuerySnapshot querySnapshot) {
          FirebaseFirestore.instance.collection('auction_estimate').doc(querySnapshot.docs.first.id)
          .update({ 'estimate1': FieldValue.increment(estimate1.value), 'estimate2': FieldValue.increment(estimate2.value), 'estimate3': FieldValue.increment(estimate3.value),
            'estimate4': FieldValue.increment(estimate4.value), 'estimaters': FieldValue.arrayUnion([GetStorage().read('number')]) });
          // .update({ 'estimate1': FieldValue.arrayUnion([{'date': DateTime.now(), 'name': GetStorage().read('name'), 'comment': value}]) });
    });


    // await FirebaseFirestore.instance.collection('auction_estimate').where('main_id', isEqualTo: selected_main_id).where('number', isEqualTo: number).get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     doc.reference.delete();
    //   });
    // });

    // DocumentReference doc;
    // doc = await FirebaseFirestore.instance.collection('auction_estimate')
    //     .add({ 'main_id' : selected_main_id, 'date': DateTime.now().toString(), 'number' : number, 'name' : name, 'name2' : GetStorage().read('name'),
    //   'estimate1' : estimate1.value, 'estimate2' : estimate2.value, 'estimate3' : estimate3.value, 'estimate4' : estimate4.value,})
    //     .catchError((error) { print('saveEstimate() : ${error}'); });

    estimate1.value = 0;
    estimate2.value = 0;
    estimate3.value = 0;
    estimate4.value = 0;
  }



}






