import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'AppConfig.dart';

class SeeFiles extends StatefulWidget {
  var files = [];
  bool forRemove;
  bool addMore;
  final ValueChanged<List<String>>? onChanged;
  SeeFiles(
      {super.key,
      required this.files,
      this.forRemove = false,
      this.onChanged,
      this.addMore = false});

  @override
  State<SeeFiles> createState() => _SeeFilesState();
}

class _SeeFilesState extends State<SeeFiles> {
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      // Converte os arquivos em base64
      List<String> base64Files = result.files.map((file) {
        File pickedFile = File(file.path!); // Obtem o arquivo
        Uint8List fileBytes = pickedFile.readAsBytesSync(); // Lê os bytes
        return base64Encode(fileBytes); // Codifica em base64
      }).toList();

      setState(() {
        widget.files =
            (widget.files ?? []) + base64Files; // Atualiza os arquivos
      });

      // Chama o onChanged passando a lista de arquivos atualizada
      if (widget.onChanged != null) {
        widget.onChanged!(widget.files as List<String>);
      }
    } else {
      // Exibe o diálogo de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Nenhum arquivo foi selecionado."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.2),
        borderRadius: BorderRadius.circular(AppConfig().radius),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          widget.files.isNotEmpty
              ? Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: widget.files.asMap().entries.map<Widget>(
                    (entry) {
                      int myIndex = entry.key; // Pega o índice atual
                      String fileBase64 = entry.value; // Pega o valor atual
                      Uint8List uint8List = base64Decode(fileBase64);

                      bool isPdf(List<int> fileBytes) {
                        return fileBytes.length >= 4 &&
                            fileBytes[0] == 0x25 &&
                            fileBytes[1] == 0x50 &&
                            fileBytes[2] == 0x44 &&
                            fileBytes[3] == 0x46;
                      }

                      return isPdf(uint8List)
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: GestureDetector(
                                onTap: () {
                                  AttachmentFocus(uint8List);
                                },
                                onDoubleTap: () {
                                  if (widget.forRemove) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmar"),
                                          content: Text(
                                            "Tem certeza que deseja apagar a imagem?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
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
                                                setState(() {
                                                  (widget.files as List)
                                                      .removeAt(myIndex);
                                                });
                                                Navigator.of(context).pop();
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
                                      },
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: GestureDetector(
                                onTap: () {
                                  AttachmentFocus(uint8List);
                                },
                                onDoubleTap: () {
                                  if (widget.forRemove) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmar"),
                                          content: Text(
                                            "Tem certeza que deseja apagar a imagem?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
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
                                                setState(() {
                                                  (widget.files as List)
                                                      .removeAt(myIndex);
                                                });
                                                Navigator.of(context).pop();
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
                                      },
                                    );
                                  }
                                },
                                child: Image.memory(uint8List),
                              ),
                            );
                    },
                  ).toList(),
                )
              : Center(
                  child: Text("N/A."),
                ),
          widget.addMore
              ? Center(
                  child: GestureDetector(
                      onTap: pickFile,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.attachment,
                          color: AppConfig().primaryColor,
                        ),
                      )),
                )
              : Container(),
        ],
      ),
    );
  }
}
