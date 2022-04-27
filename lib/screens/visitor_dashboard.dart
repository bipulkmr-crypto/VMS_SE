import 'dart:ui';

import 'package:vms/model/user_model.dart';
import 'package:flutter/material.dart';
import '../components/banner.dart';
import '../components/button.dart';

class VisitorDashboard extends StatelessWidget {
  UserModel loggedInUser = UserModel();
  VisitorDashboard({required this.loggedInUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const TopBanner(),

            createButton("Register Visit", ()=>{}),
            createButton("View Active Passes", ()=>{}),
            createButton("View Previous Passes", ()=>{}),
            BottomBanner(
                name: "${loggedInUser.firstName} ${loggedInUser.secondName}",
                role: "Visitor"),
          ],
        ),
      ),
    );
  }
}
