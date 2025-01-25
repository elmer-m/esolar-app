import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eslar/components/dropDown.dart';
import 'package:eslar/components/sendAttachment.dart';
import 'package:eslar/pages/projects/project.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:eslar/components/button.dart';
import 'package:eslar/components/input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddMaterial extends StatefulWidget {
  const AddMaterial({super.key});

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  TextEditingController material_name = TextEditingController();
  TextEditingController material_price = TextEditingController();
  bool uploading = false;
  Future<void> Create() async {
    final url = Uri.parse('https://tze.ddns.net:8108/newMaterial.php');
    try {
      setState(() {
        uploading = true;
      });
      var request = http.MultipartRequest('POST', url);
      request.fields['material_name'] = material_name.text;
      request.fields['material_price'] = material_price.text;
      var streamResponse = await request.send();

      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print("Deu certo:  ${response.body}");
      } else {
        print("Deu errado, erro: ${response.statusCode}");
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
      backgroundColor: AppConfig().overlayColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppConfig().primaryColor),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            width: double.infinity,
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
                      borderRadius: BorderRadius.circular(AppConfig().radius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Adicionar Material",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Input(
                            label: "Material",
                            controler: material_name,
                          ),
                          SizedBox(height: 10),
                          Input(
                            label: "Preço por unidade",
                            controler: material_price,
                            type: TextInputType.numberWithOptions(),
                          ),
                          SizedBox(height: 20),
                          Container(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
