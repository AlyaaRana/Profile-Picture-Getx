import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final resultData = RxString("initial");
  // final RxString imagePath = RxString("");
  final RxString username = RxString("");
  final RxString name = RxString("");
  final RxString phone = RxString("");
  final RxString address = RxString("");
  final RxString email = RxString("");

  void resultRegister(
      String username,
      String name,
      String email,
      String phone,
      String address,
      // String imagePath,
      ) {
    resultData.value = "Registration successful";
    print("U'r Profile Page " + resultData.value.toString());
  }

  void updateUserProfile(
      String username,
      String name,
      String email,
      String phone,
      String address,
      Uint8List? image,
      ) {
    this.username.value = username;
    this.name.value = name;
    this.email.value = email;
    this.phone.value = phone;
    this.address.value = address;
  }
}
