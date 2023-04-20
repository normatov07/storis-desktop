import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/controllers/home_controller.dart';
import 'package:stork_uz/pages/products/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.pref}) : super(key: key);

  final SharedPreferences pref;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String? route = widget.pref.getString("route");
  late String? company_name = widget.pref.getString("company_name");
  late String? email = widget.pref.getString("email");
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Future<void> updateRoute(String newRoute) async {
    setState(() {
      route = newRoute;
      BodyPage = null;
    });
    widget.pref.setString("route", newRoute);
    // fetchName function is a asynchronously
    pageRender(route!, widget.pref, updateRoute, context).then((result) {
      // Once we receive our name we trigger rebuild.
      setState(() {
        BodyPage = result;
      });
    });
  }

  Widget? BodyPage;
  @override
  void initState() {
    super.initState();
    print(route);
    pageRender(route!, widget.pref, updateRoute, context).then((result) {
      setState(() {
        BodyPage = result;
      });
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
          updateRoute('product');
        break;
       case 1:
          updateRoute('account');
        break;
         case 2:
          updateRoute('table');
        break;
         case 3:
          updateRoute('product');
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF001e28),
        title: Text("Computers"),
      ),
      body: Center(
        child: (BodyPage == null) ? const Text("Loading...") : BodyPage!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(color: Color(0xFF999999)),
        selectedIconTheme: IconThemeData(color: Color(0xFFd31649)),
        unselectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        selectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedItemColor: Color(0xFF999999),
        selectedItemColor: Color(0xFFd31649),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
