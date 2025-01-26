// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:Esolar/components/button.dart';
import 'package:Esolar/pages/auth/login.dart';
import 'package:Esolar/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/components/input.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool invalidData = false;
  List<String> userInfo = [];

  Future<void> Registar() async {
    if(passwordController.text.length < 8){
      setState(() {
        Loading = false;
        invalidData = true;
      });
      return; 
    }

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
        saveUser();
        setState(() {
          Loading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
        });
      }
    } catch (e) {
      print("erro: $e");
    }
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    userInfo.add(firstNameController.text);
    userInfo.add(secondNameController.text);
    userInfo.add(emailController.text);
    await prefs.setStringList('userData', userInfo);
    print("Salvo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConfig().overlayColor,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
                child: Container(
              width: MediaQuery.of(context).size.width * (10 / 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: AppConfig().backgroundColor,
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
                              hiddeChar: true,
                              label: "Palavra-Passe",
                              controler: passwordController),
                        ),
                                                Visibility(
                          visible: invalidData,
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: Center(
                              child: Text(
                                "A palavra-passe deve conter no mínimo 8 caracteres.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Button(
                              loading: Loading,
                              text: "Registar",
                              func: () {
                                setState(() {
                                  Loading = true;
                                });
                                Registar();
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Já tem uma conta?",
                                style: TextStyle(),
                              ),
                              TextButton(
                                isSemanticButton: false,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                      (Route<dynamic> route) => false);
                                },
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                      color: AppConfig().primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
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
