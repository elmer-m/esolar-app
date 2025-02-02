import 'dart:convert';

import 'package:Esolar/pages/auth/register.dart';
import 'package:Esolar/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/components/input.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool Loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController licenseKey = TextEditingController();
  bool invalidData = false;
  String errorText = "";
  Future<void> Entrar() async {
    // Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const Dashboard(),
    //         ),
    //         (Route<dynamic> route) => false,
    //       );
    final url = Uri.parse('https://tze.ddns.net:8108/login.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
      'key': licenseKey.text,
    });
    if (passwordController.text.length < 8) {
      setState(() {
        Loading = false;
        invalidData = true;
        errorText = "A password deve ser ter mais de 8 caracteres.";
      });
    } else if (passwordController.text.length < 8) {
      setState(() {
        Loading = false;
        invalidData = true;
        errorText = "A password deve ser ter mais de 8 caracteres.";
      });
    } else {
      setState(() {
        Loading = false;
        invalidData = false;
        errorText = "";
      });
      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          print("Conetado, ${response.body}");
          if (data['status'] == 1) {
            setState(() {
              invalidData = true;
              Loading = false;
              errorText = "Credenciais Inválidas";
            });
          } else if (data['status'] == 0) {
            print(data['user']);
            saveUser(data['user'], data['company']);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          print("Não conectado, ${response.body}");
        }
      } catch (e) {
        print("Erro: $e");
      }
    }
  }

  Future<void> saveUser(userData, companyData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userInfo = [];
    userInfo.add(userData['firstName']);
    userInfo.add(userData['lastName']);
    userInfo.add(userData['email']);
    userInfo.add(companyData['id'].toString());
    userInfo.add(companyData['name']);
    await prefs.setStringList('userData', userInfo);
    print("Salvo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppConfig().overlayColor,
      child: Center(
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
                  Container(
                    child: Center(
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Input(
                            label: "Id",
                            controler: emailController,
                            type: TextInputType.text,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Input(
                              hiddeChar: true,
                              label: "Palavra-Passe",
                              controler: passwordController),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Input(
                            label: "Chave de Licença",
                            controler: licenseKey,
                            type: TextInputType.text,
                          ),
                        ),
                        Visibility(
                          visible: invalidData,
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: Center(
                              child: Text(
                                errorText,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  Loading = true;
                                  Entrar();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 93, 7, 1),
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
                                : Text("Entrar"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ainda não tem uma conta?",
                                style: TextStyle(),
                              ),
                              TextButton(
                                isSemanticButton: false,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Register(),
                                      ),
                                      (Route<dynamic> route) => false);
                                },
                                child: Text(
                                  "Registar",
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
            ),
          ),
        ),
      ),
    ));
  }
}
