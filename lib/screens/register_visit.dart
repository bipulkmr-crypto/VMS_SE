import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vms/components/button.dart';
import 'package:vms/model/user_model.dart';
import 'package:vms/components//ImageUploads.dart';
import 'package:vms/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../model/pass_model.dart';

class RegisterVisit extends StatefulWidget {
  const RegisterVisit({Key? key}) : super(key: key);
  @override
  _RegisterVisitState createState() => _RegisterVisitState();
}

class _RegisterVisitState extends State<RegisterVisit> {
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final idEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final contactInfoController = TextEditingController();
  final HostemailEditingController = TextEditingController();
  final HostNameEditingController = TextEditingController();
  final dayInfoController = TextEditingController();
  final venueLocationEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //id
    final Id = TextFormField(
        autofocus: false,
        controller: idEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("ID cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          idEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.card_membership_sharp),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "ID Type",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final HostName = TextFormField(
        autofocus: false,
        controller: HostNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Host Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          HostNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Host Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //contact
    final contactInfo = TextFormField(
        autofocus: false,
        controller: contactInfoController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Contact Info can't be empty");
          }
          return null;
        },
        onSaved: (value) {
          contactInfoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contact Information",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final HostemailField = TextFormField(
        autofocus: false,
        controller: HostemailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Host Email Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final VenueLocation = TextFormField(
        autofocus: false,
        controller: venueLocationEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Visiting Location");
          }

          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_city_sharp),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Venue Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final days = TextFormField(
        autofocus: false,
        controller: dayInfoController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Days Info can't be empty");
          }
          return null;
        },
        onSaved: (value) {
          dayInfoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter number of days",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final submitButton = makeButton("Submit", () => {


    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    UploadImage(),
                    const SizedBox(height: 20),
                    firstNameField,
                    const SizedBox(height: 20),
                    secondNameField,
                    const SizedBox(height: 20),
                    contactInfo,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    Id,
                    const SizedBox(height: 20),
                    HostName,
                    const SizedBox(height: 20),
                    HostemailField,
                    const SizedBox(height: 20),
                    VenueLocation,
                    const SizedBox(height: 20),
                    days,
                    const SizedBox(height: 20),
                    submitButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;

          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        if (kDebugMode) {
          print(error.code);
        }
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    // UserModel userModel = UserModel();
    // writing all the values
    var uuid=const Uuid();
    PassModel passModel=PassModel();
    passModel.email = user!.email;
    passModel.uid =user.uid;
    passModel.firstName = firstNameEditingController.text;
    passModel.secondName = secondNameEditingController.text;
    passModel.contactInfo=contactInfoController.text;
    passModel.idType=idEditingController.text;
    passModel.days=dayInfoController.value as int?;
    passModel.hostName=HostNameEditingController.text;
    passModel.hostEmail=HostemailEditingController.text;
    passModel.location=venueLocationEditingController.text;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(passModel.toMap());
    Fluttertoast.showToast(msg: "Pass created successfully :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
//add in line 144

// Container(
// padding: const EdgeInsets.all(16),
// child: DropDownFormField(
// titleText: 'My workout',
// hintText: 'Please choose one',
// // onSaved: (value) {
// //   setState(() {
// //     _myActivity = value;
// //   });
// // },
// // onChanged: (value) {
// //   setState(() {
// //     _myActivity = value;
// //   });
// // },
// dataSource: const [
// {
// "display": "Aadhar Card",
// "value": "1",
// },
// {
// "display": "Passport",
// "value": "2",
// },
// {
// "display": "College Id Card",
// "value": "3",
// },
// {
// "display": "Driving License",
// "value": "4",
// },
// // {
// //   "display": "Soccer Practice",
// //   "value": "Soccer Practice",
// // },
// // {
// //   "display": "Baseball Practice",
// //   "value": "Baseball Practice",
// // },
// // {
// //   "display": "Football Practice",
// //   "value": "Football Practice",
// // },
// ],
// textField: 'display',
// valueField: 'value',
// ),
// ),
