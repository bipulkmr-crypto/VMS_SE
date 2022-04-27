import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: 120,
        child: Image.asset("assets/logo.jpg", fit: BoxFit.contain),
      ),
      const Text(
        "Visitor Management System",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}

class BottomBanner extends StatelessWidget {
  final String name, role;

  const BottomBanner({required this.name, required this.role, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(
        height: 10,
      ),
      Text(
        "Welcome $name",
        style: const TextStyle(fontSize: 15),
      ),
      Text(
        "You are logged in as $role",
        style: const TextStyle(fontSize: 15),
      ),
    ]);
  }
}
