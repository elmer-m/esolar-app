import 'package:eslar/pages/more/more.dart';
import 'package:eslar/pages/projects/addProject.dart';
import 'package:eslar/pages/home.dart';
import 'package:eslar/pages/auth/login.dart';
import 'package:eslar/pages/projects/projects.dart';
import 'package:eslar/pages/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:eslar/components/AppConfig.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  static const List<Widget> pages = <Widget>[
    Home(),
    Projects(),
    More(),
  ];

  void onItemTapped(i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().overlayColor,
      floatingActionButton:
          selectedIndex == 1 ? FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProject()));
            },
            backgroundColor: AppConfig().primaryColor,
            child: Icon(Icons.add),) : null,
      body: Container(
        
        child: Column(
          children: [
              pages[selectedIndex],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConfig().radius),),
        child: ClipRRect(
          child: BottomNavigationBar(
            selectedItemColor: Colors.white,
            selectedFontSize: 15,
            unselectedFontSize: 10,
            showUnselectedLabels: false,
            onTap: onItemTapped,
            currentIndex: selectedIndex,
            backgroundColor: AppConfig().primaryColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Início",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.folder,
                ),
                label: "Projetos",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "Mais"),
            ],
          ),
        ),
      ),
    );
  }
}
