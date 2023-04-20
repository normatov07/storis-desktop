import 'dart:collection';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/constants.dart';
import 'package:stork_uz/controllers/home_controller.dart';

Future<String> createAccountReq(String account_name,context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

    var request = http.Request(
        'POST', Uri.parse(dotenv.get('API_HOST') + '/auth/account/create'));
    request.body =
        json.encode({"company_name": account_name, "currency": "SUM"});
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        String company_name = resArr['company_name'];
        int company_id = resArr['id'];
        String curr = resArr['currency'];

        final pref = await SharedPreferences.getInstance();
        pref.setString('company_name', company_name);
        pref.setInt('company_id', company_id);
        pref.setString('currency', curr);
        pref.setString('role', "Owner");
        pref.setInt('role_id', OWNER_ROLE_ID);
      } catch (e) {
        print(e.toString());
        return "something went wrong, please try again later!";
      }
    } else if (res.statusCode == 403) {
      return "account was already registred!";
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
    }else {
      print(await res.stream.bytesToString());
      return "something went wrong, please try again later!";
    }

    return "success";
  } catch (e) {
    print("error: account_controller: " + e.toString());
    return "something went wrong, please try again later!";
  }
}

Future<Map<String, dynamic>> getAccountList(context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};

    var request = http.Request(
        'GET', Uri.parse(dotenv.get('API_HOST') + '/auth/invite/'));

    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);
        // print(resArr);
        return resArr;
      } catch (e) {
        print(e.toString());
        return {};
      }
    } else if (res.statusCode == 403) {
      return {};
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {};
    } else {
      print(await res.stream.bytesToString());
      return {};
    }
  } catch (e) {
    print("error: account_controller: " + e.toString());
    return {};
  }
}

Future<String> enterAccount(int account_id, context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};
print(account_id);
    var request = http.Request('GET',
        Uri.parse(dotenv.get('API_HOST') + '/auth/account/enter/$account_id'));

    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        String company_name = resArr['account_name'];
        int company_id = resArr['id'];
        int role_id = resArr['role_id'];
        String role = resArr['role'];

        final pref = await SharedPreferences.getInstance();
        pref.setInt('company_id', company_id);
        pref.setInt('role_id', role_id);
        pref.setString('company_name', company_name);
        pref.setString('role', role);
        return "success";
      } catch (e) {
        print(e.toString());
        return "something went wrong, please try again later!";
      }
    } else if (res.statusCode == 404) {
       print(await res.stream.bytesToString());
      return "this account is not found!";
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return "";
    } else {
      print(await res.stream.bytesToString());
      return "something went wrong, please try again later!";
    }
  } catch (e) {
    print("error: account_controller: " + e.toString());
    return "something went wrong, please try again later!";
  }
}
