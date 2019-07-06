import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NetUtil {
  static final debug = true;
  static BuildContext context = null;
  static final host = 'http://192.168.3.9';
  static final baseUrl = host + '/';

  // ignore: argument_type_not_assignable
  static final Dio _dio = new Dio(new BaseOptions(
      method: "get",
      baseUrl: baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      followRedirects: true));

  /// 代理设置，方便抓包来进行接口调节
//  static void setProxy() {
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//      // config the http client
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY localhost:8888";
//      };
//      // you can also create a new HttpClient to dio
//      // return new HttpClient();
//    };
//  }

  static String token;

  static final LogicError unknowError = LogicError(-1, "未知异常");

  static Future<Map<String, dynamic>> getJson<T>(
      String uri, Map<String, dynamic> paras, String token) {
    setToken(token);
    return _httpJson("get", uri, data: paras).then(logicalErrorTransform);
  }

  static Future<Map<String, dynamic>> getForm<T>(
      String uri, Map<String, dynamic> paras, String token) {
    setToken(token);
    return _httpJson("get", uri, data: paras, dataIsJson: false)
        .then(logicalErrorTransform);
  }

  /// 表单方式的post
  static Future<Map<String, dynamic>> postForm<T>(
      String uri, Map<String, dynamic> paras, String token) {
    setToken(token);
    return _httpJson("post", uri, data: paras, dataIsJson: false)
        .then(logicalErrorTransform);
  }

  /// requestBody (json格式参数) 方式的 post
  static Future<Map<String, dynamic>> postJson(
      String uri, Map<String, dynamic> body, String token) {
    setToken(token);
    return _httpJson("post", uri, data: body).then(logicalErrorTransform);
  }

  static Future<Map<String, dynamic>> deleteJson<T>(
      String uri, Map<String, dynamic> body, String token) {
    setToken(token);
    return _httpJson("delete", uri, data: body).then(logicalErrorTransform);
  }

  /// requestBody (json格式参数) 方式的 put
  static Future<Map<String, dynamic>> putJson<T>(
      String uri, Map<String, dynamic> body, String token) {
    setToken(token);
    return _httpJson("put", uri, data: body).then(logicalErrorTransform);
  }

  /// 表单方式的 put
  static Future<Map<String, dynamic>> putForm<T>(
      String uri, Map<String, dynamic> body, String token) {
    setToken(token);
    return _httpJson("put", uri, data: body, dataIsJson: false)
        .then(logicalErrorTransform);
  }

  /// 文件上传  返回json数据为字符串
  static Future<T> putFile<T>(String uri, String filePath, String token) {
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.from({
      "multipartFile": new UploadFileInfo(new File(filePath), name,
          contentType: ContentType.parse("image/$suffix"))
    });

    var enToken = token == null ? "" : Uri.encodeFull(token);
    return _dio
        .put<Map<String, dynamic>>("$uri?token=$enToken", data: formData)
        .then(logicalErrorTransform);
  }

  static Future<Response<Map<String, dynamic>>> _httpJson(
      String method, String uri,
      {Map<String, dynamic> data, bool dataIsJson = true}) {
    var enToken = token == null ? "" : Uri.encodeFull(token);

    /// 如果为 get方法，则进行参数拼接
    if (method == "get") {
      dataIsJson = false;
      if (data == null) {
        data = new Map<String, dynamic>();
      }
      // data["_ticket_"] = token;
    }

    if (debug) {
      print('<net url>------$uri');
      print('<net params>------$data');
    }

    /// 根据当前 请求的类型来设置 如果是请求体形式则使用json格式
    /// 否则则是表单形式的（拼接在url上）
    Options op;
    if (dataIsJson) {
      op = new Options(contentType: ContentType.parse("application/json"));
    } else {
      op = new Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"));
    }

    op.method = method;
    Map<String, String> map = Map<String, String>();
    map["_ticket_"] = enToken;

    op.headers = map;

    /// 统一带上token
    return _dio.request<Map<String, dynamic>>(
        // method == "get" ? uri : "$uri?_ticket_=$enToken",
        uri,
        data: data,
        options: op);
  }

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<T> logicalErrorTransform<T>(
      Response<Map<String, dynamic>> resp) {
    print('<net resp222>------$resp');
    print('<net resp333>------${resp.data}');

    if (resp.data != null) {
      if (resp.data["data"] != null) {
        T realData = resp.data["data"];
        return Future.value(realData);
      } else if (resp.data["code"]["code"] == "0") {
        T realData = resp.data["result"];
        return Future.value(realData);
      }
    }

    if (debug) {
      print('resp--------$resp');
      print('resp.data--------${resp.data}');
    }
    LogicError error;
    if (resp.data != null && resp.data["code"]["code"] != "0") {
      if (resp.data['code'] != null) {
        /// 失败时  错误提示在 data中时
        /// 收到token过期时  直接进入登录页面
        Map<String, dynamic> realData = resp.data["code"];
        error = new LogicError(realData["code"], realData['msg']);

        /// token失效 重新登录  后端定义的code码
        if (realData["code"] == "0-056006" ||
            realData["code"] == "0-056005" ||
            realData["code"] == "0-056004" ||
            realData["code"] == "0-056003" ||
            realData["code"] == "0-056002" ||
            realData["code"] == "0-056001") {
          //        NavigatorUtils.goPwdLogin(context);Ï
          //TODO重新登录,跳转界面
          print('重新登录,跳转界面--------${realData["code"]}');
        }
        if (realData["code"] == 80000000) {
          //操作逻辑
        }
      } else {
        /// 失败时  错误提示在 message中时
        // error = new LogicError(resp.data["code"], resp.data["message"]);
        error = unknowError;
      }
    } else {
      error = unknowError;
    }
    print('error--------${error.code}');
    return Future.error(error);
  }

  ///  获取token
  ///获取授权token
  static getToken() async {
//    String token = await LocalStorage.get(LocalStorage.TOKEN_KEY);
    return token;
  }

  static setToken(String t) {
    token = t;
  }
}

class LogicError {
  String code;
  String msg;

  LogicError(errorCode, msg) {
    this.code = errorCode;
    this.msg = msg;
  }
}

enum PostType { json, form, file }
