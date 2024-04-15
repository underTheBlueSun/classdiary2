
// import 'dart:html';

import 'package:classdiary2/mobile/estimate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class EstiController extends GetxController {
  static EstiController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  RxString selectedDate = DateTime.now().toString().obs;
  RxString title = ''.obs;
  RxInt highCnt = 0.obs;
  RxInt middleCnt = 0.obs;
  RxInt lowCnt = 0.obs;
  RxString whereToGo = 'Estimate'.obs;  //  디테일화면을 팝업에 띄우지 않고 바로 띄우기 위해
  String id = ''; //  디테일화면으로 넘길때 필요
  String folderid = '';
  RxString folderTitle = ''.obs;
  String whoCall = '';  //  디테일화면에서 이전 클릭하면 estimate로 갈건지 estimatefoler로 갈건지
  RxList<String> chartSelections1 = <String>[].obs; //  상중하
  RxList<String> chartSelections2 = <String>[].obs; //  점수
  RxBool isChart = false.obs;
  RxString esti = 'tripple'.obs;  //  상중하, 점수
  // String tripple = '';

  @override
  void onInit() async {
    super.onInit();
  }

  /// 상중하
  void saveEsti(gubun) async{
    var nowYMD = DateTime.now().toString().substring(0,10);
    if (gubun == '폴더파일') {
      await FirebaseFirestore.instance.collection('estimate')
          .add({ 'email': GetStorage().read('email'), 'title': title.value, 'folderID': folderid, 'folderTitle': folderTitle.value, 'numMap': {}, 'gubun' : gubun, 'date': nowYMD, 'esti': esti.value })
          .catchError((error) { print('saveEsti(폴더파일): ${error}'); });
    }else {
      await FirebaseFirestore.instance.collection('estimate')
          .add({ 'email': GetStorage().read('email'), 'title': title.value, 'folderID': '', 'folderTitle': '', 'numMap': {}, 'gubun' : gubun, 'date': nowYMD, 'esti': esti.value })
          .catchError((error) { print('saveEsti(폴더또는파일): ${error}'); });
    }
  }
  /// map 샘플
  // Map<String, Object> deleteSong = new HashMap<>();
  // deleteSong.put("songList.songName3", FieldValue.delete());
  // FirebaseFirestore.getInstance().collection("yourCollection").document("yourDocument").update(deleteSong);

  // imgRef.update({"images": FieldValue.arrayRemove(doc.data().images[position])});

  // favorites: { food: "Pizza", color: "Blue", subject: "recess" },age: 12}
  // db.collection("users").doc("frank").update({"favorites.size": "large"})

  void updNumMapTripple(number, tripple) async{
    if (tripple == '상') {
      await FirebaseFirestore.instance.collection('estimate').doc(id)
          .update({ 'numMap.${number}': '중' }).catchError((error) { print('updNumMapTripple(): ${error}'); });

    }else if (tripple == '중') {
      await FirebaseFirestore.instance.collection('estimate').doc(id)
          .update({ 'numMap.${number}': '하' }).catchError((error) { print('updNumMapTripple(): ${error}'); });
    }else if (tripple == '하') {
      await FirebaseFirestore.instance.collection('estimate').doc(id)
          .update({ 'numMap.${number}': FieldValue.delete() }).catchError((error) { print('updNumMapTripple(): ${error}'); });
    } else {
      await FirebaseFirestore.instance.collection('estimate').doc(id)
          .update({ 'numMap.${number}': '상' }).catchError((error) { print('updNumMapTripple(): ${error}'); });
    }
  }

  void updNumMapScore(number, value) async{
    await FirebaseFirestore.instance.collection('estimate').doc(id)
        .update({ 'numMap.${number}': value }).catchError((error) { print('updNumMapScore(): ${error}'); });
  }

  void updDate() async{
    await FirebaseFirestore.instance.collection('estimate').doc(id)
        .update({ 'date': selectedDate.substring(0,10) }).catchError((error) { print('updDate(): ${error}'); });
  }

  // void getEstiCnt(doc) async{
  //   highCnt.value = doc['numMap'].length;
  // }

  void delEstimate(gubun) async {
    /// 모바일, 웹 분기
    if (GetStorage().read('isMobile')) {
      Get.to(() => Estimate());
    }else {
      EstiController.to.whereToGo.value = 'Estimate'; //  이걸 삭제 뒤에 적으면 삭제하면서 실행되어 삭제는 되지만 화면에서 에러 뿌려줌
    }

    if (gubun == '폴더') {
      await FirebaseFirestore.instance.collection('estimate').where('folderID', isEqualTo: folderid).get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      await FirebaseFirestore.instance.collection('estimate').doc(id).delete();
    }else {
      await FirebaseFirestore.instance.collection('estimate').doc(id).delete();
    }
  }

  void updTitle() async{
    await FirebaseFirestore.instance.collection('estimate').doc(id)
        .update({ 'title': title.value }).catchError((error) { print('updTitle(): ${error}'); });
  }

  void updFolderTitle() async{
    await FirebaseFirestore.instance.collection('estimate').doc(folderid)
        .update({ 'title': folderTitle.value, 'folderTitle': folderTitle.value }).catchError((error) { print(error); });

    await FirebaseFirestore.instance.collection('estimate').where('folderID', isEqualTo: folderid).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('estimate').doc(doc.id).update({ 'folderTitle': folderTitle.value });
      });
    });
  }

} // MainController