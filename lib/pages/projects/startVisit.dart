import 'dart:convert';
import 'dart:io';
import 'package:Esolar/components/sendAttachment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:Esolar/components/button.dart';
import 'package:Esolar/components/input.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:Esolar/components/dropDown.dart';
import 'package:dropdown_search/dropdown_search.dart';

class StartVisit extends StatefulWidget {
  final String id;
  const StartVisit({super.key, required this.id});

  @override
  State<StartVisit> createState() => _StartVisitState();
}

class _StartVisitState extends State<StartVisit> {
  bool uploading = false;
  TextEditingController visita = new TextEditingController();
  TextEditingController note = new TextEditingController();
  DateTime? selectedDate;
  List<String> files = [];
  List<String> invoice = [];
  List<String> instalation_tipology_types = [];
  List<String> client_tipology_types = [];
  List<String> external_house = [];
  List<String> eletrical_panel = [];
  List<String> eletrical_counter = [];
  List<List<String>> materials = [];
  String instalation_tipology = "";
  String client_tipology = "";

  Future<void> getInstallTypes() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getInstallTipology.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        setState(() {
          instalation_tipology_types = List<String>.from(
              data['data'].map((item) => item['TYPES'] as String));
        });
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> getClientTypes() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getClientTipology.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        print(response.body);
        var data = jsonDecode(response.body);

        setState(() {
          client_tipology_types = List<String>.from(
              data['data'].map((item) => item['TYPES'] as String));
        });
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> getMaterials() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getMaterials.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        var col = data['data'];
        print('aqui');
        setState(() {
          materials = List<List<String>>.from(
            col.map(
              (item) => [
                item['ID']?.toString() ?? 'Nulo',
                "${item['MATERIAL_NAME']}",
                '0',
                "${item['MATERIAL_PRICE']}",
              ],
            ),
          );
        });
      } catch (e) {
        print("Erro ao decodificar JSONsa: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = result.files.map((file) => file.path!).toList();
      });
      print("files: $files");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Ocorreu um erro, tente novamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Fechar"),
                ),
              ],
            );
          });
    }
  }

  Future<void> Create() async {
    final url = Uri.parse('https://tze.ddns.net:8108/visitCreation.php');

    try {
      setState(() {
        uploading = true;
      });
      print(materials);
      materials.removeWhere((material) {
        return material.contains('0');
      });
      print(materials);
      var request = http.MultipartRequest('POST', url);
      request.fields['instalation_tipology'] = instalation_tipology != "" ? instalation_tipology : 'N/A';
      request.fields['client_tipology'] = client_tipology != "" ? client_tipology : 'N/A';
      request.fields['project_id'] = widget.id.toString();
      request.fields['name'] = visita.text != "" ? visita.text : 'N/A';
      request.fields['note'] = note.text != "" ? note.text : 'N/A';
      request.fields['materials'] = jsonEncode(materials);
      for (String external_house_files in external_house) {
        File file = File(external_house_files);
        request.files.add(
            await http.MultipartFile.fromPath('external_house[]', file.path));
      }
      for (String invoices_files in invoice) {
        File file = File(invoices_files);
        request.files
            .add(await http.MultipartFile.fromPath('invoices[]', file.path));
      }
      for (String eletrical_counter_files in eletrical_counter) {
        File file = File(eletrical_counter_files);
        request.files.add(
            await http.MultipartFile.fromPath('eletric_counter[]', file.path));
      }
      for (String panel_counter_files in eletrical_panel) {
        File file = File(panel_counter_files);
        request.files.add(
            await http.MultipartFile.fromPath('eletric_panel[]', file.path));
      }
      var streamResponse = await request.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print("Deu certo:  ${response.body}");
      } else {
        print("Deu errado, erro: ${response.statusCode}");
        print("Resposta: ${response.body}");
      }
      setState(() {
        uploading = false;
        Navigator.pop(context, "visit");
      });
    } catch (e) {
      print("Erro na requisição: $e");
      setState(() {
        uploading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInstallTypes();
    getClientTypes();
    getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: AppConfig().overlayColor,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: AppConfig().overlayColor,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppConfig().backgroundColor,
            borderRadius: BorderRadius.circular(AppConfig().radius),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: Text(
                        "Visita",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    child: Input(label: "Nome", controler: visita),
                    margin: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Dropdown(
                    data: instalation_tipology_types,
                    label: "Tipologia de instalação",
                    onChanged: (value) {
                      instalation_tipology = value;
                    },
                  ),
                  Dropdown(
                    onChanged: (value) {
                      client_tipology = value;
                    },
                    data: client_tipology_types,
                    label: "Tipologia de cliente",
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Button(
                      text: "Materiais",
                      func: () {
                        AppConfig().Bottom(
                          context,
                          "Materiais",
                          Container(
                            child: Column(
                              children: [
                                !materials.isEmpty ? 
                                Column(
                                    children: materials.map<Widget>((material) {
                                  return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.symmetric(vertical: 30),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.2,
                                              color: AppConfig().textColorW),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              material[1],
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: InputQty.int(
                                              initVal: int.parse(material[2]),
                                              onQtyChanged: (value) {
                                                material[2] = value.toString();
                                              },
                                              decoration: QtyDecorationProps(
                                                borderShape:
                                                    BorderShapeBtn.square,
                                                btnColor:
                                                    AppConfig().primaryColor,
                                                isBordered: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                }).toList()) : Center(child: Text("Não há materiais disponíveis."),),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Attachment(
                    isImageOnly: false,
                    label: "Faturas (PDF)",
                    onChanged: (value) {
                      invoice = value;
                    },
                  ),
                  Attachment(
                    isImageOnly: true,
                    label: "Contador Elétrico",
                    onChanged: (value) {
                      eletrical_counter = value;
                    },
                  ),
                  Attachment(
                    isImageOnly: true,
                    label: "Quadro Elétrico",
                    onChanged: (value) {
                      eletrical_panel = value;
                    },
                  ),
                  Attachment(
                    isImageOnly: true,
                    label: "Exterior Casa",
                    onChanged: (value) {
                      external_house = value;
                    },
                  ),
                  Container(
                    child: Input(label: "Nota(Opcional)", controler: note),
                    margin: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: Button(
                      loading: uploading,
                      text: "Adicionar",
                      func: () => Create(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
