// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:eslar/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/input.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool Loading = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> Registar() async {
    final url = Uri.parse('https://tze.ddns.net:8108/newUser.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'firstName': firstNameController.text,
      'lastName': secondNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Conectou, ${response.body}");
        setState(() {
          Loading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Dashboard(),),);
        });
      }
    } catch (e) {
      print("erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConfig().primaryColor,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
                child: Container(
              width: MediaQuery.of(context).size.width * (10 / 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 233, 233),
                borderRadius: BorderRadius.circular(AppConfig().radius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Container(
                            child: Input(
                                label: "Primeiro Nome",
                                controler: firstNameController)),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Input(
                                label: "Segundo Nome",
                                controler: secondNameController)),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child:
                              Input(label: "Email", controler: emailController),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Input(
                              label: "Palavra-Passe",
                              controler: passwordController),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Registar();
                              setState(() {
                                Loading = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConfig().primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppConfig().radius),
                              ),
                            ),
                            child: Loading
                                ? FittedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text("Registar"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ));
  }
}
