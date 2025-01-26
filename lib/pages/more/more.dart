import 'package:Esolar/components/button.dart';
import 'package:Esolar/components/toPage.dart';
import 'package:Esolar/pages/auth/login.dart';
import 'package:Esolar/pages/more/about.dart';
import 'package:Esolar/pages/more/config.dart';
import 'package:Esolar/pages/more/account.dart';
import 'package:Esolar/pages/more/projectsFinisheds.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/components/AppConfig.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig().radius),
        ),
        child: Column(
          children: [
                            Container(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                width: double.infinity,
                child: Text(
                  "Mais",
                  style: TextStyle(
                      color: AppConfig().textColorW,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
            ToPage(page: Config(), pageLabel: "Definições"),
            ToPage(page: Account(), pageLabel: "Conta"),
            Spacer(),          
          ],
        ),
      ),
    );
  }
}
