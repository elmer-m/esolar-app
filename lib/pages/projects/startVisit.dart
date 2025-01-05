import 'dart:convert';
import 'dart:io';
import 'package:eslar/components/sendAttachment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:eslar/components/button.dart';
import 'package:eslar/components/input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:eslar/components/dropDown.dart';
import 'package:dropdown_search/dropdown_search.dart';

class StartVisit extends StatefulWidget {
  final int id;
  const StartVisit({super.key, required this.id});

  @override
  State<StartVisit> createState() => _StartVisitState();
}

class _StartVisitState extends State<StartVisit> {
  bool uploading = false;
  TextEditingController visita = new TextEditingController();
  DateTime? selectedDate;
  List<String> files = [];
  List<String> invoice = [];
  List<String> instalation_tipology_types = [];
  List<String> client_tipology_types = [];
  List<String> external_house = [];
  List<String> eletrical_panel = [];
  List<String> eletrical_counter = [];
  String instalation_tipology = "teste";
  String client_tipology = "teste";

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
                    Navigator.of(context).pop(); // Fecha o dialog
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
      var request = http.MultipartRequest('POST', url);
      request.fields['instalation_tipology'] = instalation_tipology;
      request.fields['client_tipology'] = client_tipology;
      request.fields['project_id'] = widget.id.toString();
      request.fields['name'] = visita.text;
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
                      label: "Tipologia de cliente"),
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
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: Button(
                      loading: uploading,
                      text: "Adcionar",
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
