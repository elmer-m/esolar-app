import 'dart:convert';

import 'package:eslar/pages/projects/project.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadUser();
    getProjects();
  }

  int pendingProposal = 0;
  int finishedProposal = 0;
  int waitingBudget = 0;

  Map<String, String> userData = {
    'firstName': '',
    'lastName': '',
  };

  Future<void> loadUser() async {
    userData = {
      'firstName': '',
      'lastName': '',
    };

    final prefs = await SharedPreferences.getInstance();
    final user = await prefs.getStringList('userData');
    print(user);
    setState(() {
      userData['firstName'] = user![0];
    });
  }

  List<dynamic> dataProject = [];
  var project;

  void findClosestDate() {
    DateTime today = DateTime.now();
    DateTime? closestDate;
    Duration closestDuration = Duration.zero;
    dataProject.forEach((date) {
      if (date['DATE_PROJECT'] != '') {
        DateTime projectDate = DateTime.parse(date['DATE_PROJECT']);
        Duration diff = today.difference(projectDate).abs();
        if (diff < closestDuration || closestDate == null) {
          closestDuration = diff;
          closestDate = projectDate;
          project = date;
        }
      }
    });
  }

  Future<void> getProjects() async {
    dataProject.clear();
    final url = Uri.parse("https://tze.ddns.net:8108/requestProjects.php");
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data = data['data'];
        setState(() {
          dataProject = data;
          dataProject.forEach((project) {
            if (project['STATUS'] != 'Concluido') {
              pendingProposal++;
            } else {
              finishedProposal++;
            }

            if (project['STATUS'] == "A espera do orçamento") {
              waitingBudget++;
            }
            findClosestDate();
          });
        });
        loading = false;
        print("Conectou");
      } else {
        print("Erro, normal, ${response.body}");
      }
    } catch (e) {
      print("Erro, grave $e");
    }
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppConfig().primaryColor,
              ),
            )
          : Container(
              padding: EdgeInsets.all(AppConfig().radius),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConfig().radius)),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Text(
                      "Olá " + userData['firstName']!,
                      style: TextStyle(
                          color: AppConfig().textColorW,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          "Bem vindo a ",
                          style: TextStyle(
                            color: AppConfig().textColorW,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Text("Escolha Solar",
                            style: TextStyle(
                                color: AppConfig().primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          project != null
                              ? Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      margin: EdgeInsets.only(bottom: 20),
                                      width: double.infinity,
                                      child: Text("Próxima Visita: ",
                                          style: TextStyle(
                                              color: AppConfig().textColorW,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        var id = project['ID'].toString();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Project(
                                              id: id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppConfig().textColorW,
                                              width: 0.2),
                                          color: AppConfig().backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                              AppConfig().radius),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Text(
                                              project['CLIENT_NAME'].toString(),
                                              style: TextStyle(
                                                  color: AppConfig().textColorW,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                            FractionallySizedBox(
                                              widthFactor: 0.7,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  project['GOAL'].toString(),
                                                  style: TextStyle(
                                                    color:
                                                        AppConfig().textColorW,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: 0.7,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Icon(
                                                        Icons.location_on,
                                                        color: AppConfig()
                                                            .textColorW,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${project['LOCATION'].toString()}, ${project['ADDRESS'].toString()}",
                                                      style: TextStyle(
                                                        color: AppConfig()
                                                            .textColorW,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: 0.7,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: AppConfig()
                                                            .textColorW,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      project['STATUS']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: AppConfig()
                                                            .textColorW,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_rounded,
                                                      color: AppConfig()
                                                          .textColorW,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                    project['DATE_PROJECT']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: AppConfig()
                                                          .textColorW,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppConfig().backgroundColor,
                              border: Border.all(
                                  width: 0.2, color: AppConfig().textColorW),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
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
                                    pendingProposal.toString(),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppConfig().backgroundColor,
                              border: Border.all(
                                  width: 0.2, color: AppConfig().textColorW),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                                    finishedProposal.toString(),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppConfig().backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
                              border: Border.all(
                                  width: 0.2, color: AppConfig().textColorW),
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
                                  child: Text(
                                    waitingBudget.toString(),
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
                  )
                ],
              ),
            ),
    );
  }
}
