//User Provider
class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? role;

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.role,
  });
  //receive
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      role: map['role'],
    );
  }
  //send
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role,
    };
  }
}

//Google Provider
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
