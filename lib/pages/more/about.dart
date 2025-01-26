import 'package:Esolar/components/toPage.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/components/AppConfig.dart';

class About extends StatelessWidget {
  const About({super.key});

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
          child: Column(children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 40),
              child: const Text(
                textAlign: TextAlign.start,
                "Sobre",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ToPage(page: About(), pageLabel: "Politica de Privacidade"),
                    ToPage(page: About(), pageLabel: "Termos e Condições"),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
