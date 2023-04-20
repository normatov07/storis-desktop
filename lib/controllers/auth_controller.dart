import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/controllers/home_controller.dart';
import 'package:stork_uz/pages/home_page.dart';

Future<String> sendRegisterRequest(String email, String password,SharedPreferences pref, context) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(dotenv.get('API_HOST') + '/auth/register'));
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        var id = resArr['id'];
        var email = resArr['email'];
      } catch (e) {
        print(e.toString());
        return "something went wrong, please try again later!";
      }
    } else if (res.statusCode == 403) {
      return "the email was already registred!";
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return "";
    }else {
      print(await res.stream.bytesToString());
      return "something went wrong, please try again later!";
    }

    return "success";
  } catch (e) {
    print("error: " + e.toString());
    return "something went wrong, please try again later!";
  }
}

Future<String> sendLoginRequest(String email, String password, SharedPreferences pref, context) async {
  print(email + "  " + password);
  print(dotenv.get('API_HOST') + '/auth/login');
  try {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(dotenv.get('API_HOST') + '/auth/login'));
    request.body = json.encode({"email": email, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        final pref = await SharedPreferences.getInstance();
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        var id = resArr['user']['id'];
        var token = resArr['access_token'];

        pref.setString('access_token', token);
        pref.setInt('id', id);
        pref.setString('email', resArr['user']['email']);
        pref.setInt('account_id', resArr['user']['account_id']);
        pref.setBool('active', resArr['user']['active']);

        var ln = resArr['user']['Permissions'];
        List<String> strLink = List<String>.from(ln as List);
        pref.setStringList('permissions', strLink);

        // print(token);
      } catch (e) {
        print(e);
        return "something went wrong, please try again later!";
      }
    } else if (res.statusCode == 403) {
      return "the email was already registred!";
    } else if (res.statusCode == 404) {
      var data = await res.stream.bytesToString();
      var resArr = jsonDecode(data);
      if (resArr['error'] == "email or password is incorrect") {
        return resArr['error'] + '!';
      }
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return "";
    } else {
      print(await res.stream.bytesToString());
      return "something went wrong, please try again later!";
    }

    return "success";
  } catch (e) {
    print("error: " + e.toString());
    return "something went wrong, please try again later!";
  }
}

void modifyToken(String token) async {
  var pref = await SharedPreferences.getInstance();
  if (token.isNotEmpty) {
    pref.setString('access_token', token);
  }
}

void showAlert(context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? mess = pref.getString('message');
  String? messType = pref.getString('message_type');
  // String? token = pref.getString('access_token');
  //  print("ShowAlertFunc token: ");
  //  print(token);
  //     if(token == null || token.isEmpty){
  //         Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                     builder: (context) => LoginPage(pref: pref,),
  //                     ),
  //                 );
  //     }

  if (mess != null && messType != null) {
    if (messType == "success") {
      CherryToast.success(
        title: Text(mess),
        borderRadius: 5,
        animationType: AnimationType.fromTop,
        autoDismiss: true,
      ).show(context);
    } else if (messType == "error") {
      CherryToast.error(
        title: Text(mess),
        animationType: AnimationType.fromTop,
        borderRadius: 5,
        autoDismiss: true,
      ).show(context);
    }
    pref.remove('message');
    pref.remove('message_type');
  }
}

void authMiddleware(context, SharedPreferences pref) {}

void renderAfterLogin(context, SharedPreferences pref) {
  String? account = pref.getString("company_name");
  pref.setString('message', "Welcome back! you are logged in successfully.");
  pref.setString('message_type', 'success');

  if (account == null) {
    pref.setString('route', 'account');
  } else {
    pref.setString('route', 'product');
  }

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => HomePage(
        pref: pref,
      ),
    ),
  );
}
