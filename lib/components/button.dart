import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback func;
  final bool outlined;
  final Color colorChoose;
  bool loading;

  Button(
      {super.key,
      required this.text,
      this.loading = false,
      required this.func,
      this.outlined = false,
      this.colorChoose = const Color.fromRGBO(255, 93, 7, 1)});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool loading = false; // Corrigido para usar 'loading' em vez de 'Loading'

  @override
  Widget build(BuildContext context) {
    return widget.outlined
        ? SizedBox(
            height: 45,
            child: OutlinedButton(
              onPressed: widget.func,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent, // Fundo transparente
                side: BorderSide(
                  color: widget.colorChoose,
                  width: 3,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                ),
              ),
              child: widget.loading
                  ? FittedBox(
                      child: CircularProgressIndicator(
                        color: AppConfig().primaryColor,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.colorChoose,
                      ),
                    ),
            ),
          )
        : SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: widget.func,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.colorChoose,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig().radius),
                ),
              ),
              child: widget.loading
                  ? const FittedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Cor do texto para o botão normal
                      ),
                    ),
            ),
          );
  }
}
