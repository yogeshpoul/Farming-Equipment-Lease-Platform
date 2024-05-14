import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/config.dart';
import 'package:mobileapp/sign_In.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isNotValidate = false;
  bool isLoading = false;

  io.File? selectedImage;

  late String img64;
  String? base64String;

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = io.File(returnedImage!.path);

      // final bytes = io.File(returnedImage.path).readAsBytesSync();
      // img64 = base64Encode(bytes);
    });

    Uint8List imageData = await readImageFile(selectedImage!.path);
    Uint8List compressedImageData = await compressImage(imageData, 30);
    base64String = imageToBase64(compressedImageData);

    // image controller
    print(selectedImage);
    print(base64String);
    print("byte printed");
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = io.File(returnedImage!.path);
    });

    // image controller
    print(selectedImage);
    //
  }

  Future<Uint8List> readImageFile(String filePath) async {
    io.File imageFile = io.File(filePath);
    return await imageFile.readAsBytes();
  }

  Future<Uint8List> compressImage(Uint8List imageData, int quality) async {
    List<int> compressedData = await FlutterImageCompress.compressWithList(
      imageData,
      quality: quality,
    );
    return Uint8List.fromList(compressedData);
  }

  // Function to convert image to base64 string
  String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var regBody = {
        "userImage": base64String,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => signIn()));
      } else {
        print("Something went wrong!!!");
        isLoading = false;
      }
    } else {
      setState(() {
        _isNotValidate = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: [Colors.blue, Colors.white])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // displaying the selected image
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 18, 128, 217),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 60,
                          child: selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Color.fromARGB(255, 73, 72, 72),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Color.fromARGB(255, 18, 128, 217),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_search_rounded,
                                  size: 30,
                                ),
                                // SizedBox(width: 4),
                                // Text('Choose from gallery'),
                              ],
                            ),
                            onPressed: () {
                              pickImageFromGallery();
                            },
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          MaterialButton(
                            color: Colors.amber,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                // SizedBox(width: 4),
                              ],
                            ),
                            onPressed: () {
                              pickImageFromCamera();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'First Name',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Last Name',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(
                                color: const Color.fromARGB(255, 19, 18, 18)),
                            errorText: _isNotValidate
                                ? "Enter a valid Email address"
                                : null,
                            hintText: 'Email',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(
                                color: const Color.fromARGB(255, 19, 18, 18)),
                            errorText: _isNotValidate
                                ? "Enter a valid Password"
                                : null,
                            hintText: 'Password',
                            isCollapsed:
                                true, // Reduces the height of the input field
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : registerUser,
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Text('Sign In'),
                        )),
                    const SizedBox(
                      height: 7,
                    ),
                    Text("Already have an account?"),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signIn()));
                        },
                        child: Text('Sign In'),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
