// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';
import 'package:Esolar/components/button.dart';
import 'package:Esolar/pages/projects/editProject.dart';
import 'package:Esolar/pages/projects/startVisit.dart';
import 'package:Esolar/pages/projects/viewVisit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Esolar/components/AppConfig.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Project extends StatefulWidget {
  final String id;
  const Project({super.key, required this.id});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  List<dynamic> dataProject = [];
  bool haveVisits = false;
  bool showVisitLoding = false;
  List<List<String>> materialsUsed = [];
  var visits;
  double budget = 0.0;

  List<List<int>> Attachments = [];
  void ProcessFile(List<String> fileEncoded) {
    try {
      fileEncoded.forEach(
        (item) {
          List<int> bytes = base64Decode(item);
          setState(
            () {
              Attachments.add(bytes);
            },
          );
        },
      );
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> AttachmentFocus(valueFile) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isPdf(List<int> valueToAnalyze) {
          return valueToAnalyze.length >= 4 &&
              valueToAnalyze[0] == 0x25 &&
              valueToAnalyze[1] == 0x50 &&
              valueToAnalyze[2] == 0x44 &&
              valueToAnalyze[3] == 0x46;
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              isPdf(valueFile)
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: SfPdfViewer.memory(valueFile),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Image.memory(valueFile),
                    ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> GetVisits() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getVisits.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'id': widget.id,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          visits = data['data'];
          List<String> prices = [];
          var material;
          print("Visits $visits");
          materialsUsed.clear();
          visits.forEach((visit) {
            material = jsonDecode(visit['MATERIALS']);
            material.forEach((mat) {
              print("Material $mat");
              List<String> temp = [];
              temp.add(mat[0]);
              temp.add(mat[1]);
              temp.add(mat[2]);
              temp.add(mat[3]);
              materialsUsed.add(temp);
              prices.add(
                  (double.parse(mat[3]) * double.parse(mat[2])).toString());
            });
          });
          budget = 0.0;
          prices.forEach((price) {
            budget += double.parse(price);
          });

          print("Materiais $materialsUsed");

          haveVisits = visits.isEmpty ? false : true;
          visits.isEmpty
              ? print("Não tem visitas $haveVisits")
              : print("Tem visitas $haveVisits");
        });

        print("Veio até aqui ${visits}");
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  Future<void> showVisitModal() async {
    setState(() {
      showVisitLoding = true;
    });
    await GetVisits();
    AppConfig().Bottom(
      context,
      "Ver Visitas",
      Center(
        child: visits.isEmpty && !haveVisits
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Não há visitas neste projeto.",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 99, 99, 99),
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
              child: Column(
                children: visits.map<Widget>(
                  (visit) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: Button(
                        text: "Visita - ${visit['NAME']}",
                        func: () {
                          ViewVisitId(visit['ID'].toString());
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
      ),
    );
    setState(() {
      showVisitLoding = false;
    });
  }

  Future<void> NewVisit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartVisit(
          id: widget.id,
        ),
      ),
    );

    if (result != null) {
      showVisitModal();
    }
  }

  Future<void> ViewVisitId(id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewVisit(
          id: id,
        ),
      ),
    );

    if (result != null) {
      Navigator.pop(context);
    }
  }

  Future<void> GetProject() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getProject.php');
    final headers = {'Content-Type': 'application/json'};
    Attachments = [];
    final body = jsonEncode({
      'id': widget.id,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataProject = [data['data']];
        });
        print("Não esta acessando");
        List<String> uploadedFiles =
            List<String>.from(jsonDecode(data['data']['UPLOADED_FILES']));
        if (data['data']['ARCHIVED'] == 0) {
          archived = 1;
        } else {
          archived = 0;
        }
        print("Valor do archived $archived");
        ProcessFile(uploadedFiles);
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  Future<void> DeleteProject() async {
    final url = Uri.parse('https://tze.ddns.net:8108/deleteProject.php');
    var request = http.MultipartRequest('POST', url);
    request.fields['id'] = widget.id;
    var streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);
    try {
      print("Aqui");

      if (response.statusCode == 200) {
        print("Deu certo ${widget.id} ${response.body}");
        Navigator.pop(context);
        Navigator.pop(context, 'project');
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  int archived = 1;
  Future<void> ArchiveProject() async {
    final url = Uri.parse('https://tze.ddns.net:8108/archiveProject.php');
    var request = http.MultipartRequest('POST', url);
    request.fields['id'] = widget.id;
    request.fields['archived'] = archived.toString();
    var streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);
    try {
      print("Aqui");

      if (response.statusCode == 200) {
        setState(() {
          if (archived == 0) {
            archived = 1;
          } else {
            archived = 0;
          }
        });
        print("Valor do archived depois de salvar $archived ${response.body}");
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  Future<void> Edit() async {
    var id = dataProject[0]['ID'].toString();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProject(
          id: id,
        ),
      ),
    );

    if (result != null) {
      GetVisits();
      GetProject();
    }
  }

  @override
  void initState() {
    super.initState();
    GetVisits();
    GetProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().overlayColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConfig().backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppConfig().primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: double.infinity * 0.80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: dataProject.isEmpty
                ? CircularProgressIndicator(
                    color: AppConfig().primaryColor,
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(AppConfig().padidng),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppConfig().textColorW, width: 0.2),
                        borderRadius: BorderRadius.circular(AppConfig().radius),
                        color: AppConfig().backgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppConfig().textColorW,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dataProject[0]['CLIENT_NAME'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  budget.toStringAsFixed(2) + '€',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppConfig().textColorW,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    dataProject[0]['GOAL'].toString(),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    dataProject[0]['STATUS'].toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppConfig().textColorW,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                          Icons.location_on,
                                          size: 16,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${dataProject[0]['LOCATION'].toString()}, ${dataProject[0]['ADDRESS'].toString()}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                          Icons.calendar_month,
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        dataProject[0]['DATE_PROJECT']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                          Icons.phone,
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        "+${dataProject[0]['PHONE_CODE']} ${dataProject[0]['PHONE']}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Mostrar Anexos",
                              func: () {
                                AppConfig().Bottom(
                                  context,
                                  'Anexos',
                                  Column(
                                    children: [
                                      Attachments.isEmpty
                                          ? Container(
                                              child: Text("Sem imagem"),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                runAlignment:
                                                    WrapAlignment.center,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                spacing: 6,
                                                children: Attachments.map(
                                                  (fileBytes) {
                                                    Uint8List uint8List =
                                                        Uint8List.fromList(
                                                            fileBytes);
                                                    bool isPdf(
                                                        List<int>
                                                            fileBytesMeeter) {
                                                      return fileBytes.length >=
                                                              4 &&
                                                          fileBytesMeeter[0] ==
                                                              0x25 &&
                                                          fileBytesMeeter[1] ==
                                                              0x50 &&
                                                          fileBytesMeeter[2] ==
                                                              0x44 &&
                                                          fileBytesMeeter[3] ==
                                                              0x46;
                                                    }

                                                    return isPdf(fileBytes)
                                                        ? Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.16,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  AttachmentFocus(
                                                                      uint8List),
                                                              child:
                                                                  AbsorbPointer(
                                                                child:
                                                                    SfPdfViewer
                                                                        .memory(
                                                                  uint8List,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  AttachmentFocus(
                                                                      uint8List),
                                                              child:
                                                                  Image.memory(
                                                                      uint8List),
                                                            ),
                                                          );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Mostrar Materiais",
                              func: () {
                                Map<int, List<dynamic>> group = {};
                                for (var item in materialsUsed) {
                                  var id = item[0];
                                  var name = item[1];
                                  var quantity = item[2];
                                  var price = item[3];

                                  if (group.containsValue(id)) {
                                    group[id]![2]++;
                                    group[id]![3] += price;
                                  } else {
                                    group[int.parse(id)] = [
                                      '$id',
                                      name,
                                      quantity,
                                      price
                                    ];
                                  }
                                }
                                List<List<dynamic>> resultado =
                                    group.values.toList();
                                AppConfig().Bottom(
                                    context,
                                    'Materiais',
                                    materialsUsed.isNotEmpty
                                        ? Column(
                                            children:
                                                materialsUsed.map((material) {
                                              return Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.2,
                                                        color: AppConfig()
                                                            .textColorW),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(material[1]),
                                                    Spacer(),
                                                    Text(material[2]),
                                                    Text(' - '),
                                                    Text(
                                                      ((double.parse(
                                                                  material[3]) *
                                                              double.parse(
                                                                  material[2]))
                                                          .toStringAsFixed(2)),
                                                    ),
                                                    Text('€')
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : Center(
                                            child: Text("Não há materiais."),
                                          ));
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Nova Visita",
                              func: () {
                                NewVisit();
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 50),
                            width: double.infinity,
                            child: Button(
                              text: "Visitas",
                              loading: showVisitLoding,
                              func: () {
                                showVisitModal();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Edit();
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                  child: Icon(
                                    archived == 0
                                        ? Icons.archive_outlined
                                        : Icons.unarchive_outlined,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmação"),
                                          content: Text(archived == 0
                                              ? "Tem certeza que deseja arquivar o projeto?"
                                              : "Tem certeza que deseja desarquivar o projeto?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Não",
                                                  style: TextStyle(
                                                      color: AppConfig()
                                                          .primaryColor),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  ArchiveProject();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Sim",
                                                  style: TextStyle(
                                                      color: AppConfig()
                                                          .primaryColor),
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmar"),
                                          content: Text(
                                              "Tem certeza que deseja remover o projeto?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Não",
                                                style: TextStyle(
                                                    color: AppConfig()
                                                        .primaryColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                DeleteProject();
                                              },
                                              child: Text(
                                                "Sim",
                                                style: TextStyle(
                                                    color: AppConfig()
                                                        .primaryColor),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
