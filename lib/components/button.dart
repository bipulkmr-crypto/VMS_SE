import 'package:flutter/material.dart';

Widget makeButton(String text,void Function() onPress) {
  return  Padding(
      padding: const EdgeInsets.all(30),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(3),
        color: Colors.redAccent,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: onPress,
            child:  Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
      ));
}