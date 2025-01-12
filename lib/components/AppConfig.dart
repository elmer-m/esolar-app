import 'package:flutter/material.dart';

class AppConfig {
  final Color primaryColor = const Color.fromRGBO(255, 93, 7, 1);
  final Color overlayColor = const Color.fromARGB(255, 240, 240, 240);
  final Color backgroundColor = Colors.white;
  final Color textColorW = const Color.fromARGB(255, 50, 50, 50);
  final double radius = 15;
  final double padidng = 20;
  void Bottom(BuildContext context, String label, Widget Cont) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: double.infinity,
                child: Text(
                  label,
                  style: TextStyle(
                      color: AppConfig().textColorW,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Cont,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
