import 'package:exercise_getx/controller/RegisterController.dart';
import 'package:exercise_getx/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'ProfilePage.dart';
import '../utils.dart';
import 'package:exercise_getx/validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  final RegisterController controller = Get.put(RegisterController());

  late TextEditingController usernameCtr;
  late TextEditingController nameCtr;
  late TextEditingController emailCtr;
  late TextEditingController phoneCtr;
  late TextEditingController addressCtr;
  late TextEditingController passwordCtr;

  @override
  void initState() {
    super.initState();
    usernameCtr = TextEditingController();
    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    addressCtr = TextEditingController();
    passwordCtr = TextEditingController();
  }

  void _selectImage()async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void submitRegistration(Uint8List? image) {
    if (_image == null) {
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
                    passwordCtr.text,
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
    } else {
      controller.updateUserProfile(
        usernameCtr.text,
        nameCtr.text,
        emailCtr.text,
        phoneCtr.text,
        addressCtr.text,
        passwordCtr.text,
        _image, // Meneruskan gambar ke metode updateUserProfile
      );
      Get.to(() => ProfilePage(image: _image)); // Meneruskan gambar ke halaman profil
    }
  }

  Widget myText({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text, // Set default keyboardType to text
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,// Add optional inputFormatters parameter
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType, // Use the provided keyboardType
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        validator: validator, // Set the validator function
        autovalidateMode: AutovalidateMode.onUserInteraction, // Enable auto-validation on user interaction
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            myText(label: "Username", controller: usernameCtr,icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return null; // Return null for valid input
              },),
            myText(label: "Name", controller: nameCtr,icon: Icons.perm_identity_outlined,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return null; // Return null for valid input
              },),
            myText(
              label: "Password", controller: passwordCtr,icon: Icons.lock,obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty)
                return null; // Return null for valid input
              },
            ),
            myText(
              label: "Phone",
              controller: phoneCtr,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                } else if (value.length != 10) {
                  return 'Phone number must have 10 digits';
                }
                // Add more validation logic here if needed
                return null; // Return null for valid input
              },
            ),
            myText(
              label: "Email",
              controller: emailCtr,
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!EmailValidator.isValidEmail(value)) { // Use EmailValidator here
                  return 'Invalid email format';
                }
                return null; // Return null for valid input
              },
            ),
            myText(label: "Address", controller: addressCtr,icon: Icons.home,),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, proceed with registration
                  submitRegistration(_image);
                }
              },
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
