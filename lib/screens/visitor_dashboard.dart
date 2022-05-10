import 'package:vms/model/pass_model.dart';
import 'package:vms/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:vms/screens/pass_list_screen.dart';
import 'package:vms/screens/pass_screen.dart';
import 'package:vms/screens/register_visit.dart';
import '../components/banner.dart';
import '../components/button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VisitorDashboard extends StatelessWidget {
  UserModel loggedInUser = UserModel();
  VisitorDashboard({required this.loggedInUser, Key? key}) : super(key: key);
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<List<PassModel>> getUserActivePasses() async {
    return firebaseFirestore
        .collection('passes')
        .where('userId', isEqualTo: loggedInUser.uid ?? 'error')
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
  Future<List<PassModel>> getUserAllPasses() async {
    return firebaseFirestore
        .collection('passes')
        .where('userId', isEqualTo: loggedInUser.uid ?? 'error')
        .get()
        .then((res) {
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
                "Register Visit",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const RegisterVisit();
                      }))
                    }),
            makeButton(
                "View Active Passes",
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PassListScreen(getUserActivePasses(), (pass){

                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return PassScreen(pass);
                              }));
                        });
                      }))
                    }),
            makeButton("View All Passes", () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PassListScreen(getUserAllPasses(), (pass){

                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PassScreen(pass);
                          }));
                    });
                  }))
            }),
            BottomBanner(
                name: "${loggedInUser.firstName} ${loggedInUser.secondName}",
                role: "Visitor"),
          ],
        ),
      ),
    );
  }
}
