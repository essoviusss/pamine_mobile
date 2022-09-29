import 'package:flutter/foundation.dart';
import 'package:pamine_mobile/model/buyer_user_model.dart';

class BuyerUserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    email: '',
    displayName: '',
    uid: '',
    role: '',
  );

  UserModel get user => _user;

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
