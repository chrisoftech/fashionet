import 'dart:async';

import 'package:meta/meta.dart';

class AuthRepository {
  Future<bool> isAuthenticated() async {
    Future.delayed(Duration(seconds: 2));
    return false;
  }

  Future<String> verifyPhoneNumber({@required String phoneNumber}) async {
    Future.delayed(Duration(seconds: 2));
    return '123456';
  }

  Future<String> authenticate(
      {@required String verificationCode, @required verificationId}) async {
    Future.delayed(Duration(seconds: 2));
    return 'token';
  }

  Future<void> persistsToken({@required String token}) async {
    Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> deleteToken() async {
    Future.delayed(Duration(seconds: 2));
    return;
  }
}
