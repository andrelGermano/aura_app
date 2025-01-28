import 'package:aura_novo/services/auth_service.dart';
import 'package:aura_novo/ui/widgets/custom_password_form_field.dart';
import 'package:aura_novo/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';

// Página de Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});

  // Função opcional para alternar para a página de cadastro
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para os campos de email e senha
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Função para realizar o login
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // Tenta realizar o login com email e senha
      await authService.signInWithEmailAndPassword(
        emailController.value.text, // Obtém o valor do email
        passwordController.value.text, // Obtém o valor da senha
      );
    } catch (e) {
      // Exibe uma mensagem de erro caso o login falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // Exibe o erro como texto
        ),
      );
    }
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores quando o widget for descartado
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Cor de fundo personalizada
      body: SingleChildScrollView( // Permite rolagem caso o conteúdo exceda o tamanho da tela
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Espaçamento horizontal
          child: Column(
            children: [
              const SizedBox(height: 100), // Espaço no topo
              Image.asset(
                "assets/images/ic_launcher_foreground.png", // Logo do app
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 30), // Espaçamento
              Text(
                'Bem-vindo ao Aura', // Título da página
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Acompanhe e priorize seu bem-estar', // Descrição do app
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface, // Fundo do container
                  borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Sombra
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Campo de entrada para email
                    CustomTextFormField(
                      labelText: "Email",
                      controller: emailController, // Controlador do campo
                    ),
                    const SizedBox(height: 15),
                    // Campo de entrada para senha
                    CustomPasswordFormField(
                      labelText: "Senha",
                      controller: passwordController, // Controlador do campo
                    ),
                    const SizedBox(height: 20),
                    // Botão para realizar o login
                    CustomButton(
                      text: "Entrar",
                      height: 50,
                      onClick: signIn, // Chama a função de login ao clicar
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Linha com texto e botão para alternar para a página de cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Não tem conta?", // Texto fixo
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap, // Alterna para a página de cadastro
                    child: Text(
                      " Cadastre-se",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
