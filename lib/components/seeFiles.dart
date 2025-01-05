import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SeeFiles extends StatefulWidget {
  var files;
  SeeFiles({super.key, required this.files});

  @override
  State<SeeFiles> createState() => _SeeFilesState();
}

class _SeeFilesState extends State<SeeFiles> {
  Future<void> AttachmentFocus(valueFile) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isPdf(List<int> valueToAnalyze) {
          return 
              valueToAnalyze.length >= 4 &&
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
                        borderRadius:
                            BorderRadius.circular(AppConfig().radius)),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: widget.files.map<Widget>(
          (fileBase64) {
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
                      onTap: () => AttachmentFocus(uint8List),
                      child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 50,),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: GestureDetector(
                      onTap: () => AttachmentFocus(uint8List),
                      child: Image.memory(uint8List),
                    ),
                  );
          },
        ).toList(),
      ),
    );
  }
}
