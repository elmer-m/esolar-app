import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Esolar/components/dropDown.dart';
import 'package:Esolar/components/seeFiles.dart';
import 'package:Esolar/components/sendAttachment.dart';
import 'package:Esolar/pages/projects/project.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:Esolar/components/button.dart';
import 'package:Esolar/components/input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddProject extends StatefulWidget {
  String companyId;
  AddProject({super.key, required this.companyId});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  TextEditingController client_name = TextEditingController();
  TextEditingController client_number = TextEditingController();
  TextEditingController client_number_code = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController address = TextEditingController();

  String phone_code = "";
  String location = "";
  String goal = "";
  String status = "";

  List<String> files = [];
  List<String> optionsGoal = [];
  List<String> optionsStatus = [];
  List<List<String>> collaborators = [];
  List<String> collaboratorsChosed = [];

  DateTime? selectedDate;

  Future<void> AttachmentFocus(valueFile) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              valueFile.endsWith("pdf")
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: SfPdfViewer.file(File(valueFile)),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Image.file(File(valueFile)),
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

  Future<void> selectData(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppConfig().primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 16, minute: 00),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme:
                    ColorScheme.light(primary: AppConfig().primaryColor),
              ),
              child: child!,
            );
          });
      if (pickedTime != null) {
        final DateTime finalDateAndHour = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(
          () {
            selectedDate = finalDateAndHour;
            date.value = TextEditingValue(
              text: DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!),
            );
          },
        );
      }
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
                    Navigator.of(context).pop(); // Fecha o dialog
                  },
                  child: const Text("Fechar"),
                ),
              ],
            );
          });
    }
  }

  bool uploading = false;
  List<String> locations = ['teste'];
  Future<void> getLocations() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getLocations.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        setState(() {
          locations = List<String>.from(
              data['data'].map((item) => item['DESCRICAO'] as String));
          locations.sort();
        });
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> getGoals() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getGoals.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        setState(() {
          optionsGoal = List<String>.from(
              data['data'].map((item) => item['OBJETIVO'] as String));
        });
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> getStatus() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getStatus.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        setState(() {
          optionsStatus = List<String>.from(
              data['data'].map((item) => item['ESTADO'] as String));
        });
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> getUsers() async {
    final url = Uri.parse('https://tze.ddns.net:8108/getUsers.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        var col = data['data'];
        print('aqui');
        setState(() {
          // Faz o cast correto e mapeia cada item da lista para List<String>
          collaborators = List<List<String>>.from(
            col.map(
              (item) => [
                item['ID']?.toString() ?? 'Nulo',
                "${item['FIRST_NAME']}  ${item['LAST_NAME']}",
              ],
            ),
          );
          print("Data Users ${collaborators}");
        });
      } catch (e) {
        print("Erro : $e");
      }
    } else {
      print("Erro ao fazer a requisição. Status: ${response.statusCode}");
    }
  }

  Future<void> Create() async {
    final url = Uri.parse('https://tze.ddns.net:8108/newProject.php');

    try {
      setState(() {
        uploading = true;
      });
      var request = http.MultipartRequest('POST', url);
      request.fields['client_name'] =
          client_name.text.isNotEmpty ? client_name.text : 'N/A';
      request.fields['phone_code'] =
          client_number_code.text.isNotEmpty ? client_number_code.text : 'N/A';
      request.fields['phone'] =
          client_number.text.isNotEmpty ? client_number.text : 'N/A';
      request.fields['location'] = location.isNotEmpty ? location : 'N/A';
      request.fields['address'] =
          address.text.isNotEmpty ? address.text : 'N/A';
      request.fields['goal'] = goal.isNotEmpty ? goal : 'N/A';
      request.fields['status'] = status.isNotEmpty ? status : 'N/A';
      request.fields['date'] = date.text;
      request.fields['userName'] = userName.isNotEmpty ? userName : 'N/A';
      request.fields['collaborators'] = jsonEncode(collaboratorsChosed);
      request.fields['companyId'] = widget.companyId;
      request.fields['files'] = jsonEncode(files);

      var streamResponse = await request.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print("Deu certo:  ${response.body}");
        var dataa = jsonDecode(response.body);
        Navigator.pop(context);
        Navigator.pop(context);
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

  String userName = "";
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getStringList('userData');

    setState(() {
      userName = "${user![0]} ${user[1]}";
      print("User Name: $userName");
    });
  }

  @override
  void initState() {
    getLocations();
    getGoals();
    getStatus();
    getUsers();
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().overlayColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig().radius),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: AppConfig().backgroundColor,
                      borderRadius: BorderRadius.circular(AppConfig().radius)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Center(
                              child: Text(
                                "Adicionar Projeto",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Input(
                              label: "Nome do cliente",
                              controler: client_name,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Input(
                                      label: "Código de País",
                                      controler: client_number_code,
                                      type: TextInputType.numberWithOptions(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Input(
                                    label: "Número do cliente",
                                    controler: client_number,
                                    type: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Input(
                                label: "Endereço completo", controler: address),
                          ),
                          Dropdown(
                            data: locations,
                            label: "Local",
                            search: true,
                            onChanged: (value) {
                              location = value;
                              print("object $location");
                            },
                          ),
                          Dropdown(
                            data: optionsGoal,
                            label: "Objetivo",
                            onChanged: (value) {
                              goal = value;
                            },
                          ),
                          Dropdown(
                            data: optionsStatus,
                            label: "Estado",
                            onChanged: (value) {
                              status = value;
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownSearch<String>.multiSelection(
                              onChanged: (selectedNames) {
                                print("$selectedNames $collaborators");
                                setState(() {
                                  collaboratorsChosed =
                                      selectedNames.map((name) {
                                    return collaborators.firstWhere(
                                      (collab) =>
                                          collab[1] ==
                                          name, // Compara o ID no índice [0]
                                      orElse: () => [
                                        'N/A',
                                        'N/A'
                                      ], // Valor padrão se não encontrado
                                    )[0]; // Retorna o nome no índice [1]
                                  }).toList();
                                  print(collaboratorsChosed);
                                });
                              },
                              items: (filter, infiniteScrollProps) async {
                                return collaborators.map((e) => e[1]).toList();
                              },
                              suffixProps: DropdownSuffixProps(
                                dropdownButtonProps: DropdownButtonProps(
                                  iconClosed: Icon(Icons.keyboard_arrow_down),
                                  iconOpened: Icon(Icons.keyboard_arrow_up),
                                ),
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppConfig().textColorW,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(
                                        AppConfig().radius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppConfig().primaryColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(
                                        AppConfig().radius),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppConfig().textColorW,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(
                                        AppConfig().radius),
                                  ),
                                  hintText: "Colaboradores",
                                ),
                              ),
                              popupProps: PopupPropsMultiSelection.bottomSheet(
                                checkBoxBuilder:
                                    (context, item, isDisabled, isSelected) {
                                  return Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? selected) {
                                      if (selected != null) {}
                                    },
                                    activeColor: AppConfig().primaryColor,
                                    checkColor: Colors.white,
                                  );
                                },
                                bottomSheetProps: BottomSheetProps(
                                  shape: Border.all(
                                      color: AppConfig().textColorW,
                                      width: 0.2),
                                  backgroundColor: AppConfig().backgroundColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Input(
                              function: () => selectData(context),
                              onlyRead: true,
                              label: "Data",
                              controler: date,
                              type: TextInputType.datetime,
                            ),
                          ),
                          SeeFiles(
                            files: files,
                            addMore: true,
                            onChanged: (value) {
                              files = value;
                            },
                          ),
                          //   width: double.infinity
                          //   margin: EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         margin: EdgeInsets.symmetric(vertical: 10),
                          //         child: Text(
                          //           "Funcionários",
                          //           style: TextStyle(
                          //               fontSize: 18, fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //       Wrap(
                          //         spacing: 3,
                          //         runSpacing: 3,
                          //         alignment: WrapAlignment.center,
                          //         children: [
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "João Costa",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "Maria Silva",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "Carlos Santos",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "Ana Oliveira",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "Pedro Lima",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 8, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Text(
                          //               "Rafael Ferreira",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 5, vertical: 5),
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(AppConfig().radius),
                          //               color: AppConfig().primaryColor,
                          //             ),
                          //             child: Icon(
                          //               Icons.add,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
