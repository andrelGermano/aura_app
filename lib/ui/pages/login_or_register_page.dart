import 'package:aura_novo/ui/pages/register_page.dart';
import 'package:aura_novo/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

// Widget responsável por alternar entre as páginas de Login e Registro
class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Controle de qual página deve ser exibida: Login ou Registro
  bool shouldShowLoginPage = true;

  // Alterna entre as páginas de Login e Registro
  void togglePages() {
    setState(() {
      shouldShowLoginPage = !shouldShowLoginPage; // Inverte o estado atual
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verifica o estado atual e exibe a página correspondente
    return shouldShowLoginPage
        ? LoginPage(
      onTap: togglePages, // Chama a função para alternar as páginas
    )
        : RegisterPage(
      onTap: togglePages, // Chama a função para alternar as páginas
    );
  }
}
