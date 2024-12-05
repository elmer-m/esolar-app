import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

class Dropdown extends StatefulWidget {
  final String initialValue;
  final List<String> data;
  final String label;
  final double padding;
  final void Function(String)? onChanged;

  const Dropdown({
    super.key,
    this.initialValue = "",
    required this.data,
    required this.label,
    this.onChanged,
    this.padding = 7
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue; // Inicializa com o valor inicial
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig().radius),
          border: Border.all(color: AppConfig().primaryColor, width: 2.5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: selectedValue.isNotEmpty ? selectedValue : null,
          isExpanded: true,
          hint: Text(widget.label),
          items: widget.data.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
            widget.onChanged!(newValue!);
          },
        ),
      ),
    );
  }
}
