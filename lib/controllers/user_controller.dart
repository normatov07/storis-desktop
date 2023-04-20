import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/controllers/home_controller.dart';
import 'package:stork_uz/pages/home_page.dart';

Future<List<dynamic>> createInvitationRequest(
    String email, String role, context) async {
  int role_id = 0;

  switch (role) {
    case 'Manager':
      role_id = 2;
      break;
    case 'User':
      role_id = 3;
      break;
    case 'Customer':
      role_id = 4;
      break;
  }
  print(role_id);
  if (role_id == 0) return [{"message":"role field is required","response":""}];

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? bearer = "Bearer " + pref.getString("access_token")!;

  var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

  int? company_id = pref.getInt("company_id");
  print(company_id);
  if (company_id==null) {
    String resp = await getMe(context);
    if (resp != "success") {
      return [{"message":resp,"response":""}];
    }
  company_id = pref.getInt("company_id");
  }
  var request = http.Request(
      'POST', Uri.parse(dotenv.get('API_HOST') + '/auth/invite/create'));
  request.body = json.encode({"email": email, "account_id": company_id, "role_id": role_id});
  request.headers.addAll(headers);

  http.StreamedResponse res = await request.send();

  if (res.statusCode == 200) {
    try {
      // print("response: "+await res.stream.bytesToString());
      var data = await res.stream.bytesToString();
      var resArr = jsonDecode(data);

      var id = resArr['id'];
      var email = resArr['email'];
      var acc_id = resArr['account_id'];

      return [{"message":"success","response":resArr}];
    } catch (e) {
      print(e.toString());
      return [{"message":"something went wrong, please try again later!","response":""}];
    }
  } else if (res.statusCode == 404) {
    return [{"message":"invitation is already send this email!","response":""}];
  }else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return [{"message":"invitation is already send this email!","response":""}];
  } else if (res.statusCode == 400) {
    return [{"message":"some fields is not correct!","response":""}];
  } else {
    print(await res.stream.bytesToString());
    return [{"message":"something went wrong, please try again later!","response":""}];
  }
}

Future<String> getMe(context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? bearer = "Bearer " +  pref.getString("access_token")!;

  var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

  var request =
      http.Request('GET', Uri.parse(dotenv.get('API_HOST') + '/auth/me'));
  request.headers.addAll(headers);

  http.StreamedResponse res = await request.send();

  if (res.statusCode == 200) {
    try {
      // print("response: "+await res.stream.bytesToString());
      var data = await res.stream.bytesToString();
      var resArr = jsonDecode(data);

      int id = resArr['id'];
      String email = resArr['email'];
      bool active = resArr['active'];
      int acc_id = resArr['account_id'];
      var ln = resArr['Permissions'];
      // print(resArr);
      if (id<=0 || email.isEmpty || acc_id<=0) {
        if (acc_id == 0){
            pref.setString('message', "Your account is not defined. Please create or enter your account!");
            pref.setString('message_type', 'error');
            pref.setString('route', 'account');
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      pref: pref,
                    ),
                  ),
                );
        }
        return "Error while getting user data!";
      }

      pref.setString('email', email);
      pref.setInt('id', id);
      pref.setInt('company_id', acc_id);
      pref.setBool('active', active);

      List<String> strLink = List<String>.from(ln as List);
      pref.setStringList('permissions', strLink);
    } catch (e) {
      print(e.toString());
      return "something went wrong, please try again later!";
    }
  } else if (res.statusCode == 403) {
    return "the email was already registred!";
  }else if (res.statusCode == 401){
      renderLoginPage(pref,context);
    }  else {
    print(await res.stream.bytesToString());
    return "something went wrong, please try again later!";
  }

  return "success";
}


Future<List> getUserAccounts(context) async {
   SharedPreferences pref = await SharedPreferences.getInstance();
   String? bearer = "Bearer " +  pref.getString("access_token")!;

  var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

  var request = http.Request('GET', Uri.parse(dotenv.get('API_HOST') + '/auth/invite/getUsers'));
  request.headers.addAll(headers);

  http.StreamedResponse res = await request.send();

  if (res.statusCode == 200) {
    try {
      // print("response: "+await res.stream.bytesToString());
      var data = await res.stream.bytesToString();
      var resArr = jsonDecode(data);

      return resArr;
      
    } catch (e) {
      print(e.toString());
      return [];
    }
  } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return [];
    } else {
    print(await res.stream.bytesToString());
    return [];
  }
}


Future<Map> deleteInviteById(context,invite_id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? bearer = "Bearer " +  pref.getString("access_token")!;

  var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

  var request =
      http.Request('DELETE', Uri.parse(dotenv.get('API_HOST') + '/auth/invite/delete/$invite_id'));
  request.headers.addAll(headers);

  http.StreamedResponse res = await request.send();

  if (res.statusCode == 200) {
    try {
      // print("response: "+await res.stream.bytesToString());
      var data = await res.stream.bytesToString();
      var resArr = jsonDecode(data);

      return {"message":"success", "data":resArr};
    } catch (e) {
      print(e.toString());
      return {"message":"something went wrong, please try again later!", "data":""};
    }
  } else if (res.statusCode == 404) {
    return {"message":"invitation is not found!", "data":""};
  } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {"message":"invitation is not found!", "data":""};
  } else {
    print(await res.stream.bytesToString());
    return {"message":"something went wrong, please try again later!", "data":""};
  }

  return {"message":"success", "data":""};
}