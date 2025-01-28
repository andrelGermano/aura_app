import 'dart:math';
import 'package:aura_novo/ui/pages/history_page.dart';
import 'package:aura_novo/ui/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aura_novo/services/auth_service.dart';
import 'package:aura_novo/ui/pages/reminder_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/activities.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controla o índice da página atual
  int _selectedIndex = 0;

  // Chave global para controlar o Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Gerenciador de notificações locais
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  late List<Activity> activities; // Lista de atividades carregadas do banco de dados

  // Informações da atividade do dia
  String currentActivityName = '';
  String currentActivityDescription = '';
  String currentActivityImage = '';

  @override
  void initState() {
    super.initState();
    activities = getActivities(); // Carrega a lista de atividades
    _loadDailyActivity(); // Inicializa a atividade do dia
  }

  // Carrega a atividade do dia, verificando a persistência em SharedPreferences
  Future<void> _loadDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityDate = prefs.getString('lastActivityDate');
    final currentDate = DateTime.now().toString().substring(0, 10); // Data atual no formato yyyy-MM-dd

    if (lastActivityDate != currentDate) {
      // Se a data mudou, gera uma nova atividade
      _changeActivity();
      prefs.setString('lastActivityDate', currentDate); // Atualiza a data em SharedPreferences
    } else {
      // Recupera a atividade salva para o dia
      setState(() {
        currentActivityName = prefs.getString('currentActivityName') ?? 'Alongamento';
        currentActivityDescription = prefs.getString('currentActivityDescription') ??
            'Alongue-se para melhorar sua flexibilidade e relaxar os músculos.';
        currentActivityImage = prefs.getString('currentActivityImage') ?? 'assets/images/stretching.png';
      });
    }
  }

  // Gera uma nova atividade aleatória e salva em SharedPreferences
  void _changeActivity() async {
    final random = Random();
    final activity = activities[random.nextInt(activities.length)];

    setState(() {
      currentActivityName = activity.name;
      currentActivityDescription = activity.description;
      currentActivityImage = activity.image;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentActivityName', currentActivityName);
    prefs.setString('currentActivityDescription', currentActivityDescription);
    prefs.setString('currentActivityImage', currentActivityImage);
  }

  // Atualiza o índice da página selecionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o serviço de autenticação
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Cor de fundo
      appBar: AppBar(
        title: Image.asset(
          "assets/images/ic_launcher_foreground.png", // Mostra o logo no centro
          height: 75,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30), // Botão para abrir o menu lateral
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: IndexedStack(
        // Gerencia as páginas da navegação inferior
        index: _selectedIndex,
        children: [
          Center(
            // Página inicial com sugestão do dia
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Olá! Aqui está a sugestão do dia:",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.asset(currentActivityImage, height: 200), // Imagem da atividade
                  SizedBox(height: 20),
                  Text(
                    currentActivityName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentActivityDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changeActivity, // Botão para mudar a atividade
                    child: Text("Mudar Atividade"),
                  ),
                ],
              ),
            ),
          ),
          CustomReminderPage(), // Página de lembretes
          HistoryPage(), // Página de histórico
          SettingsPage(), // Página de configurações
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        // Barra de navegação inferior
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      drawer: Drawer(
        // Menu lateral
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              // Cabeçalho do menu lateral
              accountName: Text("Seja bem-vindo!"),
              accountEmail: Text(authService.getCurrentUserEmail() ?? "Email não disponível"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ic_launcher_foreground.png'),
              ),
            ),
            ListTile(
              title: Text("Sair"), // Opção de sair
              onTap: () {
                showDialog(
                  // Confirmação antes de sair
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Tem certeza?"),
                      content: Text("Você tem certeza que deseja sair?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Fecha o diálogo
                          },
                          child: Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            authService.signOut(); // Faz logout
                            Navigator.pop(context); // Fecha o menu
                            Navigator.pop(context); // Fecha a tela atual
                            _notificationsPlugin.cancelAll(); // Cancela notificações
                            SettingsPage.cancelNotifications(context); // Remove notificações agendadas
                          },
                          child: Text("Confirmar"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
