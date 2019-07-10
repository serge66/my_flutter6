import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter6/utils/NetUtil.dart';
import 'package:my_flutter6/utils/common_error_handler_utils.dart';
import 'package:my_flutter6/widget/ProgressDialog.dart';
import 'package:my_flutter6/widget/Toast.dart';
import 'package:my_flutter6/utils/ApiInterface.dart';

// var mParams;
// bool _saving = false;

class Test extends StatelessWidget {
  Test({this.params, this.uniqueId});
  final Map params;
  final String uniqueId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("/", (route) => false);
            // FlutterBoost.containerManager.deactivate();
            // FlutterBoost.containerManager.dispose();
            // FlutterBoost.containerManager.remove(widget.uniqueId);
            FlutterBoost.singleton.closePageForContext(context);
          },
        ),
      ),
      body: MyApp(params: params, dialogShow: false, uniqueId: uniqueId),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.params, this.dialogShow, this.uniqueId})
      : super(key: key);

  final Map params;
  bool dialogShow;
  final String uniqueId;
  @override
  _ChangePwd createState() => new _ChangePwd(dialogShow: dialogShow);
}

class _ChangePwd extends State<MyApp> {
  Timer timer;
  bool dialogShow;

  _ChangePwd({this.dialogShow});

  @override
  void deactivate() {
    print("------------deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("------------dispose");
    _textEditingController.clear();
    _textEditingController2.clear();
    _textEditingController3.clear();
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void setShowHind(bool b) {
    setState(() {
      dialogShow = b;
    });
  }

  static TextEditingController _textEditingController =
      new TextEditingController();

  static TextEditingController _textEditingController2 =
      new TextEditingController();

  static TextEditingController _textEditingController3 =
      new TextEditingController();

  // var setShowHind;

  // MyBody(void Function(bool b) setShowHind) {
  //   this.setShowHind = setShowHind;
  // }

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

    ApiInterface.changePwd(widget.params["userid"], oldPwd, newPwd,
            widget.params["_ticket_"], new LoginInvalidHandler(context))
        // ApiInterface.login("13973526618", "123456",new LoginInvalidHandler(context))
        .then((data) {
      /// 请求成功 进行成功的逻辑处理
      setShowHind(false);
      print('成功');
      print(data);
      Toast.show(context, "修改密码成功");
      timer = new Timer(const Duration(milliseconds: 1000), () {
        FlutterBoost.singleton.closePageForContext(context);
      });
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
      // FlutterBoost.singleton.closePageForContext(context);
      // Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
      loading: dialogShow,
      msg: '正在加载...',
      child: Container(
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
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
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
      ),
    );
  }
}

// class MyBody extends StatelessWidget {

// static TextEditingController _textEditingController =
//     new TextEditingController();

// static TextEditingController _textEditingController2 =
//     new TextEditingController();

// static TextEditingController _textEditingController3 =
//     new TextEditingController();

// var setShowHind;

// MyBody(void Function(bool b) setShowHind) {
//   this.setShowHind = setShowHind;
// }

// void commit(BuildContext context) {
//   String oldPwd = _textEditingController.text.trim();
//   String newPwd = _textEditingController2.text.trim();
//   String againPwd = _textEditingController3.text.trim();
//   print(oldPwd);
//   print(newPwd);
//   print(againPwd);

//   if (!oldPwd.isNotEmpty) {
//     Toast.show(context, '请输入旧密码');
//     return;
//   }
//   if (!newPwd.isNotEmpty) {
//     Toast.show(context, '请输入新密码');
//     return;
//   }
//   if (!againPwd.isNotEmpty) {
//     Toast.show(context, '请输入新密码');
//     return;
//   }
//   if (newPwd != againPwd) {
//     Toast.show(context, '两次密码不相同');
//     return;
//   }
//   setShowHind(true);

//   ApiInterface.changePwd(widget.params["userid"], oldPwd, newPwd,
//           mParams["_ticket_"], new LoginInvalidHandler(context))
//       // ApiInterface.login("13973526618", "123456",new LoginInvalidHandler(context))
//       .then((data) {
//     /// 请求成功 进行成功的逻辑处理
//     setShowHind(false);
//     print('成功');
//     print(data);
//     Toast.show(context, "修改密码成功");
//     FlutterBoost.singleton.closePageForContext(context);
//   }).catchError((errorMsg) {
//     /// 请求失败  进入了自定义的error拦截
//     setShowHind(false);
//     print('失败');
//     print(errorMsg);
//     if (errorMsg is LogicError) {
//       LogicError logicError = errorMsg;
//       Toast.show(context, logicError.msg);
//     } else {
//       /// 请求失败 dio异常
//       Toast.show(context, "网络请求失败,请检查网络后重试");
//     }
//     FlutterBoost.singleton.closePageForContext(context);
//     Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return Container(
//     color: Colors.white,
//     padding: const EdgeInsets.all(15),
//     child: Column(
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         Container(
//           child: TextField(
//             controller: _textEditingController,
//             decoration: InputDecoration(
//                 hintText: '请输入旧密码',
//                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
//                 labelText: '旧密码',
//                 labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
//             minLines: 1,
//             maxLines: 1,
//           ),
//         ),
//         Container(
//           child: TextField(
//             controller: _textEditingController2,
//             decoration: InputDecoration(
//                 hintText: '请输入新密码',
//                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
//                 labelText: '新密码',
//                 labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
//             keyboardType: TextInputType.number,
//             minLines: 1,
//             maxLines: 1,
//           ),
//         ),
//         Container(
//           child: TextField(
//             controller: _textEditingController3,
//             decoration: InputDecoration(
//                 hintText: '请确认新密码',
//                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
//                 labelText: '新密码',
//                 labelStyle: TextStyle(fontSize: 14, color: Colors.black)),
//             keyboardType: TextInputType.number,
//             minLines: 1,
//             maxLines: 1,
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
//           child: RaisedButton(
//             child: Text(
//               "确认",
//               style: TextStyle(color: Colors.white),
//             ),
//             color: Colors.blue,
//             onPressed: () {
//               commit(context);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
// }
