import 'package:Esolar/components/AppConfig.dart';
import 'package:flutter/material.dart';

class ProjectsFinished extends StatelessWidget {
  const ProjectsFinished({super.key});

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
                "Projetos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color: AppConfig().backgroundColor))),
                            child: const Text(
                              "Maria Madalena",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Text(
                            "ORÇ PARA INST DE PAINEIS FOTOVOLTAICOS",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "Corroios",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "+351 987 317 123",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "12/12/2024",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "CONCLUÍDO",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color: AppConfig().backgroundColor))),
                            child: const Text(
                              "Maria Madalena",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Text(
                            "ORÇ PARA INST DE PAINEIS FOTOVOLTAICOS",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "Corroios",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "+351 987 317 123",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "12/12/2024",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "CONCLUÍDO",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color: AppConfig().backgroundColor))),
                            child: const Text(
                              "Maria Madalena",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Text(
                            "ORÇ PARA INST DE PAINEIS FOTOVOLTAICOS",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "Corroios",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "+351 987 317 123",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "12/12/2024",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "CONCLUÍDO",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConfig().radius)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color: AppConfig().backgroundColor))),
                            child: const Text(
                              "Maria Madalena",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Text(
                            "ORÇ PARA INST DE PAINEIS FOTOVOLTAICOS",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "Corroios",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "+351 987 317 123",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                  ),
                                ),
                                const Text(
                                  "12/12/2024",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              "CONCLUÍDO",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
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
