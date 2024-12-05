import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:eslar/components/button.dart';
import 'package:eslar/components/input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  TextEditingController client_name = TextEditingController();
  TextEditingController client_number = TextEditingController();
  TextEditingController client_number_code = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController address = TextEditingController();

  String phone_code = "";
  String goal = "";
  String status = "";

  List<String> files = [];
  List<String> optionsGoal = [];
  List<String> optionsStatus = [];

  DateTime? selectedDate;

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
        print("Data ${response.body}");
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
        print("Data ${response.body}");
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

  Future<void> Create() async {
    final url = Uri.parse('https://tze.ddns.net:8108/newProject.php');

    try {
      setState(() {
        uploading = true;
      });
      var request = http.MultipartRequest('POST', url);
      request.fields['client_name'] = client_name.text;
      request.fields['phone_code'] = client_number_code.text;
      request.fields['phone'] = client_number.text;
      request.fields['location'] = location.text;
      request.fields['address'] = address.text;
      request.fields['goal'] = goal;
      request.fields['status'] = status;
      request.fields['date'] = date.text;

      for (String path in files) {
        File file = File(path);
        request.files
            .add(await http.MultipartFile.fromPath('files[]', file.path));
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
    getLocations();
    getGoals();
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(58, 139, 139, 139),
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
                    child: const Center(
                      child: Text(
                        "Adcionar Projeto",
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
                    child:
                        Input(label: "Endereço completo", controler: address),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      onChanged: (value) {
                        setState(() {
                          location.text = value!;                          
                        });
                      },
                      items: (filter, infiniteScrollProps) => locations,
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          iconClosed: Icon(Icons.keyboard_arrow_down),
                          iconOpened: Icon(Icons.keyboard_arrow_up),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          hintText: 'Local',
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            padding: EdgeInsets.all(AppConfig().radius),
                            decoration: InputDecoration(
                              hintText: "Pesquisar",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.5,
                                      color: AppConfig().primaryColor),
                                  borderRadius: BorderRadius.circular(
                                      AppConfig().radius)),
                            )),
                        itemBuilder: (context, item, isDisabled, isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppConfig().primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(AppConfig().radius),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.left,
                                )),
                          );
                        },
                        constraints: BoxConstraints(),
                        menuProps: MenuProps(
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConfig().radius))),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      onChanged: (value) {
                        setState(() {
                          goal = value!;
                        });
                      },
                      items: (filter, infiniteScrollProps) => optionsGoal,
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          iconClosed: Icon(Icons.keyboard_arrow_down),
                          iconOpened: Icon(Icons.keyboard_arrow_up),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          hintText: 'Objetivo',
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                          hintText: "Pesquisar",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.5, color: AppConfig().primaryColor),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius)),
                        )),
                        itemBuilder: (context, item, isDisabled, isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppConfig().primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(AppConfig().radius),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.left,
                                )),
                          );
                        },
                        constraints: BoxConstraints(),
                        menuProps: MenuProps(
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConfig().radius))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      onChanged: (value) {
                        status = value!;
                      },
                      items: (filter, infiniteScrollProps) => optionsStatus,
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          iconClosed: Icon(Icons.keyboard_arrow_down),
                          iconOpened: Icon(Icons.keyboard_arrow_up),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 2.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          hintText: 'Estado',
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                          hintText: "Pesquisar",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.5, color: AppConfig().primaryColor),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius)),
                        )),
                        itemBuilder: (context, item, isDisabled, isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppConfig().primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(AppConfig().radius),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.left,
                                )),
                          );
                        },
                        constraints: BoxConstraints(),
                        menuProps: MenuProps(
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConfig().radius))),
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
                  Align(
                    child: GestureDetector(
                      onTap: pickFile,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppConfig().primaryColor),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: files.isNotEmpty
                        ? Column(
                            children: files
                                .map((file) => file.endsWith('.png')
                                    ? Container(
                                        child: Container(
                                        child: const Text("png"),
                                      ))
                                    : Container(
                                        child: const Text(
                                            "outro tipo de ficheiro")))
                                .toList(),
                          )
                        : const Text("Nenhum Ficheiro"),
                  ),
                  // Container(
                  //   width: double.infinity,
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
