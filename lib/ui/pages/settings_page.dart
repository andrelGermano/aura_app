import 'dart:math';
import 'package:aura_novo/data/motivationalPhrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isMotivationalModeEnabled = false;
  int selectedHours = 0; // Hora padrão
  int selectedMinutes = 0; // Minutos padrão
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
    hoursController.text = selectedHours.toString(); // Inicializa com o valor padrão de horas
    minutesController.text = selectedMinutes.toString(); // Inicializa com o valor padrão de minutos
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Criação do canal de notificações para Android
    const androidNotificationChannel = AndroidNotificationChannel(
      'motivational_channel', // ID do canal
      'Motivational Notifications',
      description: 'Envia frases motivacionais regularmente',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void _scheduleMotivationalNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
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

    final totalMinutes = selectedHours * 60 + selectedMinutes; // Calcula o total de minutos
    print("\n\n\n\n\n\n\nNotificação agendada com frequência de $selectedHours horas e $selectedMinutes minutos.\n\n\n\n\n\n\n");

    // Pega o horário atual no fuso correto de São Paulo
    final now = tz.TZDateTime.now(localTimeZone);

    // Agendar a primeira notificação
    final firstScheduledTime = now.add(Duration(minutes: totalMinutes));

    final phrase = motivationalPhrases[random.nextInt(motivationalPhrases.length)].phrase;

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Motivação do Dia',
      phrase,
      firstScheduledTime,
      NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print("\n\n\n\n\n\n\nNotificação programada para $firstScheduledTime com a frase: \"$phrase\"\n\n\n\n\n\n\n");

    // Agendar a próxima notificação no mesmo intervalo
    final nextScheduledTime = firstScheduledTime.add(Duration(minutes: totalMinutes));
    flutterLocalNotificationsPlugin.zonedSchedule(
      1,  // ID diferente para a próxima notificação
      'Motivação do Dia',
      motivationalPhrases[random.nextInt(motivationalPhrases.length)].phrase,
      nextScheduledTime,
      NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("\n\n\n\n\n\n\nPróxima notificação programada para $nextScheduledTime.\n\n\n\n\n\n\n");
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) {
                    setState(() {
                      isMotivationalModeEnabled = value;
                    });

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
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Frequência das mensagens:",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    // Campo para horas
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Horas',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedHours = int.tryParse(value) ?? 0;
                              print("\n\n\n\n\n\n\nHora alterada para: $selectedHours\n\n\n\n\n\n\n");
                            });
                          }
                        },
                        enabled: isMotivationalModeEnabled, // Desabilita o campo
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Campo para minutos
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Minutos',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedMinutes = int.tryParse(value) ?? 0;
                              print("\n\n\n\n\n\n\nMinutos alterados para: $selectedMinutes\n\n\n\n\n\n\n");
                            });
                          }
                        },
                        enabled: isMotivationalModeEnabled, // Desabilita o campo
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Modo Motivacional: $isMotivationalModeEnabled"); // Verificar o valor
                _scheduleMotivationalNotifications();
              },
              child: const Text("Salvar Frequência"),
            ),
          ],
        ),
      ),
    );
  }
}
