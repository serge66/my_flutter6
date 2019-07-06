import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_flutter6/utils/NetUtil.dart';

class LoginInvalidHandler {
  BuildContext currentContext;
  LoginInvalidHandler(this.currentContext);

  Future<Null> loginInvalidHandler(dynamic errorMsg) {
    if (errorMsg != null && errorMsg is LogicError) {
      print('errorMsg--------${errorMsg.code}');
      if (errorMsg.code == "0-056006" ||
          errorMsg.code == "0-056005" ||
          errorMsg.code == "0-056004" ||
          errorMsg.code == "0-056003" ||
          errorMsg.code == "0-056002" ||
          errorMsg.code == "0-056001") {
        print('重新登录,跳转界面22222--------${errorMsg.code}');
//      LocalStorage.clearLoginInfo();
//      Fluttertoast.showToast(
//          msg: '您的登录已过期，请重新登录',
//          gravity: ToastGravity.CENTER,
//          timeInSecForIos: 3);
//      NavigatorUtils.goPwdLogin(currentContext);
      }

      return Future.error(errorMsg);
    }
    return Future.error(errorMsg);
  }
}

Future<Null> nullFutureHandler(dynamic data) {
  return Future.value(null);
}
