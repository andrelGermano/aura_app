import 'dart:math';
import 'package:aura_novo/data/motivationalPhrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isMotivationalModeEnabled = false;

  int selectedHours = 0;
  int selectedMinutes = 0;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late List<MotivationalPhrases> motivationalPhrases;

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones();
    _initializeNotifications();
    motivationalPhrases = getPhrases(); // Carregar as frases no initState
    hoursController.text = selectedHours.toString();
    minutesController.text = selectedMinutes.toString();
    _loadMotivationalModeSettings(); // Novo método para carregar do Firestore
  }

  // Método privado para cancelar as notificações
  void _cancelNotificationsPrivate() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    const androidNotificationChannel = AndroidNotificationChannel(
      'motivational_channel',
      'Motivational Notifications',
      description: 'Envia frases motivacionais regularmente',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void _scheduleMotivationalNotifications() async {

    if (!isMotivationalModeEnabled) return;

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

    final localTimeZone = tz.getLocation('America/Sao_Paulo'); // Ajuste para sua timezone
    final totalMinutes = selectedHours * 60 + selectedMinutes;

    // Pega o horário atual no fuso correto de São Paulo
    var now = tz.TZDateTime.now(localTimeZone);

    // Verifica se o intervalo é válido
    if (totalMinutes <= 0) {
      print('Intervalo inválido. Defina um horário maior que 0.');
      return;
    }

    // Calcula o próximo horário para agendamento
    var nextScheduledTime = now.add(Duration(minutes: totalMinutes));

    // Verifica se o horário está no passado e ajusta, se necessário
    while (nextScheduledTime.isBefore(now)) {
      nextScheduledTime = nextScheduledTime.add(Duration(minutes: totalMinutes));
    }

    final phrase = motivationalPhrases[random.nextInt(motivationalPhrases.length)].phrase;

    if(isMotivationalModeEnabled){
      // Agenda a notificação
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Motivação do Dia',
        phrase,
        nextScheduledTime,
        NotificationDetails(android: androidDetails),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    print("\nNotificação programada para $nextScheduledTime com a frase: \"$phrase\"");

    // Reagendar a próxima notificação automaticamente
    Future.delayed(Duration(minutes: totalMinutes), () {
      if (isMotivationalModeEnabled) {
        _scheduleMotivationalNotifications();
      }
    });
  }

  Future<void> _updateMotivationalModeSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não autenticado!");
      }

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
          .doc('settings') // Documento único para as configurações
          .set(motivationalSettings);
    } catch (e) {
      print("Erro ao salvar configurações: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar configurações: $e")),
      );
    }
  }

  void _loadMotivationalModeSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não autenticado!");
      }

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

  bool _isValidTime() {
    // Verifica se os valores de horas e minutos são diferentes de 0
    return selectedHours > 0 || selectedMinutes > 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isSaveButtonEnabled = _isValidTime();

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

                    // Salvar no Firestore
                    await _updateMotivationalModeSettings();

                    // Exibir SnackBar para mostrar que o modo foi alterado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isMotivationalModeEnabled
                              ? 'Modo Motivacional ativado!'
                              : 'Modo Motivacional desativado!',
                        ),
                      ),
                    );

                    // Agendar ou cancelar notificações com base no estado
                    if (isMotivationalModeEnabled) {
                      _scheduleMotivationalNotifications();
                    } else {
                      // Cancelar todas as notificações agendadas
                      await flutterLocalNotificationsPlugin.cancelAll();
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Frequência das mensagens:\n",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Horas',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Verificar se o valor é um número inteiro
                          if (value.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(value)) {
                            setState(() {
                              selectedHours = int.parse(value);
                            });
                          } else {
                            // Limpar a entrada caso não seja número inteiro
                            hoursController.clear();
                          }
                        },
                        enabled: isMotivationalModeEnabled,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Minutos',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Verificar se o valor é um número inteiro
                          if (value.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(value)) {
                            setState(() {
                              selectedMinutes = int.parse(value);
                            });
                          } else {
                            // Limpar a entrada caso não seja número inteiro
                            minutesController.clear();
                          }
                        },
                        enabled: isMotivationalModeEnabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaveButtonEnabled
                  ? () async {
                await _updateMotivationalModeSettings();

                if (isMotivationalModeEnabled) {
                  _scheduleMotivationalNotifications();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Configurações salvas com sucesso!")),
                );
              }
                  : null, // Desabilita o botão se as condições não forem atendidas
              child: const Text("Salvar Frequência"),
            ),
          ],
        ),
      ),
    );
  }
}
