

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/components/data_table_product.dart';
import 'package:stork_uz/controllers/account_controller.dart';
import 'package:stork_uz/controllers/category_controller.dart';
import 'package:stork_uz/controllers/product_controller.dart';
import 'package:stork_uz/controllers/user_controller.dart';
import 'package:stork_uz/pages/account/account_page.dart';
import 'package:stork_uz/pages/account/create_account.dart';
import 'package:stork_uz/pages/auth/login_page.dart';
import 'package:stork_uz/pages/auth/register_page.dart';
import 'package:stork_uz/pages/products/product_page.dart';

Future<Widget> pageRender(String route, SharedPreferences pref, Function updateRoute, context) async {
  print("page renderr");
  switch (route) {
     case "product":
      Map category = await getCategories(context);
      Map product = await getProducts(0, 0, 1,context);
      // print(category);
      // print(product);
      return ProductPage( 
                          c_parents:(category['data']['parent'] != null)?category['data']['parent']:[], 
                          c_childs:(category['data']['child'] != null)?category['data']['child']:[],
                          products: (product['data'] != null)?product['data']:[],
                          pref: pref,
                        );
      break;
    case "account":
      Map<String, dynamic> accs = await getAccountList(context);
      return AccountPage(updateRoute: updateRoute,pref: pref, listAccounts: accs,);
      break;
    case "account/create":
      return CreateAccount(pref: pref,);
      break;
    // case "user":
    //   List accounts = await getUserAccounts();
    //   return UserPage(userAccounts: accounts,);
    //   break;
    case "login":
      return LoginPage(pref: pref);
    case "register":
      return RegisterPage(pref: pref);

    default:
      Map<String, dynamic> accs = await getAccountList(context);
      return Text("HI");
      // return AccountPage(updateRoute: updateRoute,pref: pref,listAccounts: accs,);
  }
}

String reqireAccessToken(SharedPreferences pref,context){
    String? token = pref.getString('access_token');
    if (token == null){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(
              pref: pref,
            ),
          ),
        );
        return "";
    }

    return token!;
}


void showMessage(context,String messType, String mess) async {
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
        animationType:  AnimationType.fromTop,
        borderRadius: 5,
        autoDismiss: true,
      ).show(context);
    }
}

void renderLoginPage(SharedPreferences pref,context){
      pref.setString('message', "Welcome back! you are logged in successfully.");
      pref.setString('message_type', 'success');
      pref.setString('route', 'login');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(
              pref: pref,
            ),
          ),
        );
}