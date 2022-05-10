import 'dart:ui';

import 'package:vms/model/pass_model.dart';
import 'package:vms/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:vms/screens/pass_list_screen.dart';
import 'package:vms/screens/pass_screen.dart';
import '../components/banner.dart';
import '../components/button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  UserModel loggedInUser = UserModel();
  AdminDashboard({required this.loggedInUser, Key? key}) : super(key: key);

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<PassModel>> getActivePasses() async {
    return firebaseFirestore
        .collection('passes')
        .where('isActive', isEqualTo: true)
        .get()
        .then((res) {
      List<PassModel> passes = [];
      for (var element in res.docs) {
        passes.add(PassModel.fromMap(element.id, element.data()));
      }
      return passes;
    });
  }

  Future<List<PassModel>> getAllPasses() async {
    return firebaseFirestore.collection('passes').get().then((res) {
      List<PassModel> passes = [];
      for (var element in res.docs) {
        passes.add(PassModel.fromMap(element.id, element.data()));
      }
      return passes;
    });
  }

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
            makeButton(
                "View Active Visitors",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PassListScreen(getActivePasses(), (pass) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return PassScreen(pass);
                          }));
                        });
                      }))
                    }),
            makeButton(
                "View All Visitors",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PassListScreen(getAllPasses(), (pass) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return PassScreen(pass);
                          }));
                        });
                      }))
                    }),
            makeButton("Checkout Visitor", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return PassListScreen(getActivePasses(), (PassModel pass) {
                  firebaseFirestore
                      .collection("passes")
                      .doc(pass.uid)
                      .update({"isActive": false});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Pass checked out successfully!"),
                      backgroundColor: Colors.green));
                });
              }));
            }),
            BottomBanner(
                name: "${loggedInUser.firstName} ${loggedInUser.secondName}",
                role: "Administrator"),
          ],
        ),
      ),
    );
  }
}
