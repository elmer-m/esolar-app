import 'package:Esolar/pages/auth/register.dart';
import 'package:Esolar/pages/dashboard.dart';
import 'package:Esolar/pages/projects/addProject.dart';
import 'package:flutter/material.dart';
import 'package:Esolar/pages/auth/login.dart';
import 'package:Esolar/pages/projects/startVisit.dart';
import 'package:Esolar/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await prefs.getStringList('userData');

    print(user);
    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: Button(
                  text: "Entrar",
                  func: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: double.infinity,
                child: Button(
                  outlined: true,
                  text: "Registar",
                  func: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
