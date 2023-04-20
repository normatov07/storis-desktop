import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stork_uz/components/auth_components.dart';
import 'package:stork_uz/controllers/auth_controller.dart';
import 'package:stork_uz/pages/auth/login_page.dart';

import 'auth_ui_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key, 
    required this.pref
    }) : super(key: key);

  final SharedPreferences pref;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = true;
  final formGlobalKey = GlobalKey<FormState>();
  bool vaid_email = true;
  bool vaid_password = true;
  bool vaid_conf = true;

  String err_email = "";
  String err_password = "";
  String err_conf = "";
  TextEditingController pass_conn = TextEditingController();
  TextEditingController conf_conn = TextEditingController();
  TextEditingController email_conn = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var customSize = MediaQuery.of(context).size.width;
    double textSizeTitle = 35;
    double textSizeDesc = 18;
    double marginTop = 60;
    //
    if (customSize > medium2SizeLogin && customSize < mediumSizeLogin) {
      textSizeTitle = 35;
      textSizeDesc = 18;
      marginTop = 70;
      LoginCardWith = 420.0;
    } else if (customSize > mobileSizeLogin && customSize < medium2SizeLogin) {
      LoginCardWith = 420.0;
    } else if (customSize < mobileSizeLogin) {
      textSizeTitle = 27;
      textSizeDesc = 15;
      LoginCardWith = 300;
      marginTop = 120;
    } else {
      LoginCardWith = 420.0;
      textSizeTitle = 35;
      textSizeDesc = 18;
      marginTop = 60;
    }

    ///==== For alert message =====
    showAlert(context);
    
    return Scaffold(
        body: Container(
      color: const Color(0xFFffffff),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          if (customSize > mediumSizeLogin)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/icons/login_left.png"),
                      fit: BoxFit.cover)),
              child: const Align(
                child: Text(""),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xFFffffff),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: marginTop,
                      ),
                      Container(
                        width: LoginCardWith,
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hello ! Welcome.",
                                style: TextStyle(
                                    fontSize: textSizeTitle,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Text(""),
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: LoginCardWith,
                        child: Text(
                          "Cheers! We are happy to see you our registr page.",
                          style: TextStyle(
                              fontSize: textSizeDesc,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF7e789a)),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),

                      ///======= Start Email Field ======
                      Container(
                        width: LoginCardWith,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Email address",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: LoginCardWith,
                        height: 45,
                        decoration:
                            BoxDecoration(color: const Color(0xFFffffff), boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                        child: TextFormField(
                          controller: email_conn,
                          style: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.emailAddress,
                          decoration:  InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      (!vaid_email) ? Colors.red : Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      (!vaid_email) ? Colors.red : Colors.white,
                                  width: 0.0,
                                ),
                              ),
                              hintText: "example@gmail.com",
                              hintStyle: const TextStyle(
                                  color: Color(0xFFcecece),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                      Visibility(
                        child: ErrorMessageValidator(err: err_email),
                        visible: !vaid_email,
                      ),

                      ///======= end Email Field ======

                      ///======= Start Password Field ======
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: LoginCardWith,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: LoginCardWith,
                        height: 45,
                        decoration:
                            BoxDecoration(color: const Color(0xFFffffff), boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                        child: TextFormField(
                          controller: pass_conn,
                          style: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.text,
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                              suffixIconColor: const Color(0xFFcecece),
                              suffixIcon: IconButton(
                                iconSize: 17,
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: (!vaid_password)
                                      ? Colors.red
                                      : Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: (!vaid_password)
                                      ? Colors.red
                                      : Colors.white,
                                  width: 0.0,
                                ),
                              ),
                              hintText: "enter password",
                              hintStyle: const TextStyle(
                                  color: Color(0xFFcecece),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                      Visibility(
                        child: ErrorMessageValidator(err: err_password),
                        visible: !vaid_password,
                      ),

                      ///======= End Password Field ======
                      ///======= Start Confirm Password Field =====
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: LoginCardWith,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Confirm Password",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: LoginCardWith,
                        height: 45,
                        decoration:
                            BoxDecoration(color: const Color(0xFFffffff), boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                        child: TextFormField(
                          controller: conf_conn,
                          style: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            suffixIconColor: const Color(0xFFcecece),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (!vaid_conf) ? Colors.red : Colors.white,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (!vaid_conf) ? Colors.red : Colors.white,
                                width: 0.0,
                              ),
                            ),
                            hintText: "confirm password",
                            hintStyle: const TextStyle(
                                color: Color(0xFFcecece),
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Visibility(
                        child: ErrorMessageValidator(err: err_conf),
                        visible: !vaid_conf,
                      ),

                      ///======= End Confirm Password Field =====
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: LoginCardWith,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: const Color(0xFF2666fa),
                          ).copyWith(
                              elevation: ButtonStyleButton.allOrNull(0.0)),
                          onPressed: () async {
                            setState(()  {
                              if (email_conn.text == "") {
                                vaid_email = false;
                                err_email = "email filed is required";
                              } else if (!email_conn.text.contains('@')) {
                                vaid_email = false;
                                err_email = "email data is invalid";
                              } else {
                                vaid_email = true;
                              }
                              if (pass_conn.text == "") {
                                vaid_password = false;
                                err_password = "password filed is required";
                              } else if (pass_conn.text.length < 6) {
                                vaid_password = false;
                                err_password =
                                    "password filed must be least 6 character";
                              } else {
                                vaid_password = true;
                              }
                              if (conf_conn.text == "") {
                                vaid_conf = false;
                                err_conf = "confirm password filed is required";
                              } else if (conf_conn.text.length < 6) {
                                vaid_conf = false;
                                err_conf =
                                    "confirm password filed must be least 6 characters";
                              } else {
                                vaid_conf = true;
                              }
                              if (vaid_conf && vaid_password) {
                                if (pass_conn.text != conf_conn.text) {
                                  vaid_password = false;
                                  err_password =
                                      "password and confirm password must be the same data";
                                }
                              }

                            });

                            if (vaid_conf && vaid_password && vaid_email) {
                              //TODO: send request to auth api
                              var res = await sendRegisterRequest(email_conn.text,pass_conn.text,widget.pref,context);
                              print(res);
                              if (res == "success") {
                                widget.pref.setString('message', "Congratulation!!! you have registered successfully. You can login to your account");
                                widget.pref.setString('message_type', 'success');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(pref: widget.pref,),
                                  ),
                                );
                              }else{
                                setState((){
                                  vaid_email= false;
                                  err_email =res;
                                });
                              }
                            }

                          },
                          child: const Text(
                            'Start now !',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                            width: LoginCardWith,
                            child: const Divider()),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 45,
                          width: LoginCardWith,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xFFffffff),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/icons/google.png",
                                  height: 40,
                                ),
                              ),
                              const Text("Sign up with Google")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Container(
                        width: LoginCardWith,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 13.5),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(pref: widget.pref),
                                  ),
                                );
                              },
                              child: const Text(
                                " Sign in",
                                style: TextStyle(
                                    color: Color(0xFF5d8cfb), fontSize: 13.5),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ]),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    ));
  }
}
