import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para fazer login com email e senha
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Função para fazer cadastro com email e senha
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Após o cadastro, pode criar dados adicionais no Firestore
      await _saveUserInfo(credential.user!);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Função para resetar a senha
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Função para fazer logout
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Função para obter o email do usuário atual
  String getCurrentUserEmail() {
    return _firebaseAuth.currentUser!.email!;
  }

  // Função para login anônimo
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Função para salvar informações no Firestore
  Future<void> _saveUserInfo(User user) async {

    if (user.uid.isEmpty) {
      throw Exception("UID do usuário é inválido.");
    }

    try {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      Map<String, dynamic> userData = {
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await userDoc.set(userData);
    } catch (e) {
      throw Exception("Erro ao salvar dados do usuário no Firestore: $e");
    }
  }

  // Função para buscar dados do usuário no Firestore
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Erro ao buscar dados do usuário no Firestore: $e");
      return null;
    }
  }
}