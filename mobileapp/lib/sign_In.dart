import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobileapp/config.dart';
import 'package:mobileapp/dashboard.dart';
import 'package:mobileapp/sign_Up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;
  String? myToken;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      print(reqBody['email']);
      print(reqBody['password']);

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      print(jsonResponse['status']);

      if (jsonResponse['status'] != null) {
        myToken = jsonResponse['token'];
        print("data type of myToken");
        print(myToken.runtimeType);
        print(myToken);
        prefs.setString('token', myToken!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              token: myToken,
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          _isNotValidate = true;
        });
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
              'Sign In',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * (0.8),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  errorStyle:
                      TextStyle(color: const Color.fromARGB(255, 19, 18, 18)),
                  errorText: _isNotValidate ? "Enter a valid Email?" : null,
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * (0.8),
              child: TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle:
                      TextStyle(color: const Color.fromARGB(255, 19, 18, 18)),
                  errorText: _isNotValidate ? "Enter a valid Password?" : null,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : const Text('Sign In'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Don't have an account?"),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const signUp()));
                },
                child: const Text("Sign Up"),
              ),
            ),
          ],
        ),
      )),
    )));
  }
}
