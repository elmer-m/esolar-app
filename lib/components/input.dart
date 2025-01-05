import 'package:eslar/components/AppConfig.dart';
import 'package:flutter/material.dart';


class Input extends StatelessWidget {
  final String label;
  final TextEditingController controler;
  final TextInputType type;
  final bool onlyRead;
  final VoidCallback? function;

  const Input({super.key, required this.label, required this.controler, this.type = TextInputType.text, this.onlyRead = false, this.function});
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: function,
      readOnly: onlyRead,
      controller: controler,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: AppConfig().primaryColor),        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig().radius),
          borderSide: const BorderSide(
            color: Colors.blue, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig().radius),
            borderSide: BorderSide(color: AppConfig().textColorW, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig().radius),
            borderSide:  BorderSide(color: AppConfig().primaryColor, width: 1.5),
          ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}