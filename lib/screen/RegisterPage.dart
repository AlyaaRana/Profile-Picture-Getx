import 'package:exercise_getx/controller/RegisterController.dart';
import 'package:exercise_getx/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'ProfilePage.dart';
import '../utils.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Uint8List? _image;
  final RegisterController controller = Get.put(RegisterController());

  late TextEditingController usernameCtr;
  late TextEditingController nameCtr;
  late TextEditingController emailCtr;
  late TextEditingController phoneCtr;
  late TextEditingController addressCtr;

  @override
  void initState() {
    super.initState();
    usernameCtr = TextEditingController();
    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    addressCtr = TextEditingController();
  }

  void _selectImage()async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void submitRegistration(Uint8List? image) {
    if (_image == null) {
      // Jika gambar tidak diisi, tampilkan dialog peringatan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Peringatan"),
            content: Text("Anda belum mengisi gambar. Apakah Anda ingin melanjutkan tanpa gambar?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  controller.updateUserProfile(
                    usernameCtr.text,
                    nameCtr.text,
                    emailCtr.text,
                    phoneCtr.text,
                    addressCtr.text,
                    _image, // Meneruskan gambar ke metode updateUserProfile
                  );
                  Get.to(() => ProfilePage(image: _image)); // Meneruskan gambar ke halaman profil
                },
                child: Text("OK (Skip)"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text("Tambah Gambar"),
              ),
            ],
          );
        },
      );
    } else if (usernameCtr.text.isEmpty || nameCtr.text.isEmpty || emailCtr.text.isEmpty || phoneCtr.text.isEmpty || addressCtr.text.isEmpty) {
      // Jika ada field teks yang tidak diisi, tampilkan dialog peringatan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Peringatan"),
            content: Text("Silakan isi semua field teks sebelum melanjutkan."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Semua field telah diisi, lanjutkan ke halaman profil
      controller.updateUserProfile(
        usernameCtr.text,
        nameCtr.text,
        emailCtr.text,
        phoneCtr.text,
        addressCtr.text,
        _image, // Meneruskan gambar ke metode updateUserProfile
      );
      Get.to(() => ProfilePage(image: _image)); // Meneruskan gambar ke halaman profil
    }
  }



  Widget myText({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Ubah padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text("Create account, please!!",
            //     style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold)
            // ),
            SizedBox(height: 10,),
            Stack(
              children: [
                _image != null?
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    ):
                CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(''),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                  bottom: -10,
                  left: 80,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            myText(label: "Username", controller: usernameCtr),
            myText(label: "Name", controller: nameCtr),
            myText(label: "Phone", controller: phoneCtr),
            myText(label: "Email", controller: emailCtr),
            myText(label: "Address", controller: addressCtr),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () => submitRegistration(_image),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              ),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
