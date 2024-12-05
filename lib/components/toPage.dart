import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

class ToPage extends StatelessWidget {
  final Widget page;
  final String pageLabel;
  const ToPage({super.key, required this.page, required this.pageLabel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppConfig().primaryColor,
          borderRadius: BorderRadius.circular(AppConfig().radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    pageLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
