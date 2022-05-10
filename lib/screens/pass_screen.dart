// import 'dart:html';

import 'package:vms/model/pass_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PassScreen extends StatefulWidget {
  final PassModel passModel;

  const PassScreen(this.passModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PassScreenState();
}

class PassScreenState extends State<PassScreen> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? photoUrl;
  @override
  void initState() {
    storage
        .ref(widget.passModel.uid)
        .getDownloadURL()
        .then((val) => setState(() => photoUrl = val));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
      // body: getListView(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ListTile(
          //
          // )
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      photoUrl!,
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
          ListItem(Icons.person_rounded, "Name", widget.passModel.name?? "none"),
          ListItem(Icons.phone, "Contact", widget.passModel.contactInfo?? "none"),
          ListItem(Icons.email, "Email", widget.passModel.email?? "none"),
          ListItem(Icons.card_membership, "Id Card", widget.passModel.idType?? "none"),
          ListItem(Icons.person_rounded, "Host Name", widget.passModel.hostName?? "none"),
          ListItem(Icons.mail, "Host Email", widget.passModel.hostEmail?? "none"),
          ListItem(Icons.place, "Venue", widget.passModel.location ?? "none"),
          ListItem(Icons.calendar_today_outlined, "Days", widget.passModel.days.toString()),


        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final IconData icon;
  final String type, value;
  const ListItem(this.icon, this.type,this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(20, 50, 20, 0), child: Row(mainAxisAlignment: MainAxisAlignment.start,
    children : [
      Icon(icon),
      const SizedBox(width: 10),
      SizedBox(width: 100, child: Text(type)),
      Expanded(child: Text(value, style: const TextStyle(color: Colors.grey)))
    ]
    ));
  }

}