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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppConfig().textColorW, width: 0.2),),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    pageLabel,
                    style: TextStyle(
                        color: AppConfig().textColorW,
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

// class PageList extends StatelessWidget {
//   final List<ToPage> pages;

//   const PageList({super.key, required this.pages});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: pages.length,
//       itemBuilder: (context, index) {
//         return ToPage(
//           page: pages[index],
//           pageLabel: pages[index].pageLabel,
//           isFirst: index == 0,
//           isLast: index == pages.length - 1,
//         );
//       },
//     );
//   }
// }