import 'package:flutter/material.dart';
import 'package:pamine_mobile/model/seller_user_model.dart';

class UserProvider extends ChangeNotifier {
  ProviderModel _user = ProviderModel(
    email: '',
    displayName: '',
    uid: '',
    role: '',
  );

  ProviderModel get user => _user;

  setUser(ProviderModel user) {
    _user = user;
    notifyListeners();
  }
}
