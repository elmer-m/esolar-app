import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Attachment extends StatefulWidget {
  final String label;
  final ValueChanged<List<String>>? onChanged;
  final bool isImageOnly;
  const Attachment(
      {super.key,
      required this.label,
      this.onChanged,
      required this.isImageOnly});

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  List<String> files = [];
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

  Future<void> pickFile() async {
    List<String> allowedExtensions =
        widget.isImageOnly ? ['jpg', 'jpeg', 'png', 'gif'] : ['pdf'];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: allowedExtensions,
        type: FileType.custom);
    if (result != null) {
      setState(() {
        files = result.files.map((file) => file.path!).toList();
      });
      // Chama o onChanged passando a lista de arquivos atualizada
      if (widget.onChanged != null) {
        widget.onChanged!(files);
      }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          child: files.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConfig().radius),
                      border: Border.all(
                          width: 0.2, color: AppConfig().textColorW)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 10,
                          spacing: 10, children: [
                          ...files.map(
                            (file) {
                              if (file.endsWith('.pdf')) {
                                return GestureDetector(
                                  onTap: () {
                                    AttachmentFocus(file);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              } else if (file.endsWith('.jpg') ||
                                  file.endsWith('.jpeg') ||
                                  file.endsWith('.png') ||
                                  file.endsWith('.gif')) {
                                return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: GestureDetector(
                                      onTap: () {
                                        AttachmentFocus(file);
                                      },
                                      child: Image.file(
                                        File(file),
                                        fit: BoxFit.cover,
                                      ),
                                    ));
                              } else {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Icon(
                                    Icons.insert_drive_file,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            },
                          ).toList(),
                        ]),
                        Center(
                          child: GestureDetector(
                            onTap: pickFile,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Icon(Icons.attachment, color: AppConfig().primaryColor,),)
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(50),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Text(
                              "Selecionar Ficheiro",
                              style: TextStyle(color: AppConfig().primaryColor),
                            ),
                          ),
                          Icon(
                            Icons.attachment,
                            color: AppConfig().primaryColor,
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppConfig().radius)),
                  ),
                ),
        ),
      ],
    );
  }
}
