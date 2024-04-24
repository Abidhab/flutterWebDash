import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../overview/overview.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String adminEmail = "";
  String adminPass = "";

  allowAdminToLogin() async {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Checking Credentials, Please wait',
        style: TextStyle(fontSize: 36, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: adminEmail,
      password: adminPass,
    )
        .then((fAuth) => currentAdmin = fAuth.user)
        .catchError((onError) {
      final snackBar = SnackBar(
        content: Text(
          'Error Occured' + onError.toString(),
          style: TextStyle(fontSize: 36, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(currentAdmin!.uid)
          .get()
          .then((snap) {
        if (snap.exists) {
          print('Document found, navigating to HomeScreen...');
          Get.offNamed(overviewPageRoute);
        } else {
          print('No record found');
          SnackBar snackBar = SnackBar(
            content: Text(
              'No Record Found',
              style: TextStyle(fontSize: 36, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        print('Error: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Container(
                        height: 180,
                        width: 350,
                        child: Image.asset("assets/icons/Nlogo.png")),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text("Login",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  CustomText(
                    text: "Welcome back to the admin panel.",
                    color: lightGrey,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    adminEmail = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "abc@domain.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    adminPass = value;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "123",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const CustomText(
                        text: "Remember Me",
                      ),
                    ],
                  ),
                  const CustomText(
                      text: "Forgot password?", color: active)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  allowAdminToLogin();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const CustomText(
                    text: "Login",
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: const TextSpan(children: [
                    TextSpan(text: "Do not have admin credentials? "),
                    TextSpan(
                        text: "Request Credentials! ", style: TextStyle(color: active))
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
