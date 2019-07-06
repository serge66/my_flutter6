import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui' as ui;
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter6/utils/NetUtil.dart';
import 'package:my_flutter6/utils/common_error_handler_utils.dart';
import 'package:my_flutter6/widget/NetLoadingDialog.dart';
import 'package:my_flutter6/widget/Toast.dart';
import 'package:my_flutter6/widget/LoadingDialog.dart';
import 'package:my_flutter6/utils/ApiInterface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

var mParams;
bool _saving = false;

class ChangePwd extends StatefulWidget {
  ChangePwd(Map params) {
    mParams = params;
    print('mParams--------$mParams');
  }

  @override
  _ChangePwd createState() => new _ChangePwd();
}

class _ChangePwd extends State<ChangePwd> {
  void setShowHind(bool b) {
    setState(() {
      _saving = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      title: '修改密码',
      home: Scaffold(
        appBar: AppBar(
          title: Text('修改密码'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              FlutterBoost.singleton.closePageForContext(context);
            },
          ),
        ),
        body: ModalProgressHUD(
            child: Container(
              child: MyBody(setShowHind),
            ),
            inAsyncCall: _saving),
      ),
    );
  }
}

class MyBody extends StatelessWidget {
  static TextEditingController _textEditingController =
      new TextEditingController();

  static TextEditingController _textEditingController2 =
      new TextEditingController();

  static TextEditingController _textEditingController3 =
      new TextEditingController();

  var setShowHind;

  MyBody(void Function(bool b) setShowHind) {
    this.setShowHind = setShowHind;
  }

  void commit(BuildContext context) {
    String oldPwd = _textEditingController.text.trim();
    String newPwd = _textEditingController2.text.trim();
    String againPwd = _textEditingController3.text.trim();
    print(oldPwd);
    print(newPwd);
    print(againPwd);

    if (!oldPwd.isNotEmpty) {
      Toast.show(context, '请输入旧密码');
      return;
    }
    if (!newPwd.isNotEmpty) {
      Toast.show(context, '请输入新密码');
      return;
    }
    if (!againPwd.isNotEmpty) {
      Toast.show(context, '请输入新密码');
      return;
    }
    if (newPwd != againPwd) {
      Toast.show(context, '两次密码不相同');
      return;
    }
    setShowHind(true);

    ApiInterface.changePwd(mParams["userid"], oldPwd, newPwd,
            mParams["_ticket_"], new LoginInvalidHandler(context))
        // ApiInterface.login("13973526618", "123456",new LoginInvalidHandler(context))
        .then((data) {
      /// 请求成功 进行成功的逻辑处理
      setShowHind(false);
      print('成功');
      print(data);
      Toast.show(context, "修改密码成功");
      FlutterBoost.singleton.closePageForContext(context);
    }).catchError((errorMsg) {
      /// 请求失败  进入了自定义的error拦截
      setShowHind(false);
      print('失败');
      print(errorMsg);
      if (errorMsg is LogicError) {
        LogicError logicError = errorMsg;
        Toast.show(context, logicError.msg);
      } else {
        /// 请求失败 dio异常
        Toast.show(context, "网络请求失败,请检查网络后重试");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: '请输入旧密码',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  labelText: '旧密码',
                  labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
              minLines: 1,
              maxLines: 1,
            ),
          ),
          Container(
            child: TextField(
              controller: _textEditingController2,
              decoration: InputDecoration(
                  hintText: '请输入新密码',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  labelText: '新密码',
                  labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
              keyboardType: TextInputType.number,
              minLines: 1,
              maxLines: 1,
            ),
          ),
          Container(
            child: TextField(
              controller: _textEditingController3,
              decoration: InputDecoration(
                  hintText: '请确认新密码',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  labelText: '新密码',
                  labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
              keyboardType: TextInputType.number,
              minLines: 1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: RaisedButton(
              child: Text(
                "确认",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                commit(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
