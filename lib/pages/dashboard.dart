import 'package:Esolar/components/toPage.dart';
import 'package:Esolar/pages/more/more.dart';
import 'package:Esolar/pages/projects/addMaterial.dart';
import 'package:Esolar/pages/projects/addProject.dart';
import 'package:Esolar/pages/home.dart';
import 'package:Esolar/pages/auth/login.dart';
import 'package:Esolar/pages/projects/projects.dart';
import 'package:Esolar/pages/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/components/AppConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  List<String> userData = [];
  List<Widget> pages = [];
  bool loading = true;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await prefs.getStringList('userData');
    print(user);
    setState(() {
      userData.add(user![0]);
      userData.add(user[4]);
      userData.add(user[3]);
    });
    loading = false;
    pages = [
      Home(
        userFirstName: userData[0],
        companyName: userData[1],
        companyId: userData[2],
      ),
      Projects(companyId: userData[2],),
      More(),
    ];
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void onItemTapped(i) {
    setState(() {
      selectedIndex = i;
    });
  }

  Future<void> GoProject() async {
    print("ativou a função");
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddProject(companyId: userData[2],)));
    if (result != null) {
      setState(
        () {
          onItemTapped(1);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().overlayColor,
      floatingActionButton: selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                AppConfig().Bottom(
                    context,
                    "Adicionar",
                    Container(
                      child: Column(
                        children: [
                          ToPage(page: AddProject(companyId: userData[2],), pageLabel: "Projeto"),
                          ToPage(page: AddMaterial(), pageLabel: "Material")
                        ],
                      ),
                    ));
              },
              backgroundColor: AppConfig().primaryColor,
              child: Icon(Icons.add),
            )
          : null,
      body: loading
          ? Container()
          : Container(
              child: Column(
                children: [
                  pages[selectedIndex],
                ],
              ),
            ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig().radius),
        ),
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
