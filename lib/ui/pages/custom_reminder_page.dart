import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';

import '../../services/notification_service.dart';

class CustomReminderPage extends StatefulWidget {
  const CustomReminderPage({super.key});

  @override
  _CustomReminderPageState createState() => _CustomReminderPageState();
}

class _CustomReminderPageState extends State<CustomReminderPage> {
  final TextEditingController _reminderNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _repeatDaily = false;
  bool _vibrationEnabled = false;

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  late final NotificationService _notificationService;


  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _initializeNotifications();
    _requestNotificationPermissions();

    // Garante que a coleção reminders exista para o usuário
    _notificationService.initializeRemindersCollection();
  }

  void _initializeNotifications() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo')); // Ajuste o fuso horário

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationsPlugin.initialize(settings);

    // Criação do canal de notificações
    const androidNotificationChannel = AndroidNotificationChannel(
      'lembrete_channel', // ID do canal
      'Lembretes', // Nome do canal
      description: 'Canal para notificações de lembretes',
      importance: Importance.high,
    );

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> _requestNotificationPermissions() async {
    // Permissão de notificação
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão para notificações negada!")),
      );
      return;
    }

    // Permissão para alarmes exatos (Android 12+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão para alarmes exatos negada!")),
        );
        return;
      }
    }
  }

  Future<void> _scheduleNotification(String title, TimeOfDay time) async {
    final scheduleTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );

    final tzDateTime = tz.TZDateTime.from(scheduleTime, tz.local);

    print("Agendando notificação para: $tzDateTime");

    await _notificationsPlugin.zonedSchedule(
      0, // Use um ID único para evitar sobreposição
      'Lembrete: $title',
      'Está na hora do lembrete!',
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lembrete_channel', // ID do canal
          'Lembretes',
          channelDescription: 'Canal para notificações de lembretes',
          priority: Priority.high,
          importance: Importance.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Útil para repetir diariamente
    );
  }

  Future<void> _saveReminder() async {
    if (_reminderNameController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    try {
      await _notificationService.addReminder(
        name: _reminderNameController.text,
        time: _selectedTime!.format(context),
        repeatDaily: _repeatDaily,
        vibration: _vibrationEnabled,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Lembrete \"${_reminderNameController.text}\" salvo para ${_selectedTime!.format(context)}.",
          ),
        ),
      );

      setState(() {
        _reminderNameController.clear();
        _selectedTime = null;
        _repeatDaily = false;
        _vibrationEnabled = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar lembrete: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lembretes Personalizáveis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _reminderNameController,
              decoration: const InputDecoration(
                labelText: "Nome do Lembrete",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime != null
                      ? "Hora selecionada: ${_selectedTime!.format(context)}"
                      : "Nenhuma hora selecionada",
                ),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text("Escolher Hora"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Repetir diariamente"),
              value: _repeatDaily,
              onChanged: (value) {
                setState(() {
                  _repeatDaily = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Habilitar vibração"),
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _notificationService.getRemindersStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reminders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(reminder['name']),
                        subtitle: Text(reminder['time']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _notificationService.deleteReminder(reminders[index].id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveReminder,
                child: const Text("Salvar Lembrete"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
