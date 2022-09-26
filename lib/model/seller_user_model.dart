//EmailAndPassword Insert

class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? role;
  String? status;

  UserModel({this.uid, this.fullName, this.email, this.role, this.status});
  //receive
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      role: map['role'],
      status: map['status'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'status': status,
    };
  }
}

//Google Insert
class ProviderModel {
  String? uid;
  String? displayName;
  String? email;
  String? role;

  ProviderModel({this.uid, this.displayName, this.email, this.role});
  //receive
  factory ProviderModel.fromMap(map) {
    return ProviderModel(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
      role: map['role'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'role': role,
    };
  }
}

class AddModel {
  String? businessName;
  String? phoneNumber;
  String? address;
  String? zipCode;

  String? dtiCertNumber;
  String? permitExpDate;
  String? uid;
  String? status;

  AddModel(
      {this.businessName,
      this.phoneNumber,
      this.address,
      this.zipCode,
      this.dtiCertNumber,
      this.permitExpDate,
      this.uid,
      this.status});

  factory AddModel.fromMap(map) {
    return AddModel(
      businessName: map['businessName'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      zipCode: map['zipCode'],
      dtiCertNumber: map['dtiCertNumber'],
      permitExpDate: map['permitExpDate'],
      uid: map['uid'],
      status: map['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'phoneNumber': phoneNumber,
      'address': address,
      'zipCode': zipCode,
      'dtiCertNumber': dtiCertNumber,
      'permitExpDate': permitExpDate,
      'uid': uid,
      'status': status,
    };
  }
}
