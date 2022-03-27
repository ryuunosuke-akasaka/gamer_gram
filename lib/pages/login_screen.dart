import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamer_gram/pages/home_page.dart';
import 'package:gamer_gram/pages/signup_screen.dart';
import 'package:gamer_gram/pages/web_page.dart';
import 'package:gamer_gram/resources/auth_method.dart';
import 'package:gamer_gram/util/colors.dart';
import 'package:gamer_gram/util/utils.dart';
import 'package:gamer_gram/widget/responsive_widget.dart';
import 'package:gamer_gram/widget/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveWidget(
              webScreenLayout: WebScreen(), mobileScreenLayout: HomePage())));
    } else {
      //
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            //svg image
            SvgPicture.asset(
              "lib/assets/gg.svg",
              color: Colors.white,
              height: 100,
              width: 100,
            ),
            //textfield inp for email
            TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your Email",
              textInputType: TextInputType.emailAddress,
            ),
            //pass
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
              textEditingController: _passController,
              hintText: "Enter your Password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),

            InkWell(
              onTap: loginUser,
              child: Container(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.red,
                      )
                    : const Text("Login"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    )),
              ),
            ),

            Flexible(
              child: Container(),
              flex: 2,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text("Don't have an account"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Container(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            )
            //button for login
            //signup/do you remember your passowrd
          ],
        ),
      ),
    ));
  }
}
