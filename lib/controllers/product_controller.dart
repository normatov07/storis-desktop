
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/constants.dart';
import 'package:stork_uz/controllers/home_controller.dart';


Future<Map> getProducts(int category_id,int parent_id, int page, context) async {
  try {
     SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " +  pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json','Authorization':bearer};
    var request = http.Request(
        'GET', Uri.parse(dotenv.get('API_HOST') + '/store/product/'));
    request.body = json.encode(
                                {
                                  "category_id": category_id,
                                  "parent_id": parent_id, 
                                  "limit": productLimit, 
                                  "page":page
                                }
                              );
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      try {
        // print("response: "+await res.stream.bytesToString());
        var data = await res.stream.bytesToString();
        var resArr = jsonDecode(data);

       return {"data":(resArr==null)?[]:resArr,"message":"success"};
      } catch (e) {
        print(e.toString());
        return {"data":[],"message":"something went wrong, please try again later!"};
      }
    } else if (res.statusCode == 403) {
      return {"data":[],"message":"the data format is not suitable!"};
    }else if (res.statusCode == 401){
      renderLoginPage(pref,context);
      return {"data":[],"message":"something went wrong, please try again later!"};
    }  else {
      print(await res.stream.bytesToString());
      return {"data":[],"message":"something went wrong, please try again later!"};
    }

  } catch (e) {
    print("error: " + e.toString());
    return {"data":[],"message":"something went wrong, please try again later!"};
  }
}
// type CreateProductRequest struct {
// 	Title   string `json:"title" binding:"required"`
// 	Summary string `json:"summary" binding:"required"`
// 	Type    int16  `json:"type" binding:"required"`
// 	Content string `json:"content" binding:"required"`
// }
Future<Map> createProduct(String title, String summary,
int category_id, String content, List metas, double cost, double price,context) async {
  try {
    List real_meta = [];
    for (var i = 0; i < metas.length; i++) {
      real_meta.add({"title":metas[i].title, "id":metas[i].id});
    }
    // print(category_id);
    // print(real_meta);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? bearer = "Bearer " + pref.getString("access_token")!;

    var headers = {'Content-Type': 'application/json', 'Authorization': bearer};
    var request =
        http.Request('POST', Uri.parse(dotenv.get('API_HOST') + '/store/product/create'));
    request.body = json.encode({
      "title": title,
      "summary": summary,
      "type":1,
      "category_id":category_id,
      "content":content,
      "metas": real_meta,
      "cost":cost,
      "price":price
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
      return {"data": [], "message": "something went wrong, please try again later!"};
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