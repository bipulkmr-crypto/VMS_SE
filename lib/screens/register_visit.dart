import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/components/button.dart';
import 'package:vms/model/pass_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:vms/screens/pass_screen.dart';
import 'package:http/http.dart' as http;

import '../secret.dart';

class RegisterVisit extends StatefulWidget {
  const RegisterVisit({Key? key}) : super(key: key);
  @override
  _RegisterVisitState createState() => _RegisterVisitState();
}

class _RegisterVisitState extends State<RegisterVisit> {
  final _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? photo;
  final ImagePicker _picker = ImagePicker();

  // string for displaying the error Message
  String? errorMessage;

  String idTypeSelected = "Aadhaar";

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final idEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final contactInfoController = TextEditingController();
  final hostEmailEditingController = TextEditingController();
  final hostNameEditingController = TextEditingController();
  final dayInfoController = TextEditingController();
  final venueLocationEditingController = TextEditingController();

  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        {
          photo = File(pickedFile.path);
        }
      });
    }
  }

  Future uploadFile(String name) async {
    if (photo == null) return;
    try {
      await storage.ref(name).putFile(photo!);
    } catch (e) {
      if (kDebugMode) {
        print('error occurred');
      }
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //first name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
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
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    Widget idTypeField = Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        // decoration: InputDecoration(
        //   prefixIcon: const Icon(Icons.calendar_today_outlined),
        //   contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        //   hintText: "Enter number of days",
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Icon(Icons.account_circle, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                  child: DropdownButton<String>(
                isExpanded: true,
                value: idTypeSelected,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    idTypeSelected = newValue ?? "Aadhaar";
                  });
                },
                items: <String>["Aadhaar", "Driving License", "PAN", "Voter ID"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))
            ]));

    //id
    final idField = TextFormField(
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
          hintText: "ID",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final hostName = TextFormField(
        autofocus: false,
        controller: hostNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Host Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          hostNameEditingController.text = value!;
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
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = RegExp(r'^.{10,}$');
          if (value!.isEmpty) {
            return ("Phone Number is required for Pass");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Phone number");
          }
          return null;
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
          nameEditingController.text = value!;
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
    final hostEmailField = TextFormField(
        autofocus: false,
        controller: hostEmailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp(r"^[a-zA-Z0-9+_.-]+@iiita\.ac\.in").hasMatch(value)) {
            return ("Please Enter a valid email of domain iiita.ac.in");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
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
    final venueLocation = TextFormField(
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
          nameEditingController.text = value!;
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
        keyboardType: TextInputType.number,
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

    final uploadImage = Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 55,
          backgroundColor: const Color(0xffFDCF09),
          child: photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
    final submitButton = makeButton("Submit", submit);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                    uploadImage,
                    const SizedBox(height: 20),
                    nameField,
                    const SizedBox(height: 20),
                    contactInfo,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    idTypeField,
                    const SizedBox(height: 20),
                    idField,
                    const SizedBox(height: 20),
                    hostName,
                    const SizedBox(height: 20),
                    hostEmailField,
                    const SizedBox(height: 20),
                    venueLocation,
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

  void submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Uploading'), backgroundColor: Colors.blue));
      postDetailsToFirestore();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Errors in form'), backgroundColor: Colors.red));
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    PassModel passModel = PassModel();
    var uuid = const Uuid();
    passModel.passSecret = uuid.v1();
    passModel.userId = user?.uid;
    passModel.email = user!.email;
    passModel.name = nameEditingController.text;
    passModel.contactInfo = contactInfoController.text;
    passModel.idType = idTypeSelected;
    passModel.idValue = idEditingController.text;
    passModel.days = int.parse(dayInfoController.text);
    passModel.hostName = hostNameEditingController.text;
    passModel.hostEmail = hostEmailEditingController.text;
    passModel.location = venueLocationEditingController.text;
    passModel.isActive = false;
    passModel.isVerified = false;

    await firebaseFirestore
        .collection("passes")
        .add(passModel.toMap())
        .then((value) => {passModel.uid = value.id});

    await Future.wait([
      firebaseFirestore.collection("users").doc(user.uid).update({
        'passes': FieldValue.arrayUnion([passModel.uid!])
      }),
      uploadFile(passModel.uid!),
      http.post(Uri.parse('https://vms-iiita.herokuapp.com/send_email'),
          headers: <String, String>{
            'Authorization': emailAuthToken,
          },
          body: <String, String>{
            'name': passModel.name ?? 'error',
            'secret': passModel.uid ?? "error",
            'email': passModel.hostEmail ?? "error"
          })
    ]);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pass created successfully!"),
        backgroundColor: Colors.green));


    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PassScreen(passModel);
    }));
  }
}
