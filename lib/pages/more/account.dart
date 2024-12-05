import 'package:eslar/components/AppConfig.dart';
import 'package:eslar/components/button.dart';
import 'package:eslar/components/input.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  TextEditingController name = TextEditingController(text: "João Costa");
  TextEditingController email =
      TextEditingController(text: "joaocosta@gmail.com");
  TextEditingController number =
      TextEditingController(text: "+351 912 123 913");

  Account({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          padding: EdgeInsets.all(AppConfig().radius),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppConfig().backgroundColor,
            borderRadius: BorderRadius.circular(AppConfig().radius),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  textAlign: TextAlign.start,
                  "Conta",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10,),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Input(label: "Nome", controler: name),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Input(label: "Email", controler: email),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Input(
                            label: "Número de Telemóvel", controler: number),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Button(
                            text: "Salvar",
                            func: () {},
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
