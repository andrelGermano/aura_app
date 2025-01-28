import 'package:aura_novo/ui/pages/home_page.dart';
import 'package:aura_novo/ui/pages/login_or_register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Verifica se o usuário está autenticado e exibe a página correspondente (Home ou Login)
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Monitora as mudanças no estado de autenticação
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Exibe o carregamento enquanto espera a autenticação
            );
          }
          if (snapshot.hasData) {
            return const HomePage(); // Usuário autenticado, exibe a Home
          } else {
            return const LoginOrRegisterPage(); // Usuário não autenticado, exibe a tela de login
          }
        },
      ),
    );
  }
}
