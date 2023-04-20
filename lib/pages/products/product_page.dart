import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/components/data_table_product.dart';
import 'package:stork_uz/controllers/category_controller.dart';
import 'package:stork_uz/controllers/home_controller.dart';
import 'package:stork_uz/controllers/product_controller.dart';
import 'package:stork_uz/modules/test_modules.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ProductPage extends StatefulWidget {
  ProductPage({
    super.key,
    required this.c_parents,
    required this.c_childs,
    required this.products,
    required this.pref,
  });

  final List c_parents;
  final SharedPreferences pref;
  List c_childs;
  List products;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  // final dragController = DragController();
  bool statusBar = false;
  var cat_row = 3;
  var pro_row = 4;
  String activeIndexCard = '-1';
  int activeIndexCategory = -1;
  int activeIndexSubCategory = -1;

  Future<void> refreshOrder(newChild) async {
    for (var i = 0; i < orders.length; i++) {
      if (orders[i]['id'] == newChild['id']) {
        setState(() {
          orders[i]['multiples'] += 1;
        });
        return;
      }
    }
    setState(() {
      orders.add(newChild);
    });
  }

  Future<void> selectableCard(index) async {
    setState(() {
      activeIndexCard = index;
    });
  }

  Future<void> refreshCategory(index) async {
    setState(() {
      activeIndexCategory = index;
    });
    Map subCategories =
        await getSubCategories(widget.c_parents[index]['id'], context);
    if (subCategories['message'] == "success") {
      setState(() {
        if (subCategories['data'].length == 0) {
          activeIndexSubCategory = -1;
        } else {
          activeIndexSubCategory = 0;
        }
        widget.c_childs = subCategories['data'];
      });
    } else {
      showMessage(context, 'error', "error while getting data!");
    }
    if (subCategories['data'].length != 0) {
      // print("Sub ID:");
      // print(subCategories['data'][0]['id']);
      Map products = await getProducts(subCategories['data'][0]['id'],
          widget.c_parents[index]['id'], 1, context);
      if (products['message'] == "success") {
        setState(() {
          widget.products = products['data'];
        });
      } else {
        showMessage(context, 'error', "error while getting data!");
      }
    } else {
      setState(() {
        widget.products = [];
      });
    }
  }

  Future<void> refreshSubCategory(index) async {
    setState(() {
      activeIndexSubCategory = index;
    });
    if (widget.c_childs.isNotEmpty) {
      Map products = await getProducts(
          widget.c_childs[index]['id'],
          (activeIndexCategory < 0)
              ? 0
              : widget.c_parents[activeIndexCategory]['id'],
          1,
          context);

      if (products['message'] == "success") {
        setState(() {
          widget.products = products['data'];
        });
      } else {
        showMessage(context, 'error', "error while getting data!");
      }
    } else {
      setState(() {
        widget.products = [];
      });
    }
  }

  Future<void> actionsProduct(String type, int index, Map child) async {
    switch (type) {
      case 'insert':
        setState(() {
          widget.products.insert(index, child);
        });
        break;
    }
  }

  Future<void> actionsCategory(String type, int index, Map child) async {
    switch (type) {
      case 'insert':
        setState(() {
          widget.c_parents.insert(index, child);
        });
        break;
    }
  }

  Future<void> actionSubCategory(String type, int index, Map child) async {
    switch (type) {
      case 'insert':
        setState(() {
          widget.c_childs.insert(index, child);
        });
        break;
    }
  }

  // categoryList.add(CreateIconButtonCategory(
  //   actionsCategory: actionsCategory,
  //   parentContext: context,
  // ));
  late TabController rightPnlTabController;
  late var services = widget.c_childs;

  @override
  void initState() {
    super.initState();

    rightPnlTabController =
        TabController(vsync: this, length: widget.c_childs.length);
    //Controll1 = rightPnlTabController;
  }

  @override
  void dispose() {
    rightPnlTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Category List Generate
    late List<Widget> categoryList = List.generate(
      (widget.c_parents.length),
      (index1) {
        return InkWell(
          splashColor: Colors.green,
          onTap: () {
            refreshCategory(index1);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration:BoxDecoration(
                    color: const Color(0xFFffffff),
                    border:  (index1 == activeIndexCategory)?Border(
                      bottom: BorderSide(width: 3, color: const Color.fromARGB(255, 233, 59, 105)),
                    ):null,
                  ),
            margin: const EdgeInsets.only(right: 2, left: 2),
            child: Text(
                widget.c_parents[index1]['title'].toString().toUpperCase() ??
                    "",
                style:TextStyle(
                    color: (index1 == activeIndexCategory)
                        ? const Color.fromARGB(255, 233, 59, 105)
                        : const Color(0xFF5d6466),
                    fontSize: 12, fontWeight: FontWeight.bold,),),
          ),
        );
      },
    );

 /// SubCategory List Generate
    late List<Widget> subCategoryList = List.generate(
      (widget.c_childs.length),
      (index1) {
        return InkWell(
          splashColor: Colors.green,
          onTap: () {
            refreshSubCategory(index1);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                    color: const Color(0xFFffffff),
                    border:  (index1 == activeIndexSubCategory)?Border(
                      bottom: BorderSide(width: 3, color: const Color.fromARGB(255, 233, 59, 105)),
                    ):null,
                  ),
            margin: const EdgeInsets.only(right: 2, left: 2),
            child: Text(
                widget.c_childs[index1]['title'].toString().toUpperCase() ??
                    "",
                style: TextStyle(
                    color: (index1 == activeIndexSubCategory)
                        ? const Color.fromARGB(255, 233, 59, 105)
                        : const Color(0xFF5d6466),
                    fontSize: 12, fontWeight: FontWeight.bold,),),
          ),
        );
      },
    );


    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFffffff),
      child: Column(
        children: [
          ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categoryList,
                  ),
                ),
              ),
            ),
          ),
          
           ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: subCategoryList,
                  ),
                ),
              ),
            ),
          ),
          


          Divider(
            thickness: 1,
            height: 1,
            color: const Color.fromARGB(255, 219, 218, 218).withOpacity(0.7),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: DataTableProduct(pref: widget.pref,products: widget.products,)
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus
        // etc.
      };
}
