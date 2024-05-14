import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}):super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}