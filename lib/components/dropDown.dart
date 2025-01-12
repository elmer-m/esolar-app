import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dropdown extends StatefulWidget {
  final List<String> data;
  final String label;
  final Function(String) onChanged;

  const Dropdown({
    super.key,
    required this.data,
    required this.label,
    required this.onChanged,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String selectedValue;

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
                      decoratorProps: DropDownDecoratorProps(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().textColorW, width: 1.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().primaryColor, width: 1.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConfig().textColorW, width: 1.5),
                            borderRadius:
                                BorderRadius.circular(AppConfig().radius),
                          ),
                          hintText: widget.label,
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                          hintText: "Pesquisar",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5, color: AppConfig().primaryColor),
                              borderRadius:
                                  BorderRadius.circular(AppConfig().radius),),
                        ),),
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
                  );
  }
}
