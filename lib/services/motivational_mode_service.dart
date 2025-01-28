import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MotivationalModeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Inicializa a coleção `motivationalMode` para o usuário, se não existir
  Future<void> initializeMotivationalModeCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final motivationalModeDoc = _firestore.collection('users').doc(user.uid).collection('motivationalMode').doc('config');

    // Verifica se o documento já existe
    final snapshot = await motivationalModeDoc.get();
    if (!snapshot.exists) {
      // Cria um documento inicial com valores padrão
      await motivationalModeDoc.set({
        'horas': 0,
        'minutos': 0,
        'on': false,
        'updatedAt': Timestamp.now(),
      });
    }
  }

  /// Liga ou desliga o modo motivacional e atualiza no Firestore
  Future<void> toggleMotivationalMode(bool isOn) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final motivationalModeDoc = _firestore.collection('users').doc(user.uid).collection('motivationalMode').doc('config');

    await motivationalModeDoc.update({
      'on': isOn,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Atualiza as configurações do modo motivacional (horas, minutos e estado)
  Future<void> updateMotivationalMode({
    required int horas,
    required int minutos,
    required bool isOn,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final motivationalModeDoc = _firestore.collection('users').doc(user.uid).collection('motivationalMode').doc('config');

    await motivationalModeDoc.set({
      'horas': horas,
      'minutos': minutos,
      'on': isOn,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Recupera os dados do modo motivacional a partir do Firestore
  Future<Map<String, dynamic>?> getMotivationalMode() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    final motivationalModeDoc = _firestore.collection('users').doc(user.uid).collection('motivationalMode').doc('config');

    final snapshot = await motivationalModeDoc.get();
    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }

  /// Recupera o modo motivacional como um stream (para mudanças em tempo real)
  Stream<DocumentSnapshot> getMotivationalModeStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    return _firestore.collection('users').doc(user.uid).collection('motivationalMode').doc('config').snapshots();
  }
}
