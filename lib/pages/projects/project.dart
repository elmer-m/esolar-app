import 'dart:io';
import 'dart:typed_data';
import 'package:eslar/components/button.dart';
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
  List<List<int>> FilesCod = [];
  Future<void> SaveFile(List<String> forDecode) async {
    try {
      forDecode.forEach(
        (item) {
          List<int> bytes = base64Decode(item);
          setState(() {
            FilesCod.add(bytes);
          });
          print(FilesCod);
        },
      );
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> ImageOpen(valueImage) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isPdf(List<int> valueImage) {
          return valueImage.length >= 4 &&
              valueImage[0] == 0x25 &&
              valueImage[1] == 0x50 &&
              valueImage[2] == 0x44 &&
              valueImage[3] == 0x46;
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              isPdf(valueImage)
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: SfPdfViewer.memory(valueImage),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Image.memory(valueImage),
                    ),
              // Botão de Fechar
              Positioned(
                top: 10, // Ajuste para posicionar o botão
                right: 10, // Ajuste para posicionar o botão
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(), // Fecha o diálogo
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
        SaveFile(uploadedFiles);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AppConfig().primaryColor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: double.infinity * 0.80,
            decoration: BoxDecoration(
              color: const Color.fromARGB(57, 139, 139, 139),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: dataProject.isEmpty
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),
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
                                              fontSize: 12,
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
                                            fontSize: 12,
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilesCod.isEmpty
                              ? Container(
                                  child: Text("Sem imagem"),
                                )
                              : Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 6,
                                    children: FilesCod.map(
                                      (fileBytes) {
                                        Uint8List uint8List =
                                            Uint8List.fromList(fileBytes);
                                        bool isPdf(List<int> fileBytesMeeter) {
                                          return fileBytes.length >= 4 &&
                                              fileBytesMeeter[0] == 0x25 &&
                                              fileBytesMeeter[1] == 0x50 &&
                                              fileBytesMeeter[2] == 0x44 &&
                                              fileBytesMeeter[3] == 0x46;
                                        }

                                        return isPdf(fileBytes)
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.16,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      ImageOpen(uint8List),
                                                  child: AbsorbPointer(
                                                    child: SfPdfViewer.memory(
                                                      uint8List,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      ImageOpen(uint8List),
                                                  child:
                                                      Image.memory(uint8List),
                                                ),
                                              );
                                      },
                                    ).toList(),
                                  ),
                                ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Iniciar Visita",
                              func: () {},
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Button(
                              text: "Cancelar",
                              func: () {},
                              outlined: true,
                              colorChoose: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
            )),
      ),
    );
  }
}
