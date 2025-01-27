import 'dart:math';
import 'package:aura_novo/ui/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aura_novo/services/auth_service.dart';
import 'package:aura_novo/ui/pages/custom_reminder_page.dart';
import 'package:aura_novo/ui/pages/other_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/activities.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Activity> activities;

  String currentActivityName = '';
  String currentActivityDescription = '';
  String currentActivityImage = '';

  @override
  void initState() {
    super.initState();
    activities = getActivities(); // Carregando as atividades da lista
    _loadDailyActivity();
  }

  // Função para carregar ou gerar a atividade do dia
  Future<void> _loadDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityDate = prefs.getString('lastActivityDate');
    final currentDate = DateTime.now().toString().substring(0, 10);

    if (lastActivityDate != currentDate) {
      // Se a data for diferente, gera uma nova atividade
      _changeActivity();
      prefs.setString('lastActivityDate', currentDate);
    } else {
      // Se a data for igual, mantém a atividade do dia
      setState(() {
        currentActivityName = prefs.getString('currentActivityName') ?? 'Alongamento';
        currentActivityDescription = prefs.getString('currentActivityDescription') ?? 'Alongue-se para melhorar sua flexibilidade e relaxar os músculos.';
        currentActivityImage = prefs.getString('currentActivityImage') ?? 'assets/images/stretching.png';
      });
    }
  }

  // Função para alterar a atividade aleatoriamente
  void _changeActivity() async {
    final random = Random();
    final activity = activities[random.nextInt(activities.length)];

    setState(() {
      currentActivityName = activity.name;
      currentActivityDescription = activity.description;
      currentActivityImage = activity.image;
    });

    // Salvar a atividade do dia no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentActivityName', currentActivityName);
    prefs.setString('currentActivityDescription', currentActivityDescription);
    prefs.setString('currentActivityImage', currentActivityImage);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/ic_launcher_foreground.png", // Logo
          height: 75,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Olá! Aqui está a sugestão do dia:",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center, // Centralizando o texto
                  ),
                  SizedBox(height: 20),
                  Image.asset(currentActivityImage, height: 200),
                  SizedBox(height: 20),
                  Text(
                    currentActivityName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // Centralizando o nome da atividade
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentActivityDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center, // Centralizando a descrição
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changeActivity,
                    child: Text("Mudar Atividade"),
                  ),
                ],
              ),
            ),
          ),
          CustomReminderPage(),
          OtherPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Seja bem-vindo!"),
              accountEmail: Text(authService.getCurrentUserEmail() ?? "Email não disponível"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ic_launcher_foreground.png'),
              ),
            ),
            ListTile(
              title: Text("Sair"),
              onTap: () {
                authService.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
