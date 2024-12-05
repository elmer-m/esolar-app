import 'package:eslar/components/AppConfig.dart';
import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool first = true;
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
                  "Configuração",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Notificações"),
                            const Spacer(),
                            Switch(
                              value: first,
                              activeColor: AppConfig().primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  first = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Notificações"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Notificações"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Notificações"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Text("Config"),
                            const Spacer(),
                            Switch(
                                value: false,
                                activeColor: AppConfig().primaryColor,
                                onChanged: (value) {}),
                          ],
                        ),
                      ),
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
