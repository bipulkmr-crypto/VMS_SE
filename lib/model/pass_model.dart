import 'dart:typed_data';

class PassModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? hostName;
  String? hostEmail;
  String? contactInfo;
  String? idType;
  String? location;
  int? days;

  PassModel({this.uid, this.email, this.firstName, this.secondName, this.hostEmail,this.hostName,this.days,this.contactInfo,this.idType,this.location});

  // receiving data from server
  factory PassModel.fromMap(map) {
    return PassModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      hostEmail: map['hostEmail'],
      hostName: map['hostName'],
      days: map['days'],
      contactInfo: map['contactInfo'],
      idType: map['idType'],
      location: map['Location']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'hostEmail':hostEmail,
      'hostName':hostName,
      'days':days,
      'idType':idType,
      'contactInfo':contactInfo,
      'location':location
    };
  }
}
