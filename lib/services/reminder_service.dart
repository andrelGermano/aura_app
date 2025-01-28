import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cria o documento `reminders` para o usuário se não existir
  Future<void> initializeRemindersCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final remindersCollection = _firestore.collection('users').doc(user.uid).collection('reminders');

    // Verifica se a coleção `reminders` está vazia
    final snapshot = await remindersCollection.limit(1).get();
    if (snapshot.docs.isEmpty) {
      // Adiciona um documento inicial (opcional)
      await remindersCollection.doc('template').set({
        'name': 'Exemplo de lembrete',
        'time': '08:00 AM',
        'repeatDaily': false,
        'vibration': false,
        'createdAt': Timestamp.now(),
      });
    }
  }

  /// Adiciona um novo lembrete no Firestore
  Future<void> addReminder({
    required String name,
    required String time,
    required bool repeatDaily,
    required bool vibration,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final reminder = {
      'name': name,
      'time': time,
      'repeatDaily': repeatDaily,
      'vibration': vibration,
      'createdAt': Timestamp.now(),
    };

    await _firestore.collection('users').doc(user.uid).collection('reminders').add(reminder);
  }

  /// Apaga um lembrete específico do Firestore
  Future<void> deleteReminder(String reminderId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    await _firestore.collection('users').doc(user.uid).collection('reminders').doc(reminderId).delete();
  }

  /// Recupera os lembretes do Firestore (stream)
  Stream<QuerySnapshot> getRemindersStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    return _firestore.collection('users').doc(user.uid).collection('reminders').snapshots();
  }
}
