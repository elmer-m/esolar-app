import 'package:eslar/components/button.dart';
import 'package:eslar/components/toPage.dart';
import 'package:eslar/pages/auth/login.dart';
import 'package:eslar/pages/more/about.dart';
import 'package:eslar/pages/more/config.dart';
import 'package:eslar/pages/more/account.dart';
import 'package:eslar/pages/more/projectsFinisheds.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

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
            ToPage(page: Config(), pageLabel: "Definições"),
            ToPage(page: Account(), pageLabel: "Conta"),
            ToPage(page: ProjectsFinished(), pageLabel: "Projetos"),
            ToPage(page: About(), pageLabel: "Sobre"),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: "Sair",
                func: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                outlined: true,
                colorChoose: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
