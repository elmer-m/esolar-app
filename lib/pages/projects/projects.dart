import 'dart:convert';

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
  bool haveProjects = true;
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
          dataProject = data;
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
        child: RefreshIndicator(
          onRefresh: getProjects,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  width: double.infinity,
                  child: Text(
                    "Projetos",
                    style: TextStyle(
                        color: AppConfig().textColorW,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                ),
                haveProjects && dataProject.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppConfig().primaryColor,
                        ),
                      )
                    : haveProjects
                        ? Column(
                            children: [
                              for (var dataInfo in dataProject)
                                GestureDetector(
                                  onTap: () {
                                    var id = dataInfo['ID'].toString();
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
                                            dataInfo['CLIENT_NAME'].toString(),
                                            style: TextStyle(
                                                color: AppConfig().textColorW,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              dataInfo['GOAL'].toString(),
                                              style: TextStyle(
                                                color: AppConfig().textColorW,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "Instalação do produto",
                                              style: TextStyle(
                                                color: AppConfig().textColorW,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color:
                                                        AppConfig().textColorW,
                                                    size: 15,
                                                  ),
                                                ),
                                                Text(
                                                  dataInfo['LOCATION']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        AppConfig().textColorW,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons
                                                        .calendar_month_rounded,
                                                    color:
                                                        AppConfig().textColorW,
                                                    size: 15,
                                                  ),
                                                ),
                                                Text(
                                                  dataInfo['DATE_PROJECT']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        AppConfig().textColorW,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons.check,
                                                    color:
                                                        AppConfig().textColorW,
                                                    size: 15,
                                                  ),
                                                ),
                                                Text(
                                                  dataInfo['STATUS'].toString(),
                                                  style: TextStyle(
                                                    color:
                                                        AppConfig().textColorW,
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
                                                    child: Icon(Icons.person),
                                                  ),
                                                  Text(
                                                    "Alexandre afonso",
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
                            ],
                          )
                        : RefreshIndicator(
                            child: SingleChildScrollView(
                              child: Text("Não há projetos"),
                            ),
                            onRefresh: getProjects,
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
