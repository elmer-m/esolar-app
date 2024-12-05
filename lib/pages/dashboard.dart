import 'package:eslar/pages/more/more.dart';
import 'package:eslar/pages/projects/addProject.dart';
import 'package:eslar/pages/home.dart';
import 'package:eslar/pages/auth/login.dart';
import 'package:eslar/pages/projects/projetcs.dart';
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
      floatingActionButton:
          selectedIndex == 1 ? FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProject()));
            },
            backgroundColor: AppConfig().primaryColor,
            child: Icon(Icons.add),) : null,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConfig().radius),
                color: AppConfig().primaryColor,
              ),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olá!",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "João Costa!",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    child: selectedIndex == 0
                        ? const Text(
                            "Inicio",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          )
                        : selectedIndex == 1
                            ? const Text(
                                "Projetos",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              )
                            : const Text(
                                "Conta",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                  )
                ],
              ),
            ),
            pages[selectedIndex],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConfig().radius),),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConfig().radius),
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
