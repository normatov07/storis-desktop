import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/constants.dart';
import 'package:stork_uz/controllers/account_controller.dart';
import 'package:stork_uz/controllers/home_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
    required this.updateRoute,
    required this.pref,
    required this.listAccounts,
  }) : super(key: key);

  final Function updateRoute;
  final SharedPreferences pref;
  final Map<String, dynamic> listAccounts;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<bool> selected = [];
  List<bool> selected1 = [];

  @override
  void initState() {
    super.initState();

    selected = List<bool>.generate(
        widget.listAccounts['invites'].length, (int index) => false);
    selected1 = List<bool>.generate(
        widget.listAccounts['accounts'].length, (int index) => false);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.listAccounts['accounts']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ((widget.listAccounts['invites'].length==0 &&
                            widget.listAccounts['accounts'].length ==0))
            ? GestureDetector(
                onTap: () {
                  widget.updateRoute("account/create");
                },
                child: Container(
                    margin: EdgeInsets.only(top: 50),
                    color: Color.fromARGB(255, 75, 75, 75),
                    width: 200,
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      "Create account",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    )),
              )
            : Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "Accounts",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Your accounts",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    border: Border.all(color: const Color(0xFFdcdcdc)),
                  ),
                  width: DataTableWidth,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Name',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Currency',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Action',
                          ),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        (widget.listAccounts['accounts'].length), (index) {
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          // All rows will have the same selected color.
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.08);
                          }
                          // Even rows will have a grey color.
                          if (index.isEven) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Use default value for other states and odd rows.
                        }),
                        cells: <DataCell>[
                          DataCell(Text(widget.listAccounts['accounts'][index]
                                      ['company_name'] ==
                                  null
                              ? ""
                              : widget.listAccounts['accounts'][index]
                                  ['company_name']!)),
                          DataCell(Text(widget.listAccounts['accounts'][index]
                                      ['currency'] ==
                                  null
                              ? ""
                              : widget.listAccounts['accounts'][index]
                                  ['currency']!)),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color(0xFF3498db), // foreground
                                ),
                                child: Text("Enter"),
                                onPressed: () async {
                                  String resp = await enterAccount(widget.listAccounts['accounts'][index]['id'],context);
                                  if (resp == "success"){
                                      widget.pref.setString('message', "you are in account!");
                                      widget.pref.setString('message_type', 'success');
                                      widget.updateRoute('product');
                                  }else{
                                     showMessage(context, "error", resp);
                                  }
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                      255, 207, 0, 97), // foreground
                                ),
                                child: Text("Delete"),
                                onPressed: () {
                                  print("fff");
                                },
                              ),
                            ],
                          )),
                        ],
                        selected: selected1[index],
                        onSelectChanged: (bool? value) {
                          setState(() {
                            selected1[index] = value!;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ]),
        const SizedBox(
          height: 25,
        ),
        const Text(
          "Your invitations",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            border: Border.all(color: const Color(0xFFdcdcdc)),
            boxShadow: [
              // BoxShadow(
              //   color: const Color(0xFF5800a3).withOpacity(0.5),
              //   spreadRadius: 5,
              //   blurRadius: 6,
              //   offset: const Offset(0, 5), // changes position of shadow
              // ),
            ],
          ),
          width: DataTableWidth,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Name',
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Currency',
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Action',
                  ),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              (widget.listAccounts['invites'].length),
              (index) => DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  // All rows will have the same selected color.
                  if (states.contains(MaterialState.selected)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08);
                  }
                  // Even rows will have a grey color.
                  if (index.isEven) {
                    return Colors.grey.withOpacity(0.3);
                  }
                  return null; // Use default value for other states and odd rows.
                }),
                cells: <DataCell>[
                  DataCell(Text(widget.listAccounts['invites'][index]
                              ['company_name'] ==
                          null
                      ? ""
                      : widget.listAccounts['invites'][index]
                          ['company_name']!)),
                  DataCell(Text(
                      widget.listAccounts['invites'][index]['currency'] == null
                          ? ""
                          : widget.listAccounts['invites'][index]
                              ['currency']!)),
                  DataCell(Text("Actions")),
                ],
                selected: selected[index],
                onSelectChanged: (bool? value) {
                  setState(() {
                    selected[index] = value!;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
