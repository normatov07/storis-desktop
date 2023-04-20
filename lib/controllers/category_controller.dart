import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/controllers/home_controller.dart';

Future<Map> getCategories(context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};
    var request = http.Request(
        'GET', Uri.parse(dotenv.get('API_HOST') + '/store/category/'));

    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        return {"data": (resArr == null) ? [] : resArr, "message": "success"};
      } catch (e) {
        print(e.toString());
        return {
          "data": [],
          "message": "something went wrong, please try again later!"
        };
      }
    } else if (res.statusCode == 403) {
      return {"data": [], "message": "the data format is not suitable!"};
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {
        "data": [],
        "message": "something went wrong, please try again later!"
      };
    }  else {
      print(await res.stream.bytesToString());
      return {
        "data": [],
        "message": "something went wrong, please try again later!"
      };
    }
  } catch (e) {
    print("error: " + e.toString());
    return {
      "data": [],
      "message": "something went wrong, please try again later!"
    };
  }
}

Future<Map> getSubCategories(int parent_id, context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};
    var request = http.Request('GET',
        Uri.parse(dotenv.get('API_HOST') + '/store/category/$parent_id'));

    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        return {"data": (resArr == null) ? [] : resArr, "message": "success"};
      } catch (e) {
        print(e.toString());
        return {
          "data": [],
          "message": "something went wrong, please try again later!"
        };
      }
    } else if (res.statusCode == 403) {
      return {"data": [], "message": "the data format is not suitable!"};
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {
          "data": [],
          "message": "something went wrong, please try again later!"
        };
    }  else {
      print(await res.stream.bytesToString());
      return {
        "data": [],
        "message": "something went wrong, please try again later!"
      };
    }
  } catch (e) {
    print("error: " + e.toString());
    return {
      "data": [],
      "message": "something went wrong, please try again later!"
    };
  }
}

Future<Map> createCategory(String title, String metaTitle, int parentId, context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};
    var request = http.Request(
        'POST', Uri.parse(dotenv.get('API_HOST') + '/store/category/create'));
    request.body = json.encode({
      "title": title,
      "meta_title": metaTitle,
      "parent_id": parentId,
    });
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

        return {"data": (resArr == null) ? [] : resArr, "message": "success"};
      } catch (e) {
        print(e.toString());
        return {
          "data": [],
          "message": "something went wrong, please try again later!"
        };
      }
    } else if (res.statusCode == 403) {
      return {"data": [], "message": "the data format is not suitable!"};
    } else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {
          "data": [],
          "message": "something went wrong, please try again later!"
        };
    } else {
      print(await res.stream.bytesToString());
      return {
        "data": [],
        "message": "something went wrong, please try again later!"
      };
    }
  } catch (e) {
    print("error: " + e.toString());
    return {
      "data": [],
      "message": "something went wrong, please try again later!"
    };
  }
}
