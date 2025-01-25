import 'dart:convert';

import 'package:eslar/components/button.dart';
import 'package:eslar/pages/projects/project.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:http/http.dart' as http;

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  List<dynamic> dataProject = [];
  bool haveProjects = false;
  List<dynamic> organize = [];

  void ShowArchived() {
    setState(() {
      dataProject = organize;
      haveProjects = true;
    });
    Navigator.pop(context);
  }

  Future<void> ViewProject(id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Project(
          id: id,
        ),
      ),
    );

    if(result != null){
      getProjects();
    }
  }

  Future<void> getProjects() async {
    haveProjects = true;
    dataProject.clear();
    final url = Uri.parse("https://tze.ddns.net:8108/requestProjects.php");
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data = data['data'];
        setState(() {
          organize = data;
          organize.forEach((project) {
            if (project['ARCHIVED'] == 1 || project['ARCHIVED'] == null) {
              dataProject.add(project);
            }
          });

          haveProjects = dataProject.isEmpty ? false : true;
          print("Aqui: $haveProjects");
        });
        print("Conectou, $data");
      } else {
        print("Erro, normal, ${response.body}");
      }
    } catch (e) {
      print("Erro, grave $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig().radius),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    "Projetos",
                    style: TextStyle(
                        color: AppConfig().textColorW,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    AppConfig().Bottom(
                      context,
                      "Opções",
                      Container(
                        width: double.infinity,
                        child: Button(
                            text: "Mostrar Arquivados",
                            func: () {
                              ShowArchived();
                            }),
                      ),
                    );
                  },
                  child: Icon(Icons.menu),
                ),
              ],
            ),
            haveProjects && dataProject.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppConfig().primaryColor,
                    ),
                  )
                : haveProjects
                    ? Expanded(
                        child: RefreshIndicator(
                            color: AppConfig().primaryColor,
                            onRefresh: getProjects,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var dataInfo in dataProject)
                                    GestureDetector(
                                      onTap: () {
                                        ViewProject(dataInfo['ID'].toString());
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
                                                child: Row(
                                              children: [
                                                Text(
                                                  dataInfo['CLIENT_NAME']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: AppConfig()
                                                          .textColorW,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Spacer(),
                                                dataInfo['ARCHIVED'] == 0
                                                    ? Icon(
                                                        Icons.archive_outlined)
                                                    : SizedBox.shrink(),
                                              ],
                                            )),
                                            FractionallySizedBox(
                                              widthFactor: 0.7,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  dataInfo['GOAL'].toString(),
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
                                                      dataInfo['LOCATION']
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
                                                        Icons
                                                            .calendar_month_rounded,
                                                        color: AppConfig()
                                                            .textColorW,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      dataInfo['DATE_PROJECT']
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
                                                      dataInfo['STATUS']
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
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child:
                                                            Icon(Icons.person),
                                                      ),
                                                      Text(
                                                        dataInfo['USER_NAME'],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: AppConfig()
                                                              .textColorW,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 200),
                                  )
                                ],
                              ),
                            )),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: getProjects,
                          color: AppConfig().primaryColor,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text("Não há projetos"),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 500),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
