
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/pages/auth/login_page.dart';
import 'package:stork_uz/pages/home_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: Environment.envFilePath);

  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('route', 'product');

  runApp(MyApp(pref: pref));
}

class MyApp extends StatelessWidget {
   MyApp({Key? key, required this.pref}) : super(key: key);
  // This widget is the root of your application.
  final SharedPreferences pref;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop uz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(pref: pref),
    );
  }
}


class Environment{
  static String get envFilePath => kReleaseMode ? ".env.prod" : ".env.dev";
}
