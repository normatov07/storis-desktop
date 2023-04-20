import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/components/auth_components.dart';
import 'package:stork_uz/controllers/account_controller.dart';
import 'package:stork_uz/pages/auth/auth_ui_config.dart';
import 'package:stork_uz/pages/home_page.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({
    Key? key,
    required this.pref,
  }) : super(key: key);

  final SharedPreferences pref;

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKeyAccount = GlobalKey<FormState>();
  bool valid_account = true;
  String account_error = "";
  TextEditingController account = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: LoginCardWith,
      child: Form(
        key: formKeyAccount,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: (!valid_account) ? Colors.red : Color(0xFF6400c2),
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: (!valid_account) ? Colors.red : Color(0xFF8b10fe),
                    width: 0.5,
                  ),
                ),
                hintText: 'Account name',
              ),
              controller: account,
            ),
            Visibility(
              child: ErrorMessageValidator(err: account_error),
              visible: !valid_account,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Color(0xFF2666fa),
                  maximumSize: Size(150, 100),
                  minimumSize: Size(120, 60),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: () async {
                  setState(() {
                    if (account.text.trim() == "") {
                      valid_account = false;
                      account_error = "account is required";
                      return;
                    }else{
                      valid_account = true;
                    }
                  });
                  if (valid_account) {
                    String res = await createAccountReq(account.text.trim(),context);

                    if (res == "success") {
                      widget.pref.setString('message',
                          "Your account was created successfully!");
                      widget.pref.setString('message_type', 'success');
                      widget.pref.setString("route", "product");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            pref: widget.pref,
                          ),
                        ),
                      );
                    }else{
                       valid_account = false;
                      account_error = res;
                    }
                  }
                },
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
