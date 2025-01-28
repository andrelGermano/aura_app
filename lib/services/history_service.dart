import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adiciona atividade no Firestore
  Future<void> addActivityToHistory({required String name, required String description}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    // Adiciona atividade no Firestore
    await _firestore.collection('users').doc(user.uid).collection('history').add({
      'name': name,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Excluir a atividade
  Future<void> deleteActivity(String activityId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    await _firestore.collection('users').doc(user.uid).collection('history').doc(activityId).delete();
  }

  // Obter o histórico agrupado por data
  Stream<List<Map<String, dynamic>>> getHistoryGroupedByDate() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado!");
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final Map<String, List<Map<String, dynamic>>> groupedData = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['createdAt'] as Timestamp).toDate();
        final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        if (!groupedData.containsKey(dateString)) {
          groupedData[dateString] = [];
        }

        groupedData[dateString]?.add({
          ...data,
          'id': doc.id,
        });
      }

      return groupedData.entries.map((entry) {
        return {
          'date': entry.key,
          'activities': entry.value,
        };
      }).toList();
    });
  }

}
