import 'package:Esolar/components/AppConfig.dart';
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
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    width: double.infinity,
                    child: Text(
                      "Definições",
                      style: TextStyle(
                          color: AppConfig().textColorW,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConfig().radius),
                        topRight: Radius.circular(AppConfig().radius),
                        bottomLeft: Radius.circular(AppConfig().radius),
                        bottomRight: Radius.circular(AppConfig().radius),
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Notificações",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          Spacer(),
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
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
