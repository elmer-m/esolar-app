// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';
import 'package:eslar/components/button.dart';
import 'package:eslar/pages/projects/startVisit.dart';
import 'package:eslar/pages/projects/viewVisit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eslar/components/AppConfig.dart';
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
  var visits;

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
          haveVisits = visits.isEmpty ? false : true;
          visits.isEmpty
              ? print("Não tem visitas $haveVisits")
              : print("tem visitas $haveVisits");
        });
        print("Veio ate aq ${visits}");
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ver Visita",
                style: TextStyle(
                  color: AppConfig().textColorW,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
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
                    : Expanded(
                        // Adicione o Expanded aqui
                        child: SingleChildScrollView(
                          child: Column(
                            children: visits.map<Widget>((visit) {
                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: Button(
                                  text: "Visita - ${visit['NAME']}",
                                  func: () {
                                    print("ID: ${visit['ID'].toString()}");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewVisit(
                                          id: visit['ID'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
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

  Future<void> GetProject() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getProject.php');
    final headers = {'Content-Type': 'application/json'};
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
        List<String> uploadedFiles =
            List<String>.from(jsonDecode(data['data']['UPLOADED_FILES']));
        ProcessFile(uploadedFiles);
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  @override
  void initState() {
    super.initState();
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
                ? const CircularProgressIndicator()
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
                            child: Text(
                              dataProject[0]['CLIENT_NAME'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 20, right: 20),
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 20),
                                            width: double.infinity,
                                            child: Text(
                                              "Anexos",
                                              style: TextStyle(
                                                  color: AppConfig().textColorW,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40),
                                            ),
                                          ),
                                          Attachments.isEmpty
                                              ? Container(
                                                  child: Text("Sem imagem"),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    spacing: 6,
                                                    children: Attachments.map(
                                                      (fileBytes) {
                                                        Uint8List uint8List =
                                                            Uint8List.fromList(
                                                                fileBytes);
                                                        bool isPdf(
                                                            List<int>
                                                                fileBytesMeeter) {
                                                          return fileBytes
                                                                      .length >=
                                                                  4 &&
                                                              fileBytesMeeter[
                                                                      0] ==
                                                                  0x25 &&
                                                              fileBytesMeeter[
                                                                      1] ==
                                                                  0x50 &&
                                                              fileBytesMeeter[
                                                                      2] ==
                                                                  0x44 &&
                                                              fileBytesMeeter[
                                                                      3] ==
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
                                                                    child: SfPdfViewer
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
                                                                  child: Image
                                                                      .memory(
                                                                          uint8List),
                                                                ),
                                                              );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                        ],
                                      );
                                    });
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
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Visitas",
                              loading: showVisitLoding,
                              func: () {
                                showVisitModal();
                              },
                            ),
                          ),
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
