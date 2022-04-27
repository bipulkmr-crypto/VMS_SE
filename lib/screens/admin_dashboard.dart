import 'dart:ui';

import 'package:vms/model/user_model.dart';
import 'package:flutter/material.dart';
import '../components/banner.dart';
import '../components/button.dart';

class AdminDashboard extends StatelessWidget {
  UserModel loggedInUser = UserModel();
  AdminDashboard({required this.loggedInUser, Key? key}) : super(key: key);

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

            createButton("View Active Visitors", ()=>{}),
            createButton("View All Visitors", ()=>{}),
            createButton("Checkout Visitor", ()=>{}),
            BottomBanner(
                name: "${loggedInUser.firstName} ${loggedInUser.secondName}",
                role: "Administrator"),
          ],
        ),
      ),
    );
  }
}
