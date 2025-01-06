// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';
import 'package:eslar/components/button.dart';
import 'package:eslar/components/seeFiles.dart';
import 'startVisit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eslar/components/AppConfig.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewVisit extends StatefulWidget {
  final String id;
  const ViewVisit({super.key, required this.id});

  @override
  State<ViewVisit> createState() => _ViewVisitState();
}

class _ViewVisitState extends State<ViewVisit> {
  var visitData;
  var houseFiles;
  var panelFiles;
  var counterFiles;
  var invoicesFiles;
  Future<void> ViewVisit() async {
    final url = Uri.parse('https://tze.ddns.net:8108/viewVisit.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'id': widget.id,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          visitData = data['data'][0];
          houseFiles = jsonDecode(visitData['HOUSE_EXTERIOR']);
          panelFiles = jsonDecode(visitData['ELETRICAL_PANEL']);
          counterFiles = jsonDecode(visitData['ELETRICAL_COUNTER']);
          invoicesFiles = jsonDecode(visitData['INVOICE']);
        });
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
    ViewVisit();
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
      body: visitData == null
          ? Center(
              child: CircularProgressIndicator(color: AppConfig().primaryColor,),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      width: double.infinity * 0.80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(AppConfig().padidng),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConfig().textColorW, width: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                                    "Visita - ${visitData['NAME']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "Tipologia de instalação",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          visitData['INSTALL_TIPOLOGY'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "Tipologia de cliente",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          visitData['CLIENT_TIPOLOGY'],
                                          style: const TextStyle(
                                              fontSize: 18,
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "Nota",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity * 0.80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(AppConfig().padidng),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConfig().textColorW, width: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                                    "Anexos",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Exterior Casa",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: SeeFiles(files: houseFiles),
                                      ),
                                      Container(
                                        child: Text(
                                          "Contador Elétrico",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: SeeFiles(files: counterFiles),
                                      ),
                                      Container(
                                        child: Text(
                                          "Painel Elétrico",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: SeeFiles(files: panelFiles),
                                      ),
                                      Container(
                                        child: Text(
                                          "Faturas",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: SeeFiles(files: invoicesFiles),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "Nota",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromARGB(255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
