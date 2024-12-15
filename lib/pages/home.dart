import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppConfig().radius),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig().radius)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConfig().backgroundColor,
                  border: Border.all(width: 0.2, color: AppConfig().textColorW),
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child:  Text(
                        "Propostas Pendentes",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        "12",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConfig().backgroundColor,
                  border: Border.all(width: 0.2, color: AppConfig().textColorW),
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Propostas Concluidas",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        "5",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConfig().backgroundColor,
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                  border: Border.all(width: 0.2, color: AppConfig().textColorW),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "A espera do orçamento",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child:  Text(
                        "2",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConfig().backgroundColor,
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                  border: Border.all(width: 0.2, color: AppConfig().textColorW),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Visitas Marcadas Para Hoje",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        "3",
                        style: TextStyle(
                            color: AppConfig().textColorW,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
