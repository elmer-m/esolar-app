import 'package:flutter/material.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dropdown extends StatefulWidget {
  final List<String> data;
  final String label;
  bool search;
  final Function(String) onChanged;

  Dropdown({
    super.key,
    required this.data,
    required this.label,
    required this.onChanged,
    this.search = false,
  });

  @override
  State<Dropdown> createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  String selectedValue = "";

  void setValue(String value) {
    setState(() {
      selectedValue = value;
    });
    widget.onChanged(value);
}


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownSearch<String>(
        onChanged: (value) {
          widget.onChanged(value!);
        },
        items: (filter, infiniteScrollProps) => widget.data,
        suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
            iconClosed: Icon(Icons.keyboard_arrow_down),
            iconOpened: Icon(Icons.keyboard_arrow_up),
          ),
        ),
        selectedItem: selectedValue.isEmpty ? null : selectedValue,
        decoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppConfig().textColorW, width: 1.5),
              borderRadius: BorderRadius.circular(AppConfig().radius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppConfig().primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(AppConfig().radius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppConfig().textColorW, width: 1.5),
              borderRadius: BorderRadius.circular(AppConfig().radius),
            ),
            hintText: widget.label,
          ),
        ),
        popupProps: PopupPropsMultiSelection.bottomSheet(
          showSearchBox: widget.search,
          checkBoxBuilder: (context, item, isDisabled, isSelected) {
            return Checkbox(
              value: isSelected,
              onChanged: (bool? selected) {
                if (selected != null) {}
              },
              activeColor: AppConfig().primaryColor,
              checkColor: Colors.white,
            );
          },
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.2, color: AppConfig().textColorW),
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          },
          bottomSheetProps: BottomSheetProps(
            shape: Border.all(color: AppConfig().textColorW, width: 0.2),
            backgroundColor: AppConfig().backgroundColor,
          ),
        ),
      ),
    );
  }
}
