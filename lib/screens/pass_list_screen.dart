import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:vms/model/pass_model.dart';

class PassListScreen extends StatefulWidget {
  final Future<List<PassModel>> passModels;
  final void Function(PassModel) onTap;

  const PassListScreen(this.passModels, this.onTap, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PassListScreenState();
}

class PassListScreenState extends State<PassListScreen> {
  bool loading = true;
  List<PassModel> passes = [];
  @override
  void initState() {
    widget.passModels.then((List<PassModel> value) {
      for (var i = 0; i < value.length; i++) {
        passes.add(value[i]);
      }
      setState(() {
        loading = false;
      });
    });
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
        body: loading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitRotatingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              )
            : passes.isNotEmpty
                ? ListView.separated(
                    itemCount: passes.length,
                    itemBuilder: (context, ind) =>
                        ListItem(passes[ind], widget.onTap),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                    "There is Nothing here!",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )));
  }
}

class ListItem extends StatefulWidget {
  final PassModel pass;
  final void Function(PassModel) onTap;

  const ListItem(this.pass, this.onTap, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListItemState();
}

class ListItemState extends State<ListItem> {
  String? photoUrl;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    storage.ref(widget.pass.uid).getDownloadURL().then((value) {
      setState(() => {photoUrl = value});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        elevation: 20,
        onPressed:  () =>widget.onTap(widget.pass),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            // decoration:
            //     ShapeDecoration(shape: Border(bottom: BorderSide(width: 0.5))),
            child: Row(
              children: [
                photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          photoUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.grey[800],
                        ),
                      ),
                const SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Name ", style: TextStyle(fontSize: 16)),
                      Text("Host ", style: TextStyle(fontSize: 16)),
                    ]),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(widget.pass.name ?? "error",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                      Text(widget.pass.hostName ?? "error",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ])),
                widget.pass.isActive!
                    ? const Icon(Icons.check, color: Colors.green)
                    : (widget.pass.isVerified!
                        ? const Icon(Icons.close_rounded, color: Colors.red)
                        : const Icon(Icons.check_box_outline_blank,
                            color: Colors.yellow, size: 40)),
              ],
            )));
  }
}
