import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:stork_uz/controllers/home_controller.dart';
import 'package:stork_uz/controllers/product_controller.dart';
import 'package:stork_uz/modules/classes_modules.dart';
import 'package:stork_uz/modules/test_modules.dart';

class ProductWindow extends StatefulWidget {
  const ProductWindow({super.key, required this.currentCategory, required this.categories, required this.actionsProduct, required this.parentContext});

  final Map currentCategory;
  final List categories;
  final Function actionsProduct;
  final BuildContext parentContext;

  @override
  State<ProductWindow> createState() => _ProductWindowState();
}

class _ProductWindowState extends State<ProductWindow> {
  TextEditingController title = TextEditingController();
  TextEditingController summary = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController content = TextEditingController();
  final _formKey3 = GlobalKey<FormState>();
  List<ParentCat> _selectedMeta = [];

  @override
  Widget build(BuildContext context) {
    late ParentCat currentP = ParentCat(
      (widget.currentCategory['title'] != null)
          ? widget.currentCategory['title']
          : "",
      (widget.currentCategory['id'] != null) ? widget.currentCategory['id'] : 0,
    );

    late List<ParentCat> parentList = List.generate(
      (widget.categories.length),
      (index) {
        return ParentCat(
          widget.categories[index]['title'],
          widget.categories[index]['id'],
        );
      },
    );
    // if (widget.currentParent['title'] == null) {
    parentList.insert(0, currentP);

  List<ParentCat> metasList = List.generate(
    (metas.length),
    (index) {
      return ParentCat(
        metas[index]['title'],
        metas[index]['id'],
      );
    },
  );
  final _items = metasList
      .map((animal) => MultiSelectItem<ParentCat>(animal, animal.title))
      .toList();



    return Container(
      child: AlertDialog(
                content: Stack(
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey3,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Create Product",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: TextFormField(
                                controller: title,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  // prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "title field is required";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: TextFormField(
                                controller: summary,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Summary',
                                  // prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "summary field is required";
                                  }

                                  return null;
                                },
                              ),
                            ),
                               Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: TextFormField(
                                controller: cost,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cost',
                                  // prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "cost field is required";
                                  }

                                  return null;
                                },
                              ),
                            ),
                               Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: TextFormField(
                                controller: price,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Price',
                                  // prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "price field is required";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 10),
                                child: DropdownButtonFormField(
                                  validator: (ParentCat? value) {
                                    if (value?.id == 0) {
                                      return "category field is required";
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Category",
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //       color: Color(0xFF6400c2), width: 1),
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //       color: Color(0xFF6400c2), width: 1),
                                    // ),
                                    filled: true,
                                    // fillColor: Colors.greenAccent,
                                  ),
                                  // dropdownColor: Colors.greenAccent,
                                  value: currentP,
                                  onChanged: (ParentCat? newValue) {
                                    setState(() {
                                      currentP = newValue!;
                                    });
                                  },
                                  items: parentList.map((ParentCat parent) {
                                    return DropdownMenuItem<ParentCat>(
                                      value: parent,
                                      child: Text(
                                        parent.title,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top:15),
                                child: Column(
                                  children: [
                                    MultiSelectDialogField(
                                      validator: (value) {
                                        if(_selectedMeta == [] || _selectedMeta.isEmpty)return "Meta is required!";
                                        return null;
                                      },
                                      items: _items,
                                      title: Text("Metas"),
                                      selectedColor: Colors.blue,
                                      decoration: BoxDecoration(
                                        color: Colors.black12.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4),),
                                        border: Border.all(
                                          color: Colors.white12,
                                          width: 1,
                                        ),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.arrow_drop_down,
                                        // color: Colors.blue,
                                      ),
                                      buttonText: Text(
                                        "Metas",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onConfirm: (List<ParentCat> results) {
                                        setState(() {
                                        _selectedMeta=[];
                                        for (var i = 0; i < results.length; i++) {
                                          _selectedMeta.add(ParentCat(results[i].title, results[i].id));
                                        }
                                        });
                                           print(_selectedMeta);
                                        //_selectedAnimals = results;
                                      },
                                    ),
                                    _selectedMeta == null ||
                                            _selectedMeta.isEmpty
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "None selected",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ))
                                        : Container(),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: TextFormField(
                                minLines: 6,
                                maxLines: null,
                                controller: content,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Content',
                                  // prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "content field is required";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Container(
                              // margin: const EdgeInsets.only(top: 8.0,left: 0),
                              child: ElevatedButton(
                                child: const Text("Save"),
                                onPressed: () async {
                                  if (_formKey3.currentState!.validate()) {
                                     double ct;
                                    double pr;
                                    try{
                                      ct = double.parse(cost.text);
                                      pr = double.parse(price.text);
                                    }catch(e){
                                      showMessage(widget.parentContext, "error","cost or price is not number");
                                      return;
                                    }
                                    Map res = await createProduct(
                                        title.text,
                                        summary.text,
                                        currentP.id,
                                        content.text,
                                        _selectedMeta,
                                        ct,
                                        pr,
                                        context,
                                        );
                                    if (res['message'] == "success") {
                                      widget.actionsProduct(
                                          'insert', 0, res['data']);
                                      Navigator.of(context).pop();
                                      title.clear();
                                      summary.clear();
                                      content.clear();
                                      cost.clear();
                                      price.clear();

                                      showMessage(widget.parentContext,
                                          'success', "New product added!");
                                    } else {
                                      showMessage(widget.parentContext, 'error',
                                          res['message']);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}