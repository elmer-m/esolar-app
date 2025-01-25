// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppConfig {
  final Color primaryColor = const Color.fromRGBO(255, 93, 7, 1);
  final Color overlayColor = const Color.fromARGB(255, 240, 240, 240);
  final Color backgroundColor = Colors.white;
  final Color textColorW = const Color.fromARGB(255, 50, 50, 50);
  final double radius = 15;
  final double padidng = 20;
  void Bottom(BuildContext context, String label, Widget Cont) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: AppConfig().overlayColor,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: double.infinity,
                child: Text(
                  label,
                  style: TextStyle(
                      color: AppConfig().textColorW,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Cont,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> attachmentFocus(valueFile, context) async {
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
  
}
