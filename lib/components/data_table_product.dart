import "package:flutter/material.dart";
import 'package:expandable_datatable/expandable_datatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/components/product_window.dart';
import 'package:stork_uz/modules/classes_modules.dart';

class DataTableProduct extends StatefulWidget {
  const DataTableProduct({
    super.key,
    required this.pref,
    required this.products,
  });

  final SharedPreferences pref;
  final List products;

  @override
  State<DataTableProduct> createState() => _DataTableProductState();
}

class _DataTableProductState extends State<DataTableProduct> {
  List<Products> userList = [];
  late List<ExpandableColumn<dynamic>> headers = [];
  late List<ExpandableRow> rows = [];

  bool _isLoading = true;

  void setLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetch();
  }

  void fetch() async {
    userList = await getUsers();

    createDataSource();

    setLoading();
  }

  Future<List<Products>> getUsers() async {
    print("object");
    print(widget.products);
    List<Products> userAll = [];
    for (var product in widget.products) {
      userAll.add(Products(product['title'], product['price'].toDouble(),product['cost'].toDouble(),product['summary'],product['content']));
    }

    return userAll;
  }

  void createDataSource() {
    headers = [
      ExpandableColumn<int>(columnTitle: "#", columnFlex: 1),
      ExpandableColumn<String>(columnTitle: "Title", columnFlex: 2),
      ExpandableColumn<double>(columnTitle: "Price", columnFlex: 2),
      ExpandableColumn<double>(columnTitle: "Cost", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Summary", columnFlex: 2),
      ExpandableColumn<String>(columnTitle: "Content", columnFlex: 4),
    ];
    int counter = 0;
    rows = userList.map<ExpandableRow>((e) {
      counter++;
      return ExpandableRow(cells: [
        ExpandableCell<int>(columnTitle: "#", value:counter ),
        ExpandableCell<String>(columnTitle: "Title", value: e.name),
        ExpandableCell<double>(columnTitle: "Price", value: e.price),
        ExpandableCell<double>(columnTitle: "Cost", value: e.cost),
        ExpandableCell<String>(columnTitle: "Summary", value: e.summary),
        ExpandableCell<String>(columnTitle: "Content", value: e.content),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: !_isLoading
            ? LayoutBuilder(builder: (context, constraints) {
                int visibleCount = 3;
                if (constraints.maxWidth < 600) {
                  visibleCount = 3;
                } else if (constraints.maxWidth < 800) {
                  visibleCount = 4;
                } else if (constraints.maxWidth < 1000) {
                  visibleCount = 5;
                } else {
                  visibleCount = 6;
                }

                return ExpandableTheme(
                  data: ExpandableThemeData(
                    context,
                    contentPadding: const EdgeInsets.only(left: 4, right: 10),
                    expandedBorderColor: Colors.transparent,
                    paginationSize: 25,
                    headerHeight: 40,
                    paginationBorderWidth: 1,
                    paginationBorderRadius: BorderRadius.circular(10),
                    headerColor: Color(0xFFeeeeee),
                    headerTextStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    rowTextStyle: TextStyle(fontSize: 12),
                    expandedTextStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    expansionIcon: Icon(Icons.expand_more_outlined),
                    headerBorder: const BorderSide(
                      color: Color(0xFFeeeeee),
                      width: 1,
                    ),
                    evenRowColor: const Color(0xFFFFFFFF),
                    oddRowColor: const Color(0xFFFFFFFF),
                    rowBorder: const BorderSide(
                      color: Color(0xFFefefef),
                      width: 1,
                    ),
                    rowColor: Colors.green,
                    headerTextMaxLines: 2,
                    headerSortIconColor: Color.fromARGB(255, 63, 130, 255),
                    paginationSelectedFillColor:
                        Color.fromARGB(255, 63, 130, 255),
                    paginationSelectedTextColor: Colors.white,
                  ),
                  child: ExpandableDataTable(
                    headers: headers,
                    rows: rows,
                    multipleExpansion: false,
                    onRowChanged: (newRow) {
                      print(newRow.cells[01].value);
                    },
                    onPageChanged: (page) {
                      print(page);
                    },
                    renderEditDialog: (row, onSuccess) =>
                        // ProductWindow(),
                    visibleColumnCount: visibleCount,
                    pageSize: 20,
                  ),
                );
              })
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildEditDialog(
      ExpandableRow row, Function(ExpandableRow) onSuccess) {
    return AlertDialog(
      title: SizedBox(
        height: 300,
        child: TextButton(
          child: const Text("Change name"),
          onPressed: () {
            row.cells[1].value = "x3";
            onSuccess(row);
          },
        ),
      ),
    );
  }
}
