import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';

import '../../services/reminder_service.dart';

// Tela para criar lembretes personalizados
class CustomReminderPage extends StatefulWidget {
  const CustomReminderPage({super.key});

  @override
  _CustomReminderPageState createState() => _CustomReminderPageState();
}

class _CustomReminderPageState extends State<CustomReminderPage> {
  // Controlador para o nome do lembrete
  final TextEditingController _reminderNameController = TextEditingController();

  TimeOfDay? _selectedTime; // Armazena o horário selecionado
  bool _repeatDaily = false; // Define se o lembrete será diário
  bool _vibrationEnabled = false; // Define se a vibração está habilitada

  late FlutterLocalNotificationsPlugin _notificationsPlugin; // Gerencia notificações locais
  late final ReminderService _notificationService; // Serviço para gerenciar lembretes no Firestore

  @override
  void initState() {
    super.initState();
    _notificationService = ReminderService();
    _initializeNotifications(); // Inicializa notificações
    _requestNotificationPermissions(); // Solicita permissões

    // Garante que a coleção `reminders` existe para o usuário atual
    _notificationService.initializeRemindersCollection();
  }

  // Configuração inicial do sistema de notificações
  void _initializeNotifications() {
    tz_data.initializeTimeZones(); // Inicializa os fusos horários
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo')); // Define o fuso horário local

    const android = AndroidInitializationSettings('@mipmap/ic_launcher'); // Configuração Android
    const settings = InitializationSettings(android: android);

    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationsPlugin.initialize(settings);

    // Criação do canal de notificações para o Android
    const androidNotificationChannel = AndroidNotificationChannel(
      'lembrete_channel', // ID do canal
      'Lembretes', // Nome do canal
      description: 'Canal para notificações de lembretes',
      importance: Importance.high, // Alta prioridade
    );

    // Registra o canal de notificações
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  // Solicitação de permissões para notificações e alarmes
  Future<void> _requestNotificationPermissions() async {
    // Permissão para notificações
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão para notificações negada!")),
      );
      return;
    }

    // Permissão para alarmes exatos (apenas Android 12+)
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

  // Agendamento de uma notificação
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
      1, // ID único para evitar sobreposição de notificações
      'Lembrete: $title', // Título da notificação
      'Não esqueça!', // Corpo da notificação
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lembrete_channel', // ID do canal
          'Lembretes', // Nome do canal
          channelDescription: 'Canal para notificações de lembretes',
          priority: Priority.high,
          importance: Importance.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact, // Modo de agendamento exato
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Útil para repetições diárias
    );
  }

  // Salvando o lembrete no Firestore e agendando a notificação
  Future<void> _saveReminder() async {
    if (_reminderNameController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    try {
      // Adiciona o lembrete ao Firestore
      await _notificationService.addReminder(
        name: _reminderNameController.text,
        time: _selectedTime!.format(context),
        repeatDaily: _repeatDaily,
        vibration: _vibrationEnabled,
      );

      // Agenda a notificação
      await _scheduleNotification(
        _reminderNameController.text,
        _selectedTime!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Lembrete \"${_reminderNameController.text}\" salvo para ${_selectedTime!.format(context)}.",
          ),
        ),
      );

      // Reseta os campos após salvar o lembrete
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
    final user = FirebaseAuth.instance.currentUser; // Usuário autenticado

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lembretes Personalizáveis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para o nome do lembrete
            TextField(
              controller: _reminderNameController,
              decoration: const InputDecoration(
                labelText: "Nome do Lembrete",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Escolha de horário
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime != null
                      ? "Hora selecionada: ${_selectedTime!.format(context)}"
                      : "Nenhuma hora selecionada",
                ),
                ElevatedButton(
                  onPressed: _pickTime, // Abre o seletor de horário
                  child: const Text("Escolher Hora"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Alternativas para repetir diariamente e ativar vibração
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
            // Lista de lembretes salvos
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
                            // Cancela a notificação agendada
                            await _notificationsPlugin.cancel(1);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Botão para salvar lembrete
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

  // Função para selecionar horário
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
