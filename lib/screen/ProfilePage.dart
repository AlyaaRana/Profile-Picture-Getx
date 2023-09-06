import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exercise_getx/controller/RegisterController.dart';

class ProfilePage extends StatelessWidget {
  final RegisterController controller = Get.find();
  final Uint8List? image;

  ProfilePage({required this.image});

  Widget _buildInfoBox(String label, String value) {
    return Container(
      height: 40,
      width: 400,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 19),
            image != null
                ? CircleAvatar(
              radius: 64,
              backgroundImage: MemoryImage(image!),
            )
                : CircleAvatar(
              radius: 64,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              controller.username.value, // Display the username here
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 35),
            _buildInfoBox("Name:", controller.name.value),
            _buildInfoBox("Email:", controller.email.value),
            _buildInfoBox("Phone:", controller.phone.value),
            _buildInfoBox("Address:", controller.address.value),
          ],
        ),
      ),
    );
  }
}
