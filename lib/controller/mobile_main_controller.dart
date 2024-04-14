
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class MobileMainController extends GetxController {
  static MobileMainController get to => Get.find();
  RxInt bottomNaviCurrentIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

}