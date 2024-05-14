import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobileapp/dashboard.dart';
import 'package:mobileapp/sign_In.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs;
  String? token;

  try {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  } catch (e) {
    // Handle error when retrieving token
    print('Error retrieving token: $e');
  }

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: signIn(),
      // (token != null && !JwtDecoder.isExpired(token!))
      //     ? Dashboard(token: token!)
      //     : signIn(),
    );
  }
}
