class PassModel {
  String? uid;
  String? email;
  String? name;
  String? userId;
  String? hostName;
  String? hostEmail;
  String? contactInfo;
  String? idType;
  String? idValue;
  String? location;
  int? days;
  bool? isVerified;
  bool? isActive;
  String? passSecret;

  PassModel(
      {this.uid,
      this.userId,
      this.email,
      this.name,
      this.hostEmail,
      this.hostName,
      this.days,
      this.contactInfo,
      this.idType,
      this.idValue,
      this.location,
      this.isActive,
      this.isVerified,
      this.passSecret
      });

  // receiving data from server
  factory PassModel.fromMap(id, map) {
    return PassModel(
        uid: id,
        userId: map['userId'],
        email: map['email'],
        name: map['firstName'],
        hostEmail: map['hostEmail'],
        hostName: map['hostName'],
        days: map['days'],
        contactInfo: map['contactInfo'],
        idType: map['idType'],
        idValue: map['idType'],
        location: map['Location'],
        isActive: map['isActive'],
        isVerified: map['isVerified'],
        passSecret:map['x000fasts']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'firstName': name,
      'hostEmail': hostEmail,
      'hostName': hostName,
      'days': days,
      'idType': idType,
      'idValue': idValue,
      'contactInfo': contactInfo,
      'location': location,
      'isActive': isActive,
      'isVerified': isVerified,
      'passSecret': passSecret,
    };
  }
}
