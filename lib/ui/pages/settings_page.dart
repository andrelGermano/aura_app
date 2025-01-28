import 'dart:math'; // Para gerar números aleatórios
import 'package:aura_novo/data/motivationalPhrases.dart'; // Importação das frases motivacionais
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Notificações locais
import 'package:timezone/timezone.dart' as tz; // Gerenciamento de fuso horário
import 'package:timezone/data/latest.dart' as tz_data; // Dados de fuso horário
import 'package:firebase_auth/firebase_auth.dart'; // Autenticação Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // Banco de dados Firestore

// Tela de configurações
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();

  // Método público para cancelar notificações
  static void cancelNotifications(BuildContext context) {
    final _SettingsPageState state = context.findAncestorStateOfType<_SettingsPageState>()!;
    state._cancelNotificationsPrivate();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  bool isMotivationalModeEnabled = false; // Controle do modo motivacional
  int selectedHours = 0; // Horas selecionadas pelo usuário
  int selectedMinutes = 0; // Minutos selecionados pelo usuário

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; // Gerenciador de notificações
  late List<MotivationalPhrases> motivationalPhrases; // Lista de frases motivacionais

  final TextEditingController hoursController = TextEditingController(); // Controlador para horas
  final TextEditingController minutesController = TextEditingController(); // Controlador para minutos

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones(); // Inicializa fuso horário
    _initializeNotifications(); // Inicializa notificações
    motivationalPhrases = getPhrases(); // Carrega frases motivacionais
    hoursController.text = selectedHours.toString(); // Define horas no campo
    minutesController.text = selectedMinutes.toString(); // Define minutos no campo
    _loadMotivationalModeSettings(); // Carrega configurações salvas
  }

  // Método privado para cancelar notificações
  void _cancelNotificationsPrivate() async {
    await flutterLocalNotificationsPlugin.cancel(0); // Cancela notificações com ID 0
  }

  // Inicializa notificações e configura o canal
  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const androidNotificationChannel = AndroidNotificationChannel(
      'motivational_channel', // ID do canal
      'Motivational Notifications', // Nome do canal
      description: 'Envia frases motivacionais regularmente', // Descrição
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  // Agenda notificações motivacionais
  void _scheduleMotivationalNotifications() async {
    if (!isMotivationalModeEnabled) return; // Verifica se o modo está ativado

    final random = Random();
    final androidDetails = AndroidNotificationDetails(
      'motivational_channel',
      'Motivational Notifications',
      channelDescription: 'Envia frases motivacionais regularmente',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    final localTimeZone = tz.getLocation('America/Sao_Paulo'); // Define fuso horário
    final totalMinutes = selectedHours * 60 + selectedMinutes; // Calcula total de minutos

    // Hora atual no fuso especificado
    var now = tz.TZDateTime.now(localTimeZone);

    // Verifica se o intervalo é válido
    if (totalMinutes <= 0) {
      print('Intervalo inválido. Defina um horário maior que 0.');
      return;
    }

    // Calcula o próximo horário para notificação
    var nextScheduledTime = now.add(Duration(minutes: totalMinutes));
    while (nextScheduledTime.isBefore(now)) {
      nextScheduledTime = nextScheduledTime.add(Duration(minutes: totalMinutes));
    }

    final phrase = motivationalPhrases[random.nextInt(motivationalPhrases.length)].phrase;

    // Agenda a notificação
    if (isMotivationalModeEnabled) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Motivação do Dia',
        phrase,
        nextScheduledTime,
        NotificationDetails(android: androidDetails),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    print("\nNotificação programada para $nextScheduledTime com a frase: \"$phrase\"");

    // Reagenda automaticamente
    Future.delayed(Duration(minutes: totalMinutes), () {
      if (isMotivationalModeEnabled) {
        _scheduleMotivationalNotifications();
      }
    });
  }

  // Atualiza configurações no Firestore
  Future<void> _updateMotivationalModeSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuário não autenticado!");

      final motivationalSettings = {
        'isEnabled': isMotivationalModeEnabled,
        'hours': selectedHours,
        'minutes': selectedMinutes,
        'updatedAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('motivationalMode')
          .doc('settings')
          .set(motivationalSettings);
    } catch (e) {
      print("Erro ao salvar configurações: $e");
    }
  }

  // Carrega configurações do Firestore
  void _loadMotivationalModeSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuário não autenticado!");

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('motivationalMode')
          .doc('settings')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          isMotivationalModeEnabled = data['isEnabled'] ?? false;
          selectedHours = data['hours'] ?? 0;
          selectedMinutes = data['minutes'] ?? 0;
          hoursController.text = selectedHours.toString();
          minutesController.text = selectedMinutes.toString();
        });
      }
    } catch (e) {
      print("Erro ao carregar configurações: $e");
    }
  }

  // Verifica se a frequência é válida
  bool _isValidTime() {
    return selectedHours > 0 || selectedMinutes > 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isSaveButtonEnabled = _isValidTime(); // Habilita botão de salvar

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Modo Motivacional",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isMotivationalModeEnabled,
                  onChanged: (value) async {
                    setState(() {
                      isMotivationalModeEnabled = value;
                    });

                    // Salvar e reagendar notificações
                    await _updateMotivationalModeSettings();
                    if (isMotivationalModeEnabled) {
                      _scheduleMotivationalNotifications();
                    } else {
                      await flutterLocalNotificationsPlugin.cancelAll();
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Frequência das mensagens:"),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Horas'),
                        enabled: isMotivationalModeEnabled,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Minutos'),
                        enabled: isMotivationalModeEnabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: isSaveButtonEnabled
                  ? () async {
                await _updateMotivationalModeSettings();
                if (isMotivationalModeEnabled) _scheduleMotivationalNotifications();
              }
                  : null,
              child: const Text("Salvar Frequência"),
            ),
          ],
        ),
      ),
    );
  }
}
