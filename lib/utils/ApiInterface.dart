import 'dart:io';
import 'package:dio/dio.dart';
import 'package:my_flutter6/utils/common_error_handler_utils.dart';
import 'package:my_flutter6/utils/NetUtil.dart';

/// 所有接口请求

class ApiInterface {
  static final String _API_updatePasswordForPhone =
      "user/updatePasswordForPhone.json";
  static Future<Map<String, dynamic>> changePwd(String userId, String oldPwd,
      String newPwd, String token, LoginInvalidHandler handler) async {
    return NetUtil.postForm(
            _API_updatePasswordForPhone,
            {"user_id": userId, "old_password": oldPwd, "newpassword": newPwd},
            token)
        .catchError(handler.loginInvalidHandler);
  }

  static final String _API_LOGIN = "ecompany/loginForAndroid.json";
  static Future<Map<String, dynamic>> login(String username, String password,
      String token, LoginInvalidHandler handler) async {
    return NetUtil.postForm(
            _API_LOGIN, {"username": username, "password": password}, token)
        .catchError(handler.loginInvalidHandler);
  }
}
