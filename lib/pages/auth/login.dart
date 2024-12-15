import 'dart:convert';

import 'package:eslar/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/input.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool Loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
    });
    if(passwordController.text.length < 8 ){
      setState(() {
        Loading = false;
        invalidData = true;
        errorText = "A password deve ser ter mais de 8 caracteres.";
      });
    } else if(emailController.text.length < 8 ){
      setState(() {
        Loading = false;
        invalidData = true;
        errorText = "A password deve ser ter mais de 8 caracteres.";
      });
    }
    else {
      try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print("Conetado, ${response.body}");
        if(data['status'] == 1){
          setState(() {
            invalidData = true;
            Loading = false;
          });
        } else if (data['status'] == 0){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(255, 93, 7, 1),
          ),
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
                          child:
                              Input(label: "Email", controler: emailController, type: TextInputType.emailAddress,),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Input(
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
                              child: Text(errorText,
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
