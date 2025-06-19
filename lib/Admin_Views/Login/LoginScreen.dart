import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gopaljewellers/views/login/login_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../provider/admin_provider.dart';
import '../Home/HomeScreen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var passwordCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? password;

  handleSignIn() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    await ab.ResetGuestAdmin();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (password == "tester") {
        // await ab.setSignInForTesting().then((value) {
        //   Navigator.pushReplacement(context,
        //       CupertinoPageRoute(builder: (context) => const AdminHome()));
        // });
      } else if (password == "guest") {
        // await ab.setSignInForGuestAdmin().then((value) {
        //   Navigator.pushReplacement(context,
        //       CupertinoPageRoute(builder: (context) =>  const AdminHome()));
        // });
      } else {
        await ab.setSignIn().then((value) => Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const AdminHome())));
      }
    }
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => PhoneView()));

        return false;
      },
      child: Scaffold(
          backgroundColor: black,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Welcome to Admin Panel',
                    style: TextStyle(
                        fontSize: 30,
                        color: white,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: passwordCtrl,
                          obscureText: true,
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Password',
                            hintStyle: TextStyle(color: grey),
                            labelStyle: TextStyle(color: grey),
                            contentPadding:
                                const EdgeInsets.only(right: 0, left: 10),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                    icon: const Icon(Icons.close, size: 15),
                                    onPressed: () {
                                      passwordCtrl.clear();
                                    }),
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            String? adminPassword = ab.adminPass;
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            } else if (value != adminPassword &&
                                value != "tester" &&
                                value != "guest") {
                              return 'Wrong Password! Please try again.';
                            }

                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              password = value;
                            });
                          },
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 45,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: white,
                              blurRadius: 10,
                              offset: const Offset(2, 2))
                        ]),
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      onPressed: () => handleSignIn(),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
