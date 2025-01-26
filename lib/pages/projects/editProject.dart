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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EditProject extends StatefulWidget {
  String id = "";
  EditProject({super.key, required this.id});

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  TextEditingController client_name = TextEditingController();
  TextEditingController client_number = TextEditingController();
  TextEditingController client_number_code = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController address = TextEditingController();
  List<dynamic> dataProject = [];
  final GlobalKey<DropdownState> localKey = GlobalKey<DropdownState>();
  final GlobalKey<DropdownState> goalKey = GlobalKey<DropdownState>();
  final GlobalKey<DropdownState> stateKey = GlobalKey<DropdownState>();
  final GlobalKey<DropdownState> colKey = GlobalKey<DropdownState>();

  String phone_code = "";
  String location = "";
  String goal = "";
  String status = "";

  List<String> files = [];
  List<String> optionsGoal = [];
  List<String> optionsStatus = [];
  List<List<String>> collaborators = [];
  List<String> collaboratorsChosed = [];
  List<String> collaboratorsChosedEdit = [];

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
                    Navigator.of(context).pop();
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

  List<String> uploadedFiles = [];
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
        print('Data ${dataProject[0]}');
        client_name.text = dataProject[0]['CLIENT_NAME'];
        client_number_code.text = dataProject[0]['PHONE_CODE'].toString();
        client_number.text = dataProject[0]['PHONE'].toString();
        address.text = dataProject[0]['ADDRESS'];
        goalKey.currentState?.setValue(dataProject[0]['GOAL']);
        stateKey.currentState?.setValue(dataProject[0]['STATUS']);
        localKey.currentState?.setValue(dataProject[0]['LOCATION']);
        setState(() {
          var collaboratorsArm =
              List<String>.from(jsonDecode(dataProject[0]['COLLABORATORS']));
          collaboratorsChosedEdit = collaborators
              .where((col) => collaboratorsArm.contains(col[0]))
              .map((col) => col[1])
              .toList();
          collaboratorsChosed = collaborators
              .where((col) => collaboratorsArm.contains(col[0]))
              .map((col) => col[0])
              .toList();
          date.text = dataProject[0]['DATE_PROJECT'];
          print("Data Project" + date.text);
        });
        uploadedFiles =
            List<String>.from(jsonDecode(data['data']['UPLOADED_FILES']));
        files = uploadedFiles;
        ProcessFile(uploadedFiles);
        loading = false;
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
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

  Future<void> Edit() async {
    final url = Uri.parse('https://tze.ddns.net:8108/editProject.php');
    try {
      setState(() {
        uploading = true;
      });
      var request = http.MultipartRequest('POST', url);
      request.fields['id'] = widget.id;
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
      request.fields['collaborators'] = jsonEncode(collaboratorsChosed);
      request.fields['uploaded_files'] = jsonEncode(files);

      var streamResponse = await request.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print("Deu certo:  ${response.body}");
        var dataa = jsonDecode(response.body);
        Navigator.pop(context, '.');
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

  bool loading = true;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    getLocations();
    getGoals();
    getStatus();
    await getUsers();
    await GetProject();
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
                                "Editar Projeto",
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
                                      label: "+351",
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
                            key: localKey,
                            data: locations,
                            label: "Local",
                            onChanged: (value) {
                              location = value;
                            },
                          ),
                          Dropdown(
                            key: goalKey,
                            data: optionsGoal,
                            label: "Objetivo",
                            onChanged: (value) {
                              goal = value;
                            },
                          ),
                          Dropdown(
                            key: stateKey,
                            data: optionsStatus,
                            label: "Estado",
                            onChanged: (value) {
                              status = value;
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownSearch<String>.multiSelection(
                              key: colKey,
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
                              selectedItems: collaboratorsChosedEdit,
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
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Anexos",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(255, 99, 99, 99),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            child: SeeFiles(
                              addMore: true,
                              files: uploadedFiles,
                              forRemove: true,
                              onChanged: (value) {
                                files = value;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: Button(
                              loading: uploading,
                              text: "Editar",
                              func: () => Edit(),
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
