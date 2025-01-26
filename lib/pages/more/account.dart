import 'dart:convert';

import 'package:Esolar/components/AppConfig.dart';
import 'package:Esolar/components/button.dart';
import 'package:Esolar/components/input.dart';
import 'package:Esolar/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController name = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController number = TextEditingController(text: "");
  String oldEmail = "";
  Map<String, String> userData = {
    'firstName': '',
    'email': '',
  };
  Future<void> Edit() async {
    final url = Uri.parse('https://tze.ddns.net:8108/editAccount.php');
    try {
      setState(() {
        loading = true;
      });
      var request = http.MultipartRequest('POST', url);
      request.fields['emailEdit'] = email.text;
      request.fields['name'] = name.text;
      request.fields['email'] = oldEmail;

      var streamResponse = await request.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print("Deu certo:  ${response.body}");
        var dataa = jsonDecode(response.body);
        Navigator.pop(context, '.');
        saveUser();
      } else {
        print("Deu errado, erro: ${response.statusCode}");
        print("Resposta: ${response.body}");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Erro na requisição: $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userInfo = [];
    userInfo.add(name.text);
    userInfo.add("");
    userInfo.add(email.text);
    await prefs.setStringList('userData', userInfo);
    print("Salvo");
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('userData');

    if (success) {
      print("Dados apagados com sucesso!");
    } else {
      print("Falha ao apagar os dados.");
    }
  }

  bool loading = true;
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getStringList('userData');

    setState(() {
      userData['firstName'] = user![0];
      print(user);
      oldEmail = user[2];
      name.text = user[0];
      email.text = user[2];
      loading = false;
      print(user);
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().overlayColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConfig().radius),
              color: AppConfig().overlayColor),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Conta",
                          style: TextStyle(
                              color: AppConfig().textColorW,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmação"),
                                  content: Text(
                                      "Tem certeza que deseja sair da conta?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Não", style: TextStyle(color: AppConfig().primaryColor),)),
                                    TextButton(
                                        onPressed: () {
                                          deleteUser();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Login(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: Text("Sim", style: TextStyle(color: AppConfig().primaryColor),)),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          child: Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                            size: 40,
                          ),
                          margin: const EdgeInsets.only(bottom: 30),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConfig().radius),
                      color: AppConfig().backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Input(label: "Nome", controler: name),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Input(label: "Email", controler: email),
                        ),
                        Container(
                          child: Button(
                            text: "Guardar",
                            func: () => Edit(),
                          ),
                          width: double.infinity,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
