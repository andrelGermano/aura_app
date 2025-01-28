import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Garante que cada usuário tenha um espaço inicial para lembretes no Firestore.
  Future<void> initializeRemindersCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!"); // Evita execução sem autenticação.
    }

    final remindersCollection = _firestore.collection('users').doc(user.uid).collection('reminders');

    // Caso o usuário seja novo, fornece um ponto de partida para lembretes.
    final snapshot = await remindersCollection.limit(1).get();
    if (snapshot.docs.isEmpty) {
      // Cria um lembrete de exemplo para orientar o uso inicial.
      await remindersCollection.doc('template').set({
        'name': 'Exemplo de lembrete',
        'time': '08:00 AM',
        'repeatDaily': false,
        'vibration': false,
        'createdAt': Timestamp.now(),
      });
    }
  }

  /// Facilita a adição de lembretes no Firestore com dados essenciais para personalização.
  Future<void> addReminder({
    required String name,
    required String time,
    required bool repeatDaily,
    required bool vibration,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!"); // Garante que apenas usuários válidos possam adicionar lembretes.
    }

    final reminder = {
      'name': name, // Identifica o propósito do lembrete.
      'time': time, // Define quando ele deve ser acionado.
      'repeatDaily': repeatDaily, // Oferece suporte a repetições diárias.
      'vibration': vibration, // Inclui personalização com ou sem vibração.
      'createdAt': Timestamp.now(), // Armazena o momento de criação para ordenação ou histórico.
    };

    await _firestore.collection('users').doc(user.uid).collection('reminders').add(reminder);
  }

  /// Permite que o usuário remova um lembrete específico, fornecendo controle total sobre suas notificações.
  Future<void> deleteReminder(String reminderId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    await _firestore.collection('users').doc(user.uid).collection('reminders').doc(reminderId).delete();
  }

  /// Oferece um fluxo contínuo de lembretes atualizados, ideal para sincronização em tempo real.
  Stream<QuerySnapshot> getRemindersStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    return _firestore.collection('users').doc(user.uid).collection('reminders').snapshots();
  }
}
